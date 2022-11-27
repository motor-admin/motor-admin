<template>
  <Card
    class="mb-3"
    :class="{ 'py-2' : role.name === 'superadmin' }"
  >
    <div class="row">
      <div class="col-10 d-flex align-items-center">
        <Icon
          class="me-1"
          type="ios-person"
        />
        {{ role.name }}
      </div>
      <div class="col-2 d-flex justify-content-end align-items-center">
        <VButton
          v-if="role.name !== 'superadmin'"
          type="text"
          size="large"
          @click="openEditModal"
        >
          <Icon
            type="md-settings"
            size="large"
          />
        </VButton>
      </div>
    </div>
  </Card>
</template>

<script>
import RoleForm from './role_form'

export default {
  name: 'Role',
  props: {
    role: {
      type: Object,
      required: true
    }
  },
  emits: ['update'],
  methods: {
    openEditModal () {
      this.$Drawer.open(RoleForm, {
        role: this.role,
        mode: 'update',
        onRemove: () => {
          this.$Drawer.remove()

          this.$emit('update')
        },
        onSuccess: (data) => {
          this.$Drawer.remove()

          this.$emit('update')
        }
      }, {
        title: `Edit Role: ${this.role.name}`,
        className: 'drawer-no-bottom-padding',
        closable: true
      })
    }
  }
}
</script>

<style lang="scss" scoped>
:deep(.ivu-card-body) {
  padding: 8px 16px;
}
</style>
