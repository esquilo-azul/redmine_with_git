class RedmineWithGitController < ApplicationController
  before_filter :require_admin

  def index
  end

  def export
    Tempfile.open('redmine_export') do |file|
      ::RedmineWithGit::Dump::All.new(file.path, true)
      send_file(file.path, filename: export_file_name, type: 'application/x-tar',
                           size: file.size)
    end
  end

  private

  def export_file_name
    "redmine-backup_#{Time.zone.now.strftime('%Y-%m-%d_%H-%M-%S')}.tar"
  end
end
