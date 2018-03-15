module RedmineWithGit
  module Dump
    class Git < ::RedmineWithGit::Dump::Base
      private

      def build_command
        create_tar_command(repositories_path).prepend(sudo_command)
      end

      def repositories_path
        ::RedmineGitHosting::Config.gitolite_global_storage_dir
      end

      def sudo_command
        ::RedmineGitHosting::Commands.send(:sudo)
      end
    end
  end
end
