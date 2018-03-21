module RedmineWithGitHelper
  def export_api_curl_command
    curl_command("curl -JLO '#{export_redmine_with_git_url(key: User.current.api_key)}'")
  end

  private

  def curl_command(command)
    content_tag(:pre, command)
  end
end
