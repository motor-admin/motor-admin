# frozen_string_literal: true

module Motor
  module AdminUsers
    ROLES_CACHE = ActiveSupport::Cache::MemoryStore.new(size: 5.megabytes)

    module_function

    def load_roles_from_cache(admin_user)
      cache_key =
        if admin_user.id
          [
            admin_user.id,
            admin_user.updated_at.hash,
            admin_user.roles.maximum(:updated_at).hash
          ]
        else
          [nil, nil, Motor::Role.where(id: admin_user.roles.map(&:id)).maximum(:updated_at).hash]
        end.join(':')

      ROLES_CACHE.fetch(cache_key) do
        admin_user.roles.flat_map(&:attributes)
      end
    end
  end
end
