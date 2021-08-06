<template>
  <Card class="mb-3">
    <EmailForm
      :configs="configs"
      :submit-text="'Update'"
      @success="showSuccessMessage"
    />
  </Card>
  <Spin
    v-if="!isLoaded"
    fix
  />
</template>

<script>
import api from 'application/api'
import EmailForm from 'application/components/email_form'

export default {
  name: 'EmailSettingsPage',
  components: {
    EmailForm
  },
  data () {
    return {
      isLoaded: false,
      configs: {}
    }
  },
  mounted () {
    this.loadConfigs().then(() => {
      this.isLoaded = true
    })
  },
  methods: {
    loadConfigs () {
      return api.get('encrypted_configs/email.smtp').then((result) => {
        this.configs = result.data.data.value
      }).catch((error) => {
        console.error(error)
      })
    },
    showSuccessMessage () {
      this.$Message.info('Email settings have been updated successfuly')
    }
  }
}
</script>
