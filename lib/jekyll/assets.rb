# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Author: Jordon Bedwell
# Encoding: utf-8

require "fileutils"
require "jekyll/assets/version"
require "active_support/hash_with_indifferent_access"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/hash/deep_merge"
require "forwardable/extended"
require "jekyll/sanity"
require "sprockets"
require "jekyll"

module Jekyll
  module Assets
    # Fixes "Encoding::InvalidByteSequenceError - "\xE2" on US-ASCII"
    Encoding.default_external = 'UTF-8'

    autoload :Cache, "jekyll/assets/cache"
    autoload :Config, "jekyll/assets/config"
    autoload :Default, "jekyll/assets/default"
    autoload :Drop, "jekyll/assets/drop"
    autoload :Env, "jekyll/assets/env"
    autoload :Errors, "jekyll/assets/errors"
    autoload :Extensible, "jekyll/assets/extensible"
    autoload :Filters, "jekyll/assets/filters"
    autoload :Hook, "jekyll/assets/hook"
    autoload :HTML, "jekyll/assets/html"
    autoload :Logger, "jekyll/assets/logger"
    autoload :Manifest, "jekyll/assets/manifest"
    autoload :Proxy, "jekyll/assets/proxy"
    autoload :Tag, "jekyll/assets/tag"
    autoload :Url, "jekyll/assets/url"
    autoload :Utils, "jekyll/assets/utils"
    Dir.glob(File.join(__dir__, '**', '*.rb'), &method(:require))

    # --
    # Setup Jekyll Assets
    # @see require_patches!
    # @see before_hook!
    # @see after_hook!
    # @return [nil]
    # --
    def self.setup!
      require_patches!
      # require_plugins!
      %i(read write).each do |v|
        send(:"#{v}_hook!")
      end
    end

    # --
    # Require all our patches
    # @return [nil]
    # --
    def self.require_patches!
      Dir.children("#{__dir__}/assets/patches/").each do |v|
        unless File.directory?("#{__dir__}/assets/patches/#{v}")
          require "#{__dir__}/assets/patches/#{v}"
        end
      end
    end

    # --
    # Require all plugins
    # @return [nil]
    # --
    def self.require_plugins!
      Dir.children("#{__dir__}/assets/plugins/").each do |v|
        unless File.directory?("#{__dir__}/assets/plugins/#{v}")
          require "#{__dir__}/assets/plugins/#{v}"
        end
      end
      Dir.children("#{__dir__}/assets/plugins/html/").each do |v|
        unless File.directory?("#{__dir__}/assets/plugins/html/#{v}")
          require "#{__dir__}/assets/plugins/html/#{v}"
        end
      end
      Dir.children("#{__dir__}/assets/plugins/html/defaults/").each do |v|
        unless File.directory?("#{__dir__}/assets/plugins/html/defaults/#{v}")
          require "#{__dir__}/assets/plugins/html/defaults/#{v}"
        end
      end
      Dir.children("#{__dir__}/assets/plugins/proxy").each do |v|
        unless File.directory?("#{__dir__}/assets/plugins/proxy/#{v}")
          require "#{__dir__}/assets/plugins/proxy/#{v}"
        end
      end
      Dir.children("#{__dir__}/assets/plugins/srcmap").each do |v|
        unless File.directory?("#{__dir__}/assets/plugins/srcmap/#{v}")
          require "#{__dir__}/assets/plugins/srcmap/#{v}"
        end
      end
    end

    # --
    # Initialize the environment
    # @note this happens after Jekyll read
    # @return [nil]
    # --
    def self.read_hook!
      Jekyll::Hooks.register :site, :post_read, priority: 99 do |o|
        unless o.sprockets
          Env.new(o)
        end
      end
    end

    # --
    # Write all the assets
    # @note this happens after Jekyll write
    # @return [nil]
    # --
    def self.write_hook!
      Jekyll::Hooks.register :site, :post_write, priority: 99 do |o|
        o&.sprockets&.write_all
      end
    end

    # --
    private_class_method :write_hook!
    private_class_method :require_patches!
    private_class_method :read_hook!

    # --
    setup!
    Filters.register
    Drop.register
    Tag.register
  end
end
