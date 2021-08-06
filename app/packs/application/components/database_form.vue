<template>
  <VForm
    ref="form"
    :model="dataConfigs"
    :rules="rules"
    @keyup.enter="handleSubmit"
  >
    <FormItem
      prop="url"
      label="URL"
      class="col-12"
    >
      <VInput
        v-model="dataConfigs.url"
        type="text"
        size="large"
        placeholder="postgresql://username:password@localhost:5432/db_name"
        @update:model-value="assignFields"
      />
    </FormItem>
    <Divider />
    <RadioGroup
      v-model="dataConfigs.protocol"
      class="d-flex"
      @update:model-value="assignUrl"
    >
      <Radio
        v-for="(option, index) in dbTypeOptions"
        :key="option.value"
        :label="option.value"
        border
        size="large"
        :style="index === 0 ? 'margin-right: 25px !important' : ''"
        class="my-1 me-0 w-100"
      >
        {{ option.label }}
      </Radio>
    </RadioGroup>
    <div class="row">
      <FormItem
        prop="host"
        label="Host"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="dataConfigs.host"
          type="text"
          placeholder="example.com"
          @update:model-value="assignUrl"
        />
      </FormItem>
      <FormItem
        prop="port"
        label="Port"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="dataConfigs.port"
          type="text"
          placeholder="5432"
          @update:model-value="assignUrl"
        />
      </FormItem>
      <FormItem
        prop="username"
        label="Username"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="dataConfigs.username"
          type="text"
          placeholder="admin"
          @update:model-value="assignUrl"
        />
      </FormItem>
      <FormItem
        prop="password"
        label="Password"
        class="col-12 col-md-6"
      >
        <VInput
          v-model="dataConfigs.password"
          type="password"
          placeholder="**********"
          @update:model-value="assignUrl"
        />
      </FormItem>
      <FormItem
        prop="database"
        label="Database"
        class="col-12"
      >
        <VInput
          v-model="dataConfigs.database"
          placeholder="db_name"
          @update:model-value="assignUrl"
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
      fix
    />
  </VForm>
</template>

<script>
import api from 'application/api'
import { databaseUrlToObject } from 'application/scripts/urls'

export default {
  name: 'DatabaseForm',
  props: {
    configs: {
      type: Object,
      required: false,
      default: () => ({ protocol: 'postgres' })
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
      dataConfigs: { ...this.configs }
    }
  },
  computed: {
    rules () {
      return {
        url: [{ required: true }],
        host: [{ required: true }],
        port: [{ required: true }]
      }
    },
    dbTypeOptions () {
      return [
        { label: 'PostgreSQL', value: 'postgres' },
        { label: 'MySQL', value: 'mysql2' }
      ]
    }
  },
  watch: {
    configs () {
      this.dataConfigs = { ...this.configs }
    }
  },
  methods: {
    assignFields () {
      Object.assign(this.dataConfigs, databaseUrlToObject(this.dataConfigs.url))
    },
    assignUrl () {
      const { username, protocol, host, password, database, port } = this.dataConfigs

      if (host && port && database) {
        this.dataConfigs.url = `${protocol}://`

        if (username && !password) {
          this.dataConfigs.url += `${username}@`
        } else if (username && password) {
          this.dataConfigs.url += `${username}:${password}@`
        }

        this.dataConfigs.url += `${host}:${port}/${database}`
      }
    },
    submit () {
      this.isLoading = true

      api.post('encrypted_configs', {
        data: {
          key: 'database.url',
          value: this.dataConfigs.url
        }
      }).then((result) => {
        this.$emit('success', result.data.data)
      }).catch((error) => {
        if (error.response?.data?.errors) {
          this.$refs.form.setErrors(error.response.data.errors)
        } else if (error.message) {
          this.$refs.form.setErrors([error.message])
        }

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
