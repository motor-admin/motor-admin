<template>
  <VForm
    v-if="!isSubmitted && !submittedEmail"
    ref="form"
    :model="value"
    :rules="rules"
    @keyup.enter="handleSubmit"
  >
    <div class="row">
      <div class="col-12 mb-3 text-center">
        Subscribe to receive newsletters with feature updates and new version releases
      </div>
      <FormItem
        prop="email"
        class="col-12"
      >
        <VInput
          v-model="value.email"
          prefix="md-mail"
          type="email"
          name="email"
          :disabled="isSubmitted"
          size="large"
          placeholder="example@example.com"
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
    <Spin
      v-if="isLoading"
      size="large"
      fix
    />
  </VForm>
  <div v-else>
    <Icon
      type="md-checkmark-circle text-success"
    />
    {{ submittedEmail ? `${submittedEmail} has` : 'You have' }} been subscribed for newsletters
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'SubscribeForm',
  props: {
    email: {
      type: String,
      required: false,
      default: ''
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
      isSubmitted: false,
      value: { email: '' }
    }
  },
  computed: {
    rules () {
      return {
        email: [{ required: true, type: 'email' }]
      }
    },
    submittedEmail () {
      if (window.localStorage) {
        return JSON.parse(window.localStorage.getItem('newsletter') || '{}').email
      } else {
        return ''
      }
    }
  },
  watch: {
    email (value) {
      if (value) {
        this.value.email = value
      }
    }
  },
  mounted () {
    this.value.email = this.email
  },
  methods: {
    submit () {
      this.isLoading = true

      axios.post('https://app.getmotoradmin.com/api/subscribe', {
        email: this.value.email
      }).then((result) => {
        localStorage.setItem('newsletter', JSON.stringify(result.data))
        localStorage.setItem('motor:current_user:is_subscribed', 'true')

        this.$emit('success', result.data.data)
      }).catch((error) => {
        console.error(error)
        this.$emit('error', error)
      }).finally(() => {
        this.isSubmitted = true
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
