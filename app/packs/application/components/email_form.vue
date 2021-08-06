<template>
  <VForm
    ref="form"
    :model="configs"
    :rules="rules"
    @keyup.enter="handleSubmit"
  >
    <div class="row">
      <FormItem
        prop="host"
        label="Host"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="configs.host"
          type="text"
          placeholder="smtp.example.com"
        />
      </FormItem>
      <FormItem
        prop="port"
        label="Port"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="configs.port"
          type="text"
          placeholder="587"
        />
      </FormItem>
      <FormItem
        prop="username"
        label="Username"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="configs.username"
          type="text"
          placeholder="admin"
        />
      </FormItem>
      <FormItem
        prop="password"
        label="Password"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="configs.password"
          type="password"
          placeholder="**********"
        />
      </FormItem>
      <FormItem
        prop="address"
        label="Send from"
        class="col-12"
      >
        <VInput
          v-model="configs.address"
          placeholder="user@example.com"
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
      {{ submitText }}
    </VButton>
  </VForm>
</template>

<script>
import api from 'application/api'

export default {
  name: 'EmailForm',
  props: {
    configs: {
      type: Object,
      required: true
    },
    submitText: {
      type: String,
      required: false,
      default: 'Submit'
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
        host: [{ required: true }],
        port: [{ required: true }],
        username: [{ required: true }],
        password: [{ required: true }],
        address: [{ required: true }]
      }
    }
  },
  methods: {
    submit () {
      this.isLoading = true

      api.post('encrypted_configs', {
        data: {
          key: 'email.smtp',
          value: this.configs
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
