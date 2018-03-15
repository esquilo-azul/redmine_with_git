namespace :redmine_with_git do
  namespace :dump do
    task :database, [:path, :overwrite] => :environment do |_t, args|
      ::RedmineWithGit::Dump::Database.new(args.path, args.overwrite.present?)
    end
  end
end
