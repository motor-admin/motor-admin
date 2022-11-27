<template>
  <div class="row mb-2">
    <div class="col-5 pe-0">
      <MSelect
        v-model="filter.key"
        :options="columns"
        :placeholder="'Select Field'"
        class="align-top"
        @update:selectedOption="selectedColumn = $event"
      />
    </div>
    <div class="col-7 d-flex">
      <div class="d-flex w-100 flex-column me-2">
        <MSelect
          v-if="selectedColumn?.column_type === 'boolean'"
          :model-value="!!filter.value[0]"
          :with-deselect="false"
          :options="[true, false]"
          @update:model-value="onBooleanSelect"
        />
        <MSelect
          v-else
          v-model="filter.value"
          multiple
          :placeholder="'Values'"
          :options="filter.value"
          allow-create
        />
        <div v-if="selectedColumn?.column_type !== 'boolean'">
          <VButton
            size="small"
            class="me-2"
            :type="filter.value.includes('current_user_id') ? 'primary' : 'default'"
            :ghost="filter.value.includes('current_user_id')"
            @click="toggleValue('current_user_id')"
          >
            User ID
          </VButton>
          <VButton
            size="small"
            :type="filter.value.includes('current_user_email') ? 'primary' : 'default'"
            :ghost="filter.value.includes('current_user_email')"
            @click="toggleValue('current_user_email')"
          >
            User email
          </VButton>
        </div>
      </div>
      <VButton
        icon="md-trash"
        @click="$emit('remove')"
      />
    </div>
  </div>
</template>

<script>
import { modelNameMap } from 'application/scripts/schema'

export default {
  name: 'RuleFilterItem',
  props: {
    filter: {
      type: Object,
      required: false,
      default: () => {}
    },
    model: {
      type: Object,
      required: true
    }
  },
  emits: ['remove'],
  data () {
    return {
      selectedColumn: {}
    }
  },
  computed: {
    columns () {
      return [
        ...this.model.columns.map((column) => {
          if (!column.virtual && !column.reference && ['read_write', 'read_only'].includes(column.access_type)) {
            return {
              ...column,
              value: column.name,
              label: column.display_name
            }
          } else {
            return null
          }
        }).filter(Boolean),
        ...this.model.columns.map((column) => {
          if (column.reference && !column.reference.polymorphic && ['read_write', 'read_only'].includes(column.access_type)) {
            const referenceModel = modelNameMap[column.reference.model_name]

            return referenceModel.columns.map((refColumn) => {
              if (!refColumn.virtual && refColumn.column_source !== 'query' && ['read_write', 'read_only'].includes(refColumn.access_type)) {
                return {
                  ...(refColumn.name === column.reference.primary_key ? column : refColumn),
                  value: `${column.reference.name}.${refColumn.name}`,
                  label: `${column.reference.display_name} - ${refColumn.display_name}`
                }
              } else {
                return null
              }
            }).filter(Boolean)
          } else {
            return []
          }
        }).flat(),
        ...this.model.associations.map((assoc) => {
          if (assoc.visible) {
            const assocModel = modelNameMap[assoc.model_name]

            return assocModel.columns.map((column) => {
              if (!column.virtual && column.column_source !== 'query' && ['read_write', 'read_only'].includes(column.access_type)) {
                return {
                  ...column,
                  value: `${assoc.name}.${column.name}`,
                  label: `${assoc.display_name} - ${column.display_name}`
                }
              } else {
                return null
              }
            }).filter(Boolean)
          } else {
            return []
          }
        }).flat()
      ]
    }
  },
  methods: {
    onBooleanSelect (value) {
      this.filter.value = [value]
    },
    toggleValue (value) {
      const valueIndex = this.filter.value.indexOf(value)

      if (valueIndex === -1) {
        this.filter.value.splice(this.filter.value.indexOf('current_user_id'), 1)
        this.filter.value.splice(this.filter.value.indexOf('current_user_email'), 1)

        this.filter.value.push(value)
      } else {
        this.filter.value.splice(valueIndex, 1)
      }
    }
  }
}
</script>
