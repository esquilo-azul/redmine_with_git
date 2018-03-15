module RedmineWithGit
  module Dump
    class Base
      include ::ActionView::Helpers::NumberHelper

      def initialize(path, overwrite)
        @path = path
        @overwrite = overwrite
        run
      end

      private

      attr_reader :path, :overwrite

      def resource_name
        self.class.name.demodulize.underscore
      end

      def run
        start_banner
        if ::File.exist?(path) && !overwrite
          Rails.logger.warn "File \"#{path}\" already exists"
          return
        end
        build_command.execute!(output_file: path)
        end_banner
      end

      def start_banner
        Rails.logger.info "Dumping resource \"#{resource_name}\" to \"#{path}\"..."
      end

      def end_banner
        Rails.logger.info("#{path}: #{number_to_human_size(::File.size(path))}, #{path_type}")
      end

      def env
        RedmineWithGit::Envs.local
      end

      def path_type
        env.command('file', '-b', path).execute!
      end

      def create_tar_command(dir, compression = true)
        tar = "cd #{Shellwords.escape(dir)}; tar -c *"
        tar << " | #{compress_args.join(' ')}" if compression
        env.command(['bash', '-c', tar])
      end

      def compress_args
        %w(gzip -9 -c -)
      end
    end
  end
end
