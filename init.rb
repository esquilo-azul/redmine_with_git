# coding: utf-8

require 'redmine'

Redmine::Plugin.register :redmine_with_git do
  name 'Redmine + Git'
  author 'Eduardo Henrique Bogoni'
  description 'Redmine + Git'
  version '0.0.0'
  url 'http://172.18.4.200/redmine/projects/redmine'
  author_url 'http://172.18.4.200/redmine/projects/seinf-ap'

  requires_redmine_plugin :redmine_git_hosting, version_or_higher: '1.0.4'
end
