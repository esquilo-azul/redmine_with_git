# frozen_string_literal: true

require 'eac_ruby_utils/listable'

module RedmineWithGit
  module Dump
    class Base < ::RedmineWithGit::DumpLoad::Base
      include ::EacRubyUtils::Listable

      lists.add_integer :overwrite, 1 => :denied, 2 => :allowed

      def initialize(path, options = {})
        @options = options
        validate_overwrite
        super(path)
      end

      def overwrite
        v = @options[:overwrite]
        v.present? ? v.to_i : OVERWRITE_DENIED
      end

      private

      def run
        start_banner
        if ::File.exist?(path) && overwrite == OVERWRITE_DENIED
          Rails.logger.warn "File \"#{path}\" already exists"
          return
        end
        run_command
        validate_exported
        end_banner
      end

      def start_banner
        Rails.logger.info "Dumping resource \"#{resource_name}\" to \"#{path}\"..."
        Rails.logger.info "Overwrite: #{overwrite}"
      end

      def end_banner
        Rails.logger.info("#{path}: #{number_to_human_size(::File.size(path))}, #{path_type}")
      end

      def run_command
        build_command.execute!(output_file: path)
      end

      def create_tar_command(dir, compression = true)
        tar = "cd #{Shellwords.escape(dir)}; tar -c *"
        tar += " | #{compress_args.join(' ')}" if compression
        env.command(['bash', '-c', tar])
      end

      def compress_args
        %w[gzip -9 -c -]
      end

      def validate_exported
        raise "File \"#{path}\" was not generated" unless ::File.exist?(path)
        raise "File \"#{path}\" has zero size" unless ::File.size(path).positive?
      end

      def validate_overwrite
        klass = ::RedmineWithGit::Dump::Base
        return if klass.lists.overwrite.values.include?(overwrite)

        raise "Invalid overwrite value: \"#{overwrite}\" (Valid: #{klass.lists.overwrite.values})"
      end
    end
  end
end
