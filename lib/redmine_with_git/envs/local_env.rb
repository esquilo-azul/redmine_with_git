module RedmineWithGit
  module Envs
    class LocalEnv < RedmineWithGit::Envs::BaseEnv
      def to_s
        'LOCAL'
      end

      def command_line(line)
        line
      end
    end
  end
end
