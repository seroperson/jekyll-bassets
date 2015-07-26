module Jekyll
  module Assets

    # TODO: jekyll/jekyll@upstream add support for blocks as messages...
    # NOTE: This is a temporary class, until we can go upstream and fix
    #   the little known fact that it doesn't accept a block for a message
    #   it is passing on.  Until then we are holding this.

    class Logger
      def instance
        @logger ||= Jekyll.logger
      end

      # @see Jekyll.logger.methods

      %W(warn error info debug).each do |k|
        define_method k do |msg = nil, &block|
          instance.send(k, "Jekyll Assets:", block ? block.call : msg)
        end
      end

      # We don't let you set the logger level here because we are just
      # wrapping around Jekyll's own logger and making sure it supports the
      # most basic logging behavior, blocks as msgs being sent.

      def log_level=(*a)
        raise RuntimeError, "Please set log levels on Jekyll.logger"
      end
    end
  end
end
