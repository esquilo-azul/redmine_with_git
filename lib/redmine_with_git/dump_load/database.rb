# frozen_string_literal: true

module RedmineWithGit
  module DumpLoad
    module Database
      def build_postgres_command(command, args = [])
        env.command(
          [password_arg, command, '-h', database_schema['host'], '-U',
           database_schema['username'], '-d', database_schema['database']] + args
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
