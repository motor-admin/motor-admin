<template>
  <Card class="mb-3">
    <RadioGroup
      v-model="configsValue.service"
      class="d-flex"
    >
      <Radio
        v-for="(option, index) in serviceOptions"
        :key="option.value"
        :label="option.value"
        border
        size="large"
        :style="index !== 0 ? 'margin-left: 15px !important' : ''"
        class="my-1 me-0 w-100"
      >
        {{ option.label }}
      </Radio>
    </RadioGroup>
    <Divider class="mb-3" />
    <AwsS3Form
      v-if="configsValue.service === 'aws_s3'"
      :configs="configsValue.configs"
      @success="showSuccessMessage"
    />
    <GcsForm
      v-if="configsValue.service === 'google'"
      :configs="configsValue.configs"
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
import GcsForm from 'application/components/gcs_form'

export default {
  name: 'EmailSettingsPage',
  components: {
    AwsS3Form,
    GcsForm
  },
  data () {
    return {
      isLoaded: false,
      configsValue: { service: 'aws_s3', configs: {} }
    }
  },
  computed: {
    serviceOptions () {
      return [
        { label: 'S3', value: 'aws_s3' },
        { label: 'Google Cloud', value: 'google' }
      ]
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
        this.configsValue = result.data.data.value
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
