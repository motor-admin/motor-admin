<template>
  <MSelect
    :model-value="modelValue"
    :value-key="'class_name'"
    :label-key="'display_name'"
    :with-deselect="false"
    :options="subjects"
    :placeholder="'Select Resource'"
    filterable
    @update:model-value="$emit('update:modelValue', $event)"
    @update:selected-option="$emit('update:selectedOption', $event)"
  />
</template>

<script>
import { schema } from 'application/scripts/schema'

export default {
  name: 'SubjectSelect',
  props: {
    modelValue: {
      type: String,
      required: false,
      default: ''
    }
  },
  emits: ['update:modelValue', 'update:selectedOption'],
  computed: {
    subjects () {
      return [
        { class_name: 'all', display_name: 'All' },
        ...this.motorSubjects,
        ...schema
      ]
    },
    motorSubjects () {
      return [
        { class_name: 'Motor::Form', display_name: 'Forms' },
        { class_name: 'Motor::Query', display_name: 'Queries' },
        { class_name: 'Motor::Dashboard', display_name: 'Dashboards' },
        { class_name: 'Motor::Alert', display_name: 'Alerts' },
        { class_name: 'Motor::Note', display_name: 'Notes' }
      ]
    }
  }
}
</script>
