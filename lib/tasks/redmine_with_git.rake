namespace :redmine_with_git do
  namespace :dump do
    %w(database files git all).each do |a|
      task a, [:path, :overwrite] => :environment do |_t, args|
        ::RedmineWithGit::Dump.const_get(a.camelize).new(args.path, args.overwrite.present?)
      end
    end
  end
  namespace :load do
    %w(database files).each do |a|
      task a, [:path] => :environment do |_t, args|
        ::RedmineWithGit::Load.const_get(a.camelize).new(args.path)
      end
    end
  end
end
