# frozen_string_literal: true

module Motor
  module AdminUsers
    PERMISSIONS_CACHE = ActiveSupport::Cache::MemoryStore.new(size: 5.megabytes)

    module_function

    def load_permissions_from_cache(admin_user)
      cache_key = [admin_user.id, admin_user.updated_at.hash].join(':')

      PERMISSIONS_CACHE.fetch(cache_key) do
        admin_user.roles.flat_map(&:rules)
      end
    end
  end
end
