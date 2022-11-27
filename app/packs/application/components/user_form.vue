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
      <FormItem
        v-if="mode !== 'setup' && withRole"
        prop="role_ids"
        label="Roles"
        class="col-12"
      >
        <RolesSelect
          v-model="value.role_ids"
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
import RolesSelect from './roles_select'

export default {
  name: 'UserForm',
  components: {
    RolesSelect
  },
  props: {
    user: {
      type: Object,
      required: false,
      default () {
        return {
          email: '',
          password: '',
          first_name: '',
          last_name: '',
          role_ids: []
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
    },
    withRole: {
      type: Boolean,
      required: false,
      default: true
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
        password: [{ required: this.requirePassword, min: 6 }],
        role_ids: [{ required: this.mode !== 'setup' && this.withRole }]
      }
    }
  },
  watch: {
    user (value) {
      if (value) {
        this.value = this.normalizeUser(this.user)
      }
    }
  },
  created () {
    this.value = this.normalizeUser(this.user)
  },
  methods: {
    normalizeUser (user) {
      return JSON.parse(JSON.stringify({
        ...user,
        role_ids: user.roles ? user.roles.map((e) => e.id) : []
      }))
    },
    submit () {
      this.isLoading = true

      if (!this.withRole) {
        delete this.value.role_ids
      }

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
