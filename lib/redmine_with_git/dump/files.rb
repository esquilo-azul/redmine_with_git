module RedmineWithGit
  module Dump
    class Files < ::RedmineWithGit::Dump::Base
      private

      def build_command
        create_tar_command(files_path)
      end

      def create_tar_command(dir)
        env.command(['bash', '-c', "cd #{Shellwords.escape(dir)}; tar -c * | " <<
            compress_args.join(' ')])
      end

      def files_path
        Rails.root.join('files')
      end
    end
  end
end
