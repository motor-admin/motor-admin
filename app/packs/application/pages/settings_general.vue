<template>
  <Card>
    <UserForm
      :user="currentUser"
      :require-password="false"
      :mode="'update'"
      :submit-text="'Update'"
      @success="onUserUpdate"
    />
  </Card>
  <Card class="mt-3">
    <SubscribeForm
      :submit-text="'Subscribe'"
      :email="currentUser.email"
      @success="subscribeSuccesMessage"
    />
  </Card>
  <VButton
    size="large"
    class="my-3 bg-white"
    long
    type="error"
    ghost
    @click="signOut"
  >
    <Icon type="ios-log-out" />
    Sign Out
  </VButton>
</template>

<script>
import api from 'application/api'
import UserForm from 'application/components/user_form'
import SubscribeForm from 'application/components/subscribe_form'
import { basePath } from 'application/scripts/configs'
import { currentUser, setCurrentUser } from 'application/scripts/current_user'

export default {
  name: 'GeneralSettingsPage',
  components: {
    UserForm,
    SubscribeForm
  },
  computed: {
    currentUser: () => currentUser
  },
  methods: {
    signOut () {
      api.delete('session').then((_result) => {
        window.location.href = basePath === '/' ? '/sign_in' : basePath + '/sign_in'
      }).catch((error) => {
        console.error(error)
      })
    },
    onUserUpdate (user) {
      setCurrentUser(user)

      this.$Message.info('User has been updated successfully')
    },
    subscribeSuccesMessage () {
      this.$Message.info('You have been subscribed successfully')
    }
  }
}
</script>
