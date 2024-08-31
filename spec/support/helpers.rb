# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require "forwardable/extended"
require "nokogiri"
require "yaml"

module Helpers
  extend Forwardable::Extended
  rb_delegate :stub_jekyll_site, to: :Helpers
  rb_delegate :stub_env, to: :Helpers

  def fragment(html)
    Nokogiri::HTML.fragment(
      html
    )
  end

  def self.silence_stdout
    stdout, stderr = $stdout, $stderr
    $stdout = StringIO.new
    $stderr = StringIO.new

    yield
  ensure
    $stdout = stdout
    $stderr = stderr
  end

  def stub_jekyll_config(hash)
    hash = hash.deep_stringify_keys
    hash = jekyll.config.deep_merge(hash)
    allow(jekyll).to(receive(:config)
      .and_return(hash))
  end

  def stub_asset_config(hash)
    hash = env.asset_config.deep_merge(hash)
    allow(env).to(receive(:asset_config)
      .and_return(hash))
  end

  def self.cleanup_trash
    FileUtils.rm_rf("#{fixture_path}/_site")
    FileUtils.rm_rf(%w(.jekyll-metadata .sass-cache .jekyll-cache))
  end

  def self.stub_jekyll_site
    @jekyll ||= begin
      silence_stdout do
        cfg = YAML.load_file("#{fixture_path}/_config.yml")
        cfg = Jekyll.configuration(cfg).update({
          "source" => fixture_path.to_s,
          "destination" => File.join(
            fixture_path, "_site"
          )
        })

        Jekyll::Site.new(cfg).tap( &:process)
      end
    end
  end

  def self.stub_env
    return @env if defined?(@env)
    @env = Jekyll::Assets::Env.new(
      stub_jekyll_site
    )
  end

  def self.fixture_path
    File.expand_path(
      "../fixture", __dir__
    )
  end
end

RSpec.configure do |c|
  c.before(:suite) { Helpers.tap(&:cleanup_trash).stub_jekyll_site }
  c. after(:suite) { Helpers.cleanup_trash }
  c.include Helpers
  c.extend  Helpers
end
