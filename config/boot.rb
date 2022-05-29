# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

module FasterRequire
  # rubocop:disable Style/MutableConstant
  LOADED_CACHE = {}
  # rubocop:enable Style/MutableConstant

  @absolute_paths_cache = {}
  @cached_load_paths = []
  @load_path_hash = 0

  FILE_EXTENSIONS = %w[rb bundle so].freeze
  FILE_EXTENSIONS_REGEXP = /\.(?:#{FILE_EXTENSIONS.join('|')})\z/

  module_function

  def setup
    Kernel.alias_method(:require_without_cache, :require)

    Kernel.define_method(:require) do |path|
      return false if FasterRequire::LOADED_CACHE[path]

      abs_path = FasterRequire.find_absolute_path(path)

      if abs_path.start_with?('/') && abs_path.end_with?('.bundle', '.so')
        f = File.new("/tmp/#{abs_path.split('/').last}", 'w')
        f.write(File.read(abs_path).force_encoding('UTF-8'))
        f.close

        abs_path = f.path
      end

      FasterRequire::LOADED_CACHE[path] = require_without_cache(abs_path)
    end
  end

  def find_absolute_path(path)
    fill_absolute_paths_cache if @load_path_hash != $LOAD_PATH.hash

    @absolute_paths_cache.fetch(path, path)
  end

  def fill_absolute_paths_cache
    paths = $LOAD_PATH.map(&:to_s) - @cached_load_paths

    @cached_load_paths += paths

    load_paths_regexp = %r{\A(?:#{Regexp.union(paths).source})/}

    Dir["{#{paths.join(',')}}/**/*.{#{FILE_EXTENSIONS.join(',')}}"].each do |absolute_path|
      path = absolute_path.sub(load_paths_regexp, '')

      @absolute_paths_cache[path] = absolute_path
      @absolute_paths_cache[path.sub(FILE_EXTENSIONS_REGEXP, '')] = absolute_path
    end

    @load_path_hash = $LOAD_PATH.hash
  end
end

File.singleton_class.alias_method(:original_readable?, :readable?)
File.singleton_class.define_method(:readable?) do |path|
  return File.file?(path) if path.start_with?('/__enclose_io_memfs__/')

  original_readable?(path)
end

FasterRequire.setup if ENV['RAILS_ENV'] == 'production'

begin
  require 'pg'
rescue LoadError
  false
end

begin
  require 'mysql2'
rescue LoadError
  false
end

begin
  require 'tiny_tds'
  require 'active_support/core_ext/kernel'
  require 'activerecord-sqlserver-adapter'
rescue LoadError
  false
end
