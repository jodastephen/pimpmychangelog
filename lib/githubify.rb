class Githubifier

  attr_reader :user, :project, :changelog

  def initialize(user, project, changelog)
    @user = user
    @project = project
    @changelog = changelog
  end

  # @return [String] The changelog with contributors and issues as link
  def better_changelog
    @better_changelog = changelog.clone

    linkify_changelog!
    append_links_definition_to_changelog!

    @better_changelog
  end

  # @return [Array] issue numbers found in the changelog
  #   Example: ['123', '223', '470']
  def issues
    changelog.scan(/#(\d+)/).uniq.sort.flatten
  end

  # @return [Array] contributors found in the changelog
  #   Example: ['gregbell', 'pcreux', 'samvincent']
  def contributors
    changelog.scan(/@(\w+)/).uniq.sort.flatten
  end

  ISSUE_NUMBER_REGEXP = /(^|[^\[])#(\d+)($|[^\]])/
  CONTRIBUTOR_REGEXP = /(^|[^\[])@(\w+)($|[^\]])/

  def linkify_changelog!
    @better_changelog.gsub!(ISSUE_NUMBER_REGEXP, '\1[#\2][]\3')
    @better_changelog.gsub!(CONTRIBUTOR_REGEXP, '\1[@\2][]\3')
  end

  def append_links_definition_to_changelog!
    issues.each do |issue|
      @better_changelog += "\n[##{issue}]: https://github.com/#{user}/#{project}/issues/#{issue}"
    end

    contributors.each do |contributor|
      @better_changelog += "\n[@#{contributor}]: https://github.com/#{contributor}"
    end
  end
end
