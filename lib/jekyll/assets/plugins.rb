# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

module Jekyll
  module Assets
    Plugins = Module.new
  end
end

# --
# @see plugins/**/*
# Require all our plugins.
# @return [nil]
# --
Dir.children("#{__dir__}/plugins") do |v|
  unless v.directory?
    require v
  end
end
