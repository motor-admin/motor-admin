<template>
  <div class="mb-2 row">
    <div class="col-5 pe-0">
      <SubjectSelect
        :model-value="rule.subjects[0]"
        class="align-top"
        @update:model-value="onUpdateSubjectValue"
        @update:selected-option="onSelectSubject"
      />
    </div>
    <div class="col-7 d-flex justify-content-between">
      <ActionsSelect
        v-model="rule.actions"
        :subject="selectedSubject"
        class="me-2"
        @update:model-value="$emit('update')"
      />
      <Badge
        :count="badgeCount"
        type="primary"
      >
        <VButton
          icon="md-build"
          class="me-2"
          :disabled="rule.subjects[0] === 'all'"
          @click="openSettings"
        />
      </Badge>
      <VButton
        icon="md-trash"
        @click="$emit('remove')"
      />
    </div>
  </div>
</template>

<script>
import SubjectSelect from './subject_select'
import ActionsSelect from './action_select'

export default {
  name: 'RuleItem',
  components: {
    SubjectSelect,
    ActionsSelect
  },
  props: {
    rule: {
      type: Object,
      required: false,
      default () {
        return { subjects: [], actions: [], conditions: [], attributes: [] }
      }
    }
  },
  emits: ['remove', 'update'],
  data () {
    return {
      selectedSubject: {}
    }
  },
  computed: {
    badgeCount () {
      const { rule } = this

      return (rule.conditions?.[0]?.key !== 'tags.name' ? rule.conditions?.length : rule.conditions?.[0].value.length) + (rule.attributes?.length ? 1 : 0)
    }
  },
  methods: {
    openSettings () {
      this.$Dialog.info({
        title: 'This feature is available in Motor Admin Pro',
        okText: 'Learn More',
        onOk () {
          location.href = 'https://www.getmotoradmin.com/pro'
        }
      }, {
        closable: true
      })
    },
    onUpdateSubjectValue (value) {
      this.rule.subjects = [value]
      this.rule.conditions = []
      this.rule.attributes = []

      this.$emit('update')
    },
    onSelectSubject (subject) {
      const isNewSubject = !this.selectedSubject

      this.selectedSubject = subject

      if (isNewSubject && subject) {
        this.rule.actions = ['manage']
      }
    }
  }
}
</script>

<style lang="scss" scoped>
:deep(.ivu-badge-count) {
  box-shadow: none;
  font-family: inherit;
  font-weight: bold;
  font-size: 10px;
  height: 15px;
  line-height: 12px;
  min-width: 15px;
  padding: 0 0px;
  right: 8px;
  top: -4px;
}
</style>
