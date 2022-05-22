<template>
  <VForm
    ref="form"
    :model="configs"
    :rules="rules"
    @keyup.enter="handleSubmit"
  >
    <div class="row">
      <FormItem
        prop="access_key_id"
        label="Access key ID"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="configs.access_key_id"
          type="text"
        />
      </FormItem>
      <FormItem
        prop="secret_access_key"
        label="Secret access key"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="configs.secret_access_key"
          type="password"
          placeholder="**********"
        />
      </FormItem>
      <FormItem
        prop="region"
        label="Region"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="configs.region"
          type="text"
          placeholder="us-east-1"
        />
      </FormItem>
      <FormItem
        prop="bucket"
        label="Bucket"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="configs.bucket"
          placeholder="s3-bucket-name"
        />
      </FormItem>
      <FormItem
        prop="endpoint"
        label="Endpoint"
        class="col-12"
      >
        <VInput
          v-model="configs.endpoint"
          type="text"
          placeholder=""
        />
        <small>Use custom endoint for S3 compatible API like MinIO. Leave it blank for AWS S3</small>
      </FormItem>
    </div>
    <VButton
      type="primary"
      class="mt-1"
      size="large"
      long
      @click="handleSubmit"
    >
      Submit
    </VButton>
    <Spin
      v-if="isLoading"
      fix
    />
  </VForm>
</template>

<script>
import api from 'application/api'

export default {
  name: 'AwsS3Form',
  props: {
    configs: {
      type: Object,
      required: true
    }
  },
  emits: ['success', 'error'],
  data () {
    return {
      isLoading: false
    }
  },
  computed: {
    rules () {
      return {
        access_key_id: [{ required: true }],
        secret_access_key: [{ required: true }],
        region: [{ required: true }],
        bucket: [{ required: true }]
      }
    }
  },
  methods: {
    submit () {
      this.isLoading = true

      api.post('encrypted_configs', {
        data: {
          key: 'files.storage',
          value: {
            service: 'aws_s3',
            configs: this.configs
          }
        }
      }).then((result) => {
        this.$emit('success', result.data.data)
      }).catch((error) => {
        console.error(error)
        this.$emit('error', error)
      }).finally(() => {
        this.isLoading = false
      })
    },
    handleSubmit () {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.submit()
        }
      })
    }
  }
}
</script>
