<template>
  <Card class="mb-3">
    <AwsS3Form
      :configs="configs"
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
import AwsS3Form from 'application/components/aws_s3_form'

export default {
  name: 'EmailSettingsPage',
  components: {
    AwsS3Form
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
      return api.get('encrypted_configs/files.storage').then((result) => {
        this.configs = result.data.data.value.configs
      }).catch((error) => {
        console.error(error)
      })
    },
    showSuccessMessage () {
      this.$Message.info('AWS S3 settings have been updated successfuly')
    }
  }
}
</script>
