<template>
  <MSelect
    v-model="dataValue"
    filterable
    allow-create
    multiple
    :placeholder="'Select Roles'"
    :size="size"
    :options="roles"
    label-key="name"
    value-key="id"
  />
</template>

<script>
import api from 'application/api'

export default {
  name: 'RolesSelect',
  props: {
    size: {
      type: String,
      required: false,
      default: 'large'
    },
    modelValue: {
      type: Array,
      required: false,
      default: () => []
    }
  },
  emits: ['update:modelValue'],
  data () {
    return {
      dataValue: [],
      roles: []
    }
  },
  watch: {
    modelValue (value) {
      this.dataValue = value
    },
    dataValue (value) {
      this.$emit('update:modelValue', value)
    }
  },
  mounted () {
    this.dataValue = this.modelValue

    this.loadRoles()
  },
  methods: {
    loadRoles () {
      api.get('roles').then((result) => {
        this.roles = result.data.data
      }).catch((error) => {
        console.error(error)
      })
    }
  }
}
</script>

<style lang="scss">
</style>
