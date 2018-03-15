module RedmineWithGit
  module Dump
    class Files < ::RedmineWithGit::Dump::Base
      private

      def build_command
        create_tar_command(files_path)
      end

      def files_path
        Rails.root.join('files')
      end
    end
  end
end
