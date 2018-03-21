module RedmineWithGit
  module Load
    class Database < ::RedmineWithGit::Load::Base
      include ::RedmineWithGit::DumpLoad::Database

      private

      def clear_command
        psql_sql_command(psql_sql_command(drop_all_tables_sql).execute!)
      end

      def load_command
        psql_command.prepend(uncompress_args + ['@ESC_|'])
      end

      def psql_command
        env.command(
          [password_arg, 'psql',
           '-h', database_schema['host'], '-U', database_schema['username'], '-d',
           database_schema['database']]
        )
      end

      def psql_sql_command(sql)
        psql_command.append(['-qtc', sql])
      end

      def drop_all_tables_sql
        "select 'drop table \"' || tablename || '\" cascade;' from pg_tables " \
          "where schemaname = 'public';"
      end
    end
  end
end