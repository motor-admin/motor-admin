<template>
  <div v-if="roles.length">
    <Role
      v-for="role in roles"
      :key="role.id"
      :role="role"
      @update="loadRoles"
    />
    <VButton
      size="large"
      long
      type="dashed"
      class="mb-3"
      @click="openAddRoleModal"
    >
      <Icon type="md-add" />
      Add Role
    </VButton>
  </div>
  <Spin
    v-if="!isLoaded"
    fix
  />
</template>

<script>
import api from 'application/api'
import Role from '../components/role'
import RoleForm from '../components/role_form'

let rolesCache = []

export default {
  name: 'RolesSettingsPage',
  components: {
    Role
  },
  data () {
    return {
      roles: rolesCache,
      isLoaded: false
    }
  },
  mounted () {
    this.loadRoles().then(() => {
      this.isLoaded = true
    })
  },
  methods: {
    loadRoles () {
      return api.get('roles').then((result) => {
        this.roles = result.data.data
        rolesCache = this.roles
      }).catch((error) => {
        console.error(error)
      })
    },
    openAddRoleModal () {
      this.$Drawer.open(RoleForm, {
        onSuccess: (data) => {
          this.$Drawer.remove()
          this.$Message.info(`${data.name} role has been added`)

          this.loadRoles()
        }
      }, {
        title: 'Create New Role',
        closable: true
      })
    }
  }
}
</script>
