<template>
  <VForm
    ref="form"
    :model="value"
    :rules="rules"
    @keyup.enter="handleSubmit"
  >
    <div class="row">
      <FormItem
        prop="first_name"
        label="First Name"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="value.first_name"
          type="text"
          placeholder="John"
        />
      </FormItem>
      <FormItem
        prop="last_name"
        label="Last Name"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="value.last_name"
          type="text"
          placeholder="Doe"
        />
      </FormItem>
      <FormItem
        prop="email"
        label="Email"
        class="col-12"
      >
        <VInput
          v-model="value.email"
          prefix="md-mail"
          type="email"
          autocomplete="false"
          name="email"
          placeholder="example@example.com"
        />
      </FormItem>
      <FormItem
        prop="password"
        label="Password"
        class="col-12"
      >
        <VInput
          v-model="value.password"
          prefix="md-key"
          type="password"
          name="password"
          placeholder="**********"
        />
      </FormItem>
    </div>
    <VButton
      type="primary"
      class="mt-1"
      size="large"
      long
      @click="handleSubmit()"
    >
      {{ submitText }}
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
  name: 'UserForm',
  props: {
    user: {
      type: Object,
      required: false,
      default () {
        return {
          email: '',
          password: '',
          first_name: '',
          last_name: ''
        }
      }
    },
    requirePassword: {
      type: Boolean,
      required: false,
      default: true
    },
    mode: {
      type: String,
      required: false,
      default: 'create'
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
      isLoading: false,
      value: {}
    }
  },
  computed: {
    apiPath () {
      return {
        create: 'admin_users',
        setup: 'setup',
        update: `admin_users/${this.user.id}`
      }[this.mode]
    },
    apiMethod () {
      return this.mode === 'update' ? 'put' : 'post'
    },
    rules () {
      return {
        email: [{ required: true, type: 'email' }],
        password: [{ required: this.requirePassword, min: 6 }]
      }
    }
  },
  watch: {
    user (value) {
      if (value) {
        this.value = JSON.parse(JSON.stringify(value))
      }
    }
  },
  mounted () {
    this.value = JSON.parse(JSON.stringify(this.user))
  },
  methods: {
    submit () {
      this.isLoading = true

      api[this.apiMethod](this.apiPath, {
        admin_user: this.value
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
