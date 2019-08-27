# frozen_string_literal: true

class BackupController < ApplicationController
  before_filter :require_admin

  accept_api_auth :export, :import

  helper ::RedmineWithGitHelper

  def index
    @load = ::RedmineWithGit::Tableless::Load.new
  end

  def export
    Tempfile.open('redmine_export') do |file|
      ::RedmineWithGit::Dump::All.new(
        file.path,
        overwrite: ::RedmineWithGit::Dump::Base::OVERWRITE_ALLOWED
      )
      send_file(file.path, filename: export_file_name, type: 'application/x-tar',
                           size: file.size)
    end
  end

  def import
    @load = ::RedmineWithGit::Tableless::Load.new(import_params)
    @load.save
    respond_to do |format|
      format.html { import_respond_to_html }
      format.api { render_validation_errors(@load) }
    end
  end

  private

  def import_respond_to_html
    if @load.errors.empty?
      redirect_to backup_path, notice: 'Backup imported'
    else
      render :index
    end
  end

  def export_file_name
    "redmine-backup_#{Time.zone.now.strftime('%Y-%m-%d_%H-%M-%S')}.tar"
  end

  def import_params
    ps = params[::RedmineWithGit::Tableless::Load.model_name.param_key]
    return {} if ps.blank?

    ps.permit(:path)
  end
end
