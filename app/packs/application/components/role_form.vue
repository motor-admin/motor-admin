<template>
  <VForm
    ref="form"
    :model="value"
    :rules="rules"
    label-position="top"
    class="rule-settings"
    @keyup.enter="handleSubmit"
  >
    <div class="row">
      <FormItem
        prop="name"
        label="Name"
      >
        <VInput
          v-model="value.name"
          type="text"
          placeholder="Role Name"
        />
      </FormItem>
    </div>
    <FormItem
      prop="rules"
      label="Permissions"
      class="mb-1"
    >
      <RuleItem
        v-for="rule in value.rules"
        :rule="rule"
        @update="maybeHandleSubmit"
        @remove="removeRule(rule)"
      />
    </FormItem>

    <VButton
      long
      icon="md-add"
      @click="addNewRule"
    >
      Add
    </VButton>
    <VButton
      v-if="mode === 'create'"
      type="primary"
      class="mt-4"
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
  <div
    v-if="mode === 'update'"
    class="sticky-footer"
  >
    <VButton
      style="float: left"
      type="error"
      :loading="isRemoveLoading"
      ghost
      @click="remove"
    >
      Remove
    </VButton>
    <VButton
      type="primary"
      @click="handleSubmit"
    >
      OK
    </VButton>
  </div>
</template>

<script>
import api from 'application/api'
import RuleItem from './rule_item'

export default {
  name: 'RoleForm',
  components: {
    RuleItem
  },
  props: {
    role: {
      type: Object,
      required: false,
      default () {
        return {
          name: '',
          rules: []
        }
      }
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
  emits: ['success', 'error', 'remove'],
  data () {
    return {
      isLoading: false,
      isRemoveLoading: false,
      value: {}
    }
  },
  computed: {
    apiPath () {
      return {
        create: 'roles',
        update: `roles/${this.role.id}`
      }[this.mode]
    },
    apiMethod () {
      return this.mode === 'update' ? 'put' : 'post'
    },
    rules () {
      return {
        name: [{ required: true }]
      }
    }
  },
  watch: {
    role (value) {
      if (value) {
        this.value = JSON.parse(JSON.stringify(value))
      }
    }
  },
  mounted () {
    this.value = JSON.parse(JSON.stringify(this.role))
  },
  methods: {
    submit () {
      return api[this.apiMethod](this.apiPath, {
        role: {
          name: this.value.name,
          rules: this.value.rules.filter((r) => r.subjects.length)
        }
      })
    },
    addNewRule () {
      this.value.rules.push({ subjects: [], actions: [], attributes: [], conditions: [] })
    },
    removeRule (rule) {
      const index = this.value.rules.indexOf(rule)

      this.value.rules.splice(index, 1)

      this.maybeHandleSubmit()
    },
    maybeHandleSubmit () {
      if (this.mode === 'update') {
        this.submit().then((result) => {
          Object.assign(this.role, result.data.data)
        })
      }
    },
    remove () {
      this.$Dialog.confirm({
        title: 'Are you sure?',
        closable: true,
        onOk: () => {
          this.isRemoveLoading = true

          api.delete(this.apiPath).then((result) => {
            this.$emit('remove')
          }).catch((error) => {
            console.error(error)
            this.$emit('error', error)
          }).finally(() => {
            this.isRemoveLoading = true
          })
        }
      })
    },
    handleSubmit () {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.isLoading = true

          this.submit().then((result) => {
            this.$emit('success', result.data.data)
          }).catch((error) => {
            console.error(error)
            this.$emit('error', error)
          }).finally(() => {
            this.isLoading = false
          })
        }
      })
    }
  }
}
</script>

<style lang="scss">

.rule-settings {
  min-height: calc(100% - 62px);
}
.sticky-footer {
  background: #fff;
  border-top: 1px solid #e8e8e8;
  bottom: 0;
  left: 0;
  padding: 10px 0;
  position: sticky;
  text-align: right;
  width: 100%;
}

.ivu-modal-body {
  .sticky-footer {
    padding: 10px 0 0;
  }
}
</style>
