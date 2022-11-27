<template>
  <MSelect
    v-model="dataValue"
    filterable
    multiple
    placeholder="Select tags"
    :size="size"
    :options="tags"
    :create-function="createFunction"
    label-key="name"
    value-key="name"
  />
</template>

<script>
import api from 'application/api'

export default {
  name: 'TagsSelect',
  props: {
    size: {
      type: String,
      required: false,
      default: 'large'
    },
    tagsType: {
      type: String,
      required: false,
      default: 'reports'
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
      tags: [],
      isLoading: false
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

    this.loadTags()
  },
  methods: {
    createFunction (value) {
      return Promise.resolve({ name: value })
    },
    loadTags () {
      this.isLoading = true

      const apiPath = this.tagsType === 'notes' ? 'note_tags' : 'tags'

      api.get(apiPath).then((result) => {
        this.tags = result.data.data
      }).catch((error) => {
        console.error(error)
      }).finally(() => {
        this.isLoading = false
      })
    }
  }
}
</script>

<style lang="scss">
</style>
