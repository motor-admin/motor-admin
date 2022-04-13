<template>
  <VForm
    ref="form"
    :model="configs"
    :rules="rules"
    @keyup.enter="handleSubmit"
  >
    <div class="row">
      <FormItem
        prop="project"
        label="Project"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="configs.project"
          type="text"
        />
      </FormItem>
      <FormItem
        prop="bucket"
        label="Bucket"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="configs.bucket"
          type="text"
        />
      </FormItem>
      <FormItem
        prop="credentials"
        label="Credentials (JSON key content)"
        class="col-12"
      >
        <VInput
          v-model="configs.credentials"
          type="textarea"
          :autosize="{ minRows: 4, maxRows: 7 }"
        />
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
  name: 'GcsForm',
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
        credentials: [{ required: true }],
        project: [{ required: true }],
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
            service: 'google',
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
