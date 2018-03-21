RedmineApp::Application.routes.draw do
  get '/redmine_with_git', to: 'redmine_with_git#index', as: 'redmine_with_git'
  get '/redmine_with_git/export', to: 'redmine_with_git#export', as: 'export_redmine_with_git'
end
