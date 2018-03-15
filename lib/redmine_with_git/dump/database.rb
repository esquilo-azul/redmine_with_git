module RedmineWithGit
  module Dump
    class Database < ::RedmineWithGit::Dump::Base
      include ::RedmineWithGit::PostgresqlCommands

      private

      def build_command
        env.command(
          [password_arg, 'pg_dump', '-x', '-c', '-O',
           '-h', database_schema['host'], '-U', database_schema['username'], '-d',
           database_schema['database'], '@ESC_|'] + compress_args
        )
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
