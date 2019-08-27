# frozen_string_literal: true

require 'redmine'
require 'redmine_with_git/version'

require 'eac_rails_utils'
require 'eac_ruby_utils'

Redmine::Plugin.register :redmine_with_git do
  name 'RedmineWithGit'
  author 'Esquilo Azul Company'
  description 'Utilities for Redmine + plugin redmine_git_hosting.'
  version ::RedmineWithGit::VERSION
  url 'https://github.com/esquilo-azul/redmine_with_git'
  author_url 'https://github.com/esquilo-azul'

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :redmine_with_git, { controller: 'backup', action: 'index', id: nil },
              caption: 'Redmine with Git',
              if: proc { User.current.admin? }
  end
end
