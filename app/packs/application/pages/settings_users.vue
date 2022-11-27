<template>
  <div v-if="users.length">
    <User
      v-for="user in users"
      :key="user.id"
      :user="user"
      class="mb-3"
      :removable="user.email.toLowerCase() !== currentUser.email.toLowerCase()"
      @update="loadUsers"
    />
    <VButton
      role="addUserBtn"
      size="large"
      long
      class="mb-3"
      type="dashed"
      @click="openAddUserModal"
    >
      <Icon type="md-add" />
      Add User
    </VButton>
  </div>
  <Spin
    v-if="isLoading"
    fix
  />
</template>

<script>
import api from 'application/api'

import UserForm from 'application/components/user_form'
import User from 'application/components/user'
import { currentUser } from 'application/scripts/current_user'

let usersCache = []

export default {
  name: 'UsersSettingsPage',
  components: {
    User
  },
  data () {
    return {
      users: usersCache,
      isLoading: true
    }
  },
  computed: {
    currentUser: () => currentUser
  },
  mounted () {
    this.loadUsers().then(() => {
      this.isLoading = false
    })
  },
  methods: {
    loadUsers () {
      return api.get('admin_users').then((result) => {
        this.users = result.data.data
        usersCache = this.users
      }).catch((error) => {
        console.error(error)
      })
    },
    openAddUserModal () {
      this.$Modal.open(UserForm, {
        onSuccess: (data) => {
          this.$Modal.remove()
          this.$Message.info(`${data.email} user has been added`)

          this.loadUsers()
        }
      }, {
        closable: true
      })
    }
  }
}
</script>
