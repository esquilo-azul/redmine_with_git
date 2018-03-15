namespace :redmine_with_git do
  namespace :dump do
    %w(database files git).each do |a|
      task a, [:path, :overwrite] => :environment do |_t, args|
        ::RedmineWithGit::Dump.const_get(a.camelize).new(args.path, args.overwrite.present?)
      end
    end
  end
end
