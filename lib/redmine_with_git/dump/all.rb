module RedmineWithGit
  module Dump
    class All < ::RedmineWithGit::Dump::Base
      DATABASE  = 'database.gz'
      FILES = 'files.tar.gz'
      GIT = 'git.tar.gz'

      private

      def run_command
        ::Dir.mktmpdir do |dir|
          @tmpdir = dir
          %w(database files git).each { |a| build_sub(a) }
          super
        end
      end

      def build_sub(a)
        filename = self.class.const_get(a.underscore.upcase)
        klass = ::RedmineWithGit::Dump.const_get(a.camelize)
        klass.new(File.join(@tmpdir, filename), overwrite)
      end

      def build_command
        create_tar_command(@tmpdir, false)
      end
    end
  end
end
