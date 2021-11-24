# frozen_string_literal: true

module MiniMime
  class Db
    class RandomAccessDb
      def lookup(val)
        @cache_hash ||=
          @file.read.split("\n").index_by { |row| row[/\A[^\s]+/] }

        row = @cache_hash[val.downcase]

        return unless row

        MiniMime::Info.new(row)
      end
    end
  end
end
