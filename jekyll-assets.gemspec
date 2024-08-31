# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# rubocop:disable Metrics/BlockLength
# Encoding: utf-8

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "jekyll/assets/version"

Gem::Specification.new do |s|
  s.require_paths = ["lib"]
  s.version = Jekyll::Assets::VERSION
  s.homepage = "http://github.com/jekyll/jekyll-assets/"
  s.authors = ["Jordon Bedwell", "Aleksey V Zapparov", "Zachary Bush"]
  s.email = %w(jordon@envygeeks.io ixti@member.fsf.org zach@zmbush.com)
  s.files = %w(Rakefile Gemfile README.md LICENSE) + Dir["lib/**/*"]
  s.summary = "Assets for Jekyll"
  s.name = "jekyll-assets"
  s.license = "MIT"

  s.description = <<~TXT
    A drop-in Jekyll Plugin that provides an asset pipeline for JavaScript,
    CSS, SASS, SCSS.  Based around Sprockets (from Rails) and just as powereful
    it provides everything you need to manage assets in Jekyll.
  TXT

  s.required_ruby_version = ">= 2.6.0"
  s.add_runtime_dependency("nokogiri")
  s.add_runtime_dependency("activesupport")
  s.add_runtime_dependency("execjs")

  s.add_runtime_dependency("sprockets")
  s.add_runtime_dependency("dartsass-sprockets")

  s.add_runtime_dependency("jekyll")
  s.add_runtime_dependency("jekyll-sanity")

  s.add_runtime_dependency("fastimage")
  s.add_runtime_dependency("liquid-tag-parser")
  s.add_runtime_dependency("fileutils")
  s.add_runtime_dependency("extras")
  s.add_runtime_dependency("ruby-vips")

  s.add_development_dependency("psych", "~> 4.0")
  s.add_development_dependency("rspec")
  s.add_development_dependency("rake")
  s.add_development_dependency("font-awesome-sass")
  s.add_development_dependency("uglifier")
  s.add_development_dependency("mini_racer")
  s.add_development_dependency("image_optim")
  s.add_development_dependency("luna-rspec-formatters")
  s.add_development_dependency("autoprefixer-rails")
  s.add_development_dependency("babel-transpiler")
  s.add_development_dependency("mini_magick")
  s.add_development_dependency("simplecov")
  s.add_development_dependency("bootstrap")
  s.add_development_dependency("crass")
  s.add_development_dependency("pry")
end
