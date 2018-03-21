class RedmineWithGitController < ApplicationController
  before_filter :require_admin

  def index
    @load = ::RedmineWithGit::Tableless::Load.new
  end

  def export
    Tempfile.open('redmine_export') do |file|
      ::RedmineWithGit::Dump::All.new(file.path, true)
      send_file(file.path, filename: export_file_name, type: 'application/x-tar',
                           size: file.size)
    end
  end

  def import
    @load = ::RedmineWithGit::Tableless::Load.new(import_params)
    if @load.save
      redirect_to redmine_with_git_path, notice: 'Backup imported'
    else
      render :index
    end
  end

  private

  def export_file_name
    "redmine-backup_#{Time.zone.now.strftime('%Y-%m-%d_%H-%M-%S')}.tar"
  end

  def import_params
    params[::RedmineWithGit::Tableless::Load.model_name.param_key].permit(:path)
  end
end
