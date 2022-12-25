<template>
  <VForm @submit.prevent>
    <FormItem
      v-if="subject.class_name === 'Motor::Note'"
      prop="conditions"
      label="Permitted tags"
    >
      <TagsSelect
        :model-value="dataRule.conditions.find((e) => e.key === 'tags.name')?.value"
        :tags-type="'notes'"
        size="default"
        @update:model-value="setTag"
      />
    </FormItem>
    <FormItem
      v-if="isTagsResource"
      prop="conditions"
      label="Permitted tags"
    >
      <TagsSelect
        v-model="dataRule.conditions[0].value"
        size="default"
      />
    </FormItem>
    <template v-else>
      <FormItem
        prop="conditions"
        label="Filters"
      >
        <RuleFilterItem
          v-for="(condition, index) in filteredConditions"
          :key="index"
          :filter="condition"
          :model="subject.class_name === 'Motor::Note' ? { columns: noteColumns, associations: [] } : subject"
          @update:model-value="updateFilterCondition(index, $event)"
          @remove="removeFilter(index)"
        />
        <VButton
          long
          icon="md-add"
          @click="addFilter"
        >
          Add Filter
        </VButton>
      </FormItem>

      <FormItem
        prop="attributes"
        label="Permitted fields"
      >
        <MSelect
          v-model="dataRule.attributes"
          multiple
          filterable
          :options="subject.columns"
          label-key="display_name"
          value-key="name"
        />
      </FormItem>
    </template>
    <VButton
      long
      type="primary"
      @click="$emit('submit', normalizedRuleData)"
    >
      OK
    </VButton>
  </VForm>
</template>

<script>
import RuleFilterItem from './rule_filter_item'
import TagsSelect from './tag_select'

const defaultRuleParams = {
  subjects: [],
  actions: [],
  attributes: [],
  conditions: [{ key: '', value: [] }]
}

export default {
  name: 'RuleSettings',
  components: {
    RuleFilterItem,
    TagsSelect
  },
  props: {
    rule: {
      type: Object,
      required: true
    },
    subject: {
      type: Object,
      required: true
    }
  },
  emits: ['submit'],
  data () {
    return {
      dataRule: {}
    }
  },
  computed: {
    normalizedRuleData () {
      return {
        ...this.dataRule,
        conditions: this.dataRule.conditions.filter((c) => c.key)
      }
    },
    filteredConditions () {
      return this.dataRule.conditions.filter((e) => e.key !== 'tags.name')
    },
    noteColumns () {
      return [
        {
          name: 'author_id',
          display_name: 'Author ID',
          access_type: 'read_only'
        }
      ]
    },
    isTagsResource () {
      return ['Motor::Query', 'Motor::Dashboard', 'Motor::Alert', 'Motor::Form'].includes(this.subject.class_name)
    }
  },
  created () {
    this.dataRule = JSON.parse(JSON.stringify({ ...defaultRuleParams, ...this.rule }))

    if ((this.isTagsResource || this.subject.class_name === 'Motor::Note') && !this.dataRule.conditions[0]) {
      this.dataRule.conditions = [{ key: 'tags.name', value: [] }]
    }
  },
  methods: {
    setTag (value) {
      const condition = this.dataRule.conditions.find((e) => e.key === 'tags.name')

      if (condition) {
        condition.value = value
      } else {
        this.dataRule.conditions.push({ key: 'tags.name', value: value })
      }
    },
    addFilter () {
      this.dataRule.conditions.push({ key: '', value: [] })
    },
    updateFilterCondition (index, newCondition) {
      this.dataRule.conditions.splice(index, newCondition)
    },
    removeFilter (index) {
      this.dataRule.conditions.splice(index, 1)
    }
  }
}
</script>
