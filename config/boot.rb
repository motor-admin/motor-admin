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

  FILE_EXTENSIONS = %w[rb].freeze
  FILE_EXTENSIONS_REGEXP = /\.(?:#{FILE_EXTENSIONS.join('|')})\z/

  module_function

  def setup
    Kernel.alias_method(:require_without_cache, :require)

    Kernel.define_method(:require) do |path|
      return false if FasterRequire::LOADED_CACHE[path]

      FasterRequire::LOADED_CACHE[path] = true

      require_without_cache(FasterRequire.find_absolute_path(path))
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

FasterRequire.setup if ENV['RAILS_ENV'] == 'production'
