module RedmineWithGit
  module Dump
    class Database
      include ::ActionView::Helpers::NumberHelper
      include ::RedmineWithGit::PostgresqlCommands

      def initialize(path, overwrite)
        @path = path
        @overwrite = overwrite
        run
      end

      private

      attr_reader :path, :overwrite

      def run
        start_banner
        if ::File.exist?(path) && !overwrite
          Rails.logger.warn "File \"#{path}\" already exists"
          return
        end
        run_command
        end_banner
      end

      def start_banner
        Rails.logger.info "Dumping resource \"Database\" to \"#{path}\"..."
      end

      def end_banner
        Rails.logger.info("#{path}: #{number_to_human_size(::File.size(path))}, #{path_type}")
      end

      def run_command
        env.command(
          [password_arg, 'pg_dump', '-x', '-c', '-O',
           '-h', database_schema['host'], '-U', database_schema['username'], '-d',
           database_schema['database'], '@ESC_|', 'gzip', '-9', '-c', '-']
        ).execute!(output_file: path)
      end

      def env
        RedmineWithGit::Envs.local
      end

      def path_type
        env.command('file', '-b', path).execute!
      end

      def database_schema
        Rails.configuration.database_configuration[Rails.env]
      end

      def password_arg
        '@ESC_PGPASSWORD=' + Shellwords.escape(database_schema['password'])
      end
    end
  end
end
