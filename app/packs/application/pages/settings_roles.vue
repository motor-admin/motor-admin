<template>
  <div v-if="roles.length">
    <Card
      v-for="role in roles"
      :key="role.id"
      class="mb-3"
    >
      <Icon type="ios-person" />
      {{ role.name }}
    </Card>
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

let rolesCache = []

export default {
  name: 'RolesSettingsPage',
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
      this.$Dialog.info({
        title: 'User roles and permissions are available in Motor Admin Pro',
        okText: 'Learn More',
        onOk () {
          location.href = 'https://www.getmotoradmin.com/'
        }
      }, {
        closable: true
      })
    }
  }
}
</script>
