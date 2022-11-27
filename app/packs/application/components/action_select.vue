<template>
  <MSelect
    :model-value="modelValue"
    multiple
    :placeholder="'Select Actions'"
    :options="actions"
    @update:model-value="handleSelect"
  />
</template>

<script>
const actionsValueMap = {
  edit: 'update',
  remove: 'destroy'
}

export default {
  name: 'ActionSelect',
  props: {
    modelValue: {
      type: [Array],
      required: true,
      default: () => []
    },
    subject: {
      type: Object,
      require: false,
      default: () => ({})
    }
  },
  emits: ['update:modelValue'],
  computed: {
    actions () {
      if (this.subject?.actions?.length) {
        return this.subjectActions
      } else {
        return this.defaultActions
      }
    },
    subjectActions () {
      return [
        { value: 'manage', label: 'Manage' },
        { value: 'read', label: 'Read' },
        ...this.subject.actions.map((action) => {
          return { value: actionsValueMap[action.name] || action.name, label: action.display_name }
        })
      ]
    },
    defaultActions () {
      return [
        { value: 'manage', label: 'Manage' },
        { value: 'read', label: 'Read' },
        { value: 'create', label: 'Create' },
        { value: 'update', label: 'Edit' },
        { value: 'destroy', label: 'Remove' }
      ]
    }
  },
  methods: {
    handleSelect (values) {
      if (values[values.length - 1] === 'manage') {
        this.$emit('update:modelValue', ['manage'])
      } else if (values.includes('manage') && values[values.length - 1] !== 'manage') {
        values.splice(values.indexOf('manage'), 1)

        this.$emit('update:modelValue', values)
      } else {
        this.$emit('update:modelValue', values)
      }
    }
  }
}
</script>
