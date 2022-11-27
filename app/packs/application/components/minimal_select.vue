<template>
  <div
    v-click-outside="closeDropdown"
    class="ivu-select"
    :class="{
      'ivu-select-visible': isOpen,
      [`ivu-select-${size}`]: true,
      'ivu-select-multiple': multiple,
      'ivu-select-disabled': disabled,
      'ivu-select-single': !multiple
    }"
    @keydown.enter.stop="applyFocused"
    @keydown.up.prevent="moveFocus(-1)"
    @keydown.down.prevent="moveFocus(1)"
  >
    <div
      ref="selection"
      tabindex="-1"
      :class="border ? 'ivu-select-selection' : 'ivu-select-no-border'"
      @click="toggleDropdown"
    >
      <div>
        <div
          v-if="multiple"
          class="d-inline"
          @end="onOptionMove"
        >
          <div
            v-for="option in selectedOptionsData"
            :key="getValue(option)"
            class="ivu-tag ivu-tag-checked"
          >
            <span class="ivu-tag-text">{{ getLabel(option) }}</span>
            <i
              class="ion ion-ios-close"
              @click.stop="removeOption(option)"
            />
          </div>
        </div>
        <input
          v-if="remoteFunction || filterable || allowCreate"
          ref="input"
          v-model="searchInput"
          type="text"
          :placeholder="selectedOptionsData.length ? '' : placeholder"
          autocomplete="off"
          spellcheck="false"
          :disabled="disabled"
          class="ivu-select-input"
          :class="{ 'ivu-input-no-border': !border }"
          @keydown.down="isOpen = true"
          @keydown.up="isOpen = true"
          @keydown.tab.prevent="onTabKey"
          @keydown.backspace="maybeRemoveOption"
          @input="onSearch"
        >
        <span
          v-else-if="selectedOptionData || !selectedOptionsData.length"
          :class="{ 'ivu-select-placeholder': !selectedOptionData, 'ivu-select-selected-value' : selectedOptionData }"
        >
          {{ selectedOptionData ? getLabel(selectedOptionData) : placeholder }}
        </span>
        <i
          v-if="withDeselect && selectedOptionData"
          class="ivu-select-icon ion ion-ios-close-circle ivu-select-custom-icon"
          @click.stop="deselect"
        />
        <i
          v-else
          class="ivu-select-icon"
          :class="icon ? `ion ion-${icon} ivu-select-custom-icon` : `ion ion-ios-arrow-down ivu-select-arrow`"
        />
      </div>
    </div>
    <transition name="transition-drop">
      <div
        v-show="isOpen && (optionsData.length || displayCreate || notFound)"
        ref="dropdown"
        class="ivu-select-dropdown"
      >
        <ul
          v-if="notFound && !withCreateButton"
          class="ivu-select-not-found"
        >
          <li>Not Found</li>
        </ul>
        <ul class="ivu-select-dropdown-list">
          <li
            v-if="displayCreate"
            class="ivu-select-item"
            :class="{'ivu-select-item-focus': focusIndex === 0}"
            @click.stop="createOption(searchInput)"
          >
            {{ searchInput }}
            <i class="ion ion-md-return-left ivu-select-item-enter" />
          </li>
          <li
            v-for="(option, index) in optionsToRender"
            :key="index"
            :ref="setOptionRef"
            class="ivu-select-item"
            :class="[isSelected(option) ? 'ivu-select-item-selected ivu-select-item-focus' : '', focusIndex === (displayCreate ? index + 1 : index) ? 'ivu-select-item-focus' : '']"
            @click.stop="selectOption(option)"
          >
            <component
              :is="optionComponent"
              v-if="optionComponent && option"
              :option="option"
            />
            <template v-else>
              {{ getLabel(option) }}
            </template>
          </li>
          <li
            v-if="withCreateButton"
            class="ivu-select-item text-center"
            :class="{ 'ivu-select-item-focus': focusIndex === optionsToRender.length }"
            @click.stop="$emit('click-create')"
          >
            <Icon type="md-add" />
            Create New
          </li>
        </ul>
        <div
          v-show="isLoading"
          class="ivu-select-loading"
        >
          Loading
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import { directive as clickOutside } from 'view3/src/directives/v-click-outside-x'
import { getStyle } from 'view3/src/utils/assist'
import throttle from 'view3/src/utils/throttle'
import Popper from 'popper.js/dist/umd/popper.js'

const MAX_FILTER_ITEMS = 100
const REMOTE_SEARCH_THROTTLE_DURATION = 500

export default {
  name: 'SimpleSelect',
  directives: { clickOutside },
  props: {
    modelValue: {
      type: [String, Number, Array, Boolean],
      reqired: false,
      default: ''
    },
    options: {
      type: Array,
      required: false,
      default: () => []
    },
    selectedOptions: {
      type: Array,
      required: false,
      default: () => []
    },
    selectedOption: {
      type: [Array, Object],
      required: false,
      default: null
    },
    size: {
      type: String,
      reqired: false,
      default: 'default'
    },
    icon: {
      type: String,
      reqired: false,
      default: null
    },
    filterable: {
      type: Boolean,
      required: false,
      default: false
    },
    multiple: {
      type: Boolean,
      required: false,
      default: false
    },
    allowCreate: {
      type: Boolean,
      required: false,
      default: false
    },
    withCreateButton: {
      type: Boolean,
      required: false,
      default: false
    },
    withDeselect: {
      type: Boolean,
      required: false,
      default: true
    },
    createFunction: {
      type: Function,
      required: false,
      default: (value) => {
        return Promise.resolve({ value, label: value })
      }
    },
    border: {
      type: Boolean,
      required: false,
      default: true
    },
    placeholder: {
      type: String,
      reqired: false,
      default: 'Select'
    },
    labelKey: {
      type: [String, Number],
      reqired: false,
      default: 'label'
    },
    labelFunction: {
      type: Function,
      required: false,
      default: null
    },
    valueFunction: {
      type: Function,
      required: false,
      default: null
    },
    focusFirst: {
      type: Boolean,
      required: false,
      default: false
    },
    disabled: {
      type: Boolean,
      required: false,
      default: false
    },
    optionComponent: {
      type: Object,
      required: false,
      default: null
    },
    valueKey: {
      type: [String, Number],
      reqired: false,
      default: 'value'
    },
    inputValue: {
      type: String,
      reqired: false,
      default: ''
    },
    remoteFunction: {
      type: Function,
      required: false,
      default: null
    }
  },
  emits: ['update:modelValue', 'update:selectedOptions', 'update:selectedOption', 'search', 'select', 'click-create'],
  data () {
    return {
      isLoading: false,
      optionsData: [],
      optionRefs: [],
      popper: null,
      selectedOptionData: null,
      selectedOptionsData: [],
      focusIndex: -1,
      searchInput: this.inputValue,
      isOptionsLoaded: false,
      isOpen: false
    }
  },
  computed: {
    remoteFunctionThrottled () {
      return throttle((query) => this.remoteFunction(query), REMOTE_SEARCH_THROTTLE_DURATION)
    },
    displayCreate () {
      return this.searchInput && this.allowCreate && !this.optionsToRender.find((opt) => this.getValue(opt) === this.searchInput)
    },
    withFilter () {
      return this.remoteFunction || this.filterable || this.allowCreate
    },
    optionsToRender () {
      if ((this.filterable || this.allowCreate) && !this.remoteFunction) {
        return this.filteredOptions.slice(0, MAX_FILTER_ITEMS)
      } else {
        if (this.remoteFunction && !this.multiple && this.selectedOptionData && this.searchInput === this.getLabel(this.selectedOptionData)) {
          const notSelectedOptions = this.optionsData.filter((option) => {
            return this.getValue(option) !== this.getValue(this.selectedOptionData)
          })

          return [this.selectedOption, ...notSelectedOptions]
        } else {
          return this.optionsData
        }
      }
    },
    filteredOptions () {
      if (this.remoteFunction) return []

      if (this.searchInput && this.searchInput !== this.getLabel(this.selectedOptionData)) {
        return this.optionsData.filter((option) => {
          return this.getLabel(option).toString().toLowerCase().includes(this.searchInput.toString().toLowerCase())
        })
      } else {
        return this.optionsData
      }
    },
    notFound () {
      return !this.allowCreate && this.withFilter && ((this.remoteFunction ? !!this.searchInput : true) && this.optionsToRender.length === 0)
    }
  },
  watch: {
    isOptionsLoaded () {
      this.assignSelectedFromValue(this.modelValue)

      if (!this.multiple) {
        const label = this.getLabel(this.selectedOptionData)

        if (label) {
          this.searchInput = label
        }
      }
    },
    selectedOptions (value) {
      this.selectedOptionsData = [...value]
    },
    selectedOption (value) {
      this.selectedOptionData = value

      this.searchInput = this.getLabel(this.selectedOptionData)
    },
    optionsToRender (newArray, oldArray) {
      if (newArray.length !== oldArray.length) {
        this.popper?.update()
      }
    },
    modelValue (value) {
      if (this.remoteFunction && !this.multiple) {
        if (this.searchInput !== this.getLabel(this.selectedOptionData)) {
          this.remoteFunction(this.searchInput || value).then(() => {
            this.assignSelectedFromValue(value)

            this.searchInput = this.getLabel(this.selectedOptionData)
          })
        } else {
          this.remoteFunction('')
        }
      } else {
        this.assignSelectedFromValue(value)

        this.searchInput = this.getLabel(this.selectedOptionData)
      }
    },
    options: {
      deep: true,
      handler (value) {
        this.optionsData = this.normalizeOptions(value)

        if (!this.remoteFunction) {
          this.assignSelectedFromValue(this.modelValue)
        }

        if (this.optionsData.length) {
          this.isOptionsLoaded = true
        }
      }
    },
    isOpen (value) {
      if (value) {
        this.$refs.dropdown.style.minWidth = getStyle(this.$el, 'width')
      }
    }
  },
  mounted () {
    if (this.remoteFunction) {
      this.remoteFunction(this.multiple ? this.searchInput : '')

      if (!this.multiple) {
        this.selectedOptionData = this.selectedOption
        this.searchInput = this.getLabel(this.selectedOptionData) || this.modelValue
      }
    } else {
      this.optionsData = this.normalizeOptions(this.options)

      if (this.multiple) {
        this.selectedOptionsData = [...this.selectedOptions]

        if (!this.options.length && this.allowCreate) {
          this.optionsData = [...this.normalizeOptions(this.modelValue)]
        }

        this.assignSelectedFromValue(this.modelValue)
      } else {
        this.selectedOptionData = this.selectedOption
        this.assignSelectedFromValue(this.modelValue)

        this.searchInput = this.getLabel(this.selectedOptionData) || this.modelValue
      }
    }
  },
  beforeUpdate () {
    this.optionRefs = []
  },
  methods: {
    setOptionRef (el) {
      if (el) {
        this.optionRefs.push(el)
      }
    },
    createOption (value) {
      this.createFunction(value).then((option) => {
        this.optionsData.unshift(option)
        this.selectOption(option)
      })
    },
    onTabKey () {
      if (this.displayCreate && this.focusIndex === 0) {
        this.createOption(this.searchInput)
      } else {
        const label = this.getLabel(this.optionsToRender[this.focusIndex])

        if (label) {
          this.searchInput = label
          this.onSearch()
        }
      }
    },
    normalizeOptions (options) {
      if (!options?.length) {
        return []
      } else if (['string', 'number', 'boolean'].includes(typeof options[0])) {
        return options.map(option => {
          return { value: option, label: option.toString() }
        })
      } else {
        return [...options]
      }
    },
    getLabel (option) {
      if (option) {
        return this.labelFunction ? this.labelFunction(option) : (option[this.labelKey] ?? '')
      } else {
        return ''
      }
    },
    getValue (option) {
      if (option) {
        return this.valueFunction ? this.valueFunction(option) : (option[this.valueKey] ?? '')
      } else {
        return ''
      }
    },
    onSearch () {
      this.remoteFunction && this.remoteFunctionThrottled(this.searchInput)
      const index = this.optionsToRender.indexOf(this.selectedOptionData)
      this.focusIndex = index === -1 ? 0 : index
      this.isOpen = true
      this.popper?.update()
      this.$emit('search', this.searchInput)
    },
    moveFocus: throttle(function (index) {
      const maxLength = this.displayCreate || this.withCreateButton ? (this.optionsToRender.length + 1) : this.optionsToRender.length
      const nextIndex = this.focusIndex + index
      if (nextIndex >= maxLength) {
        this.focusIndex = 0
      } else if (nextIndex < 0) {
        this.focusIndex = maxLength - 1
      } else {
        this.focusIndex += index
      }

      this.$nextTick(() => {
        this.optionRefs[this.focusIndex]?.scrollIntoView({ block: 'nearest' })
      })
    }, 80),
    applyFocused () {
      if (this.displayCreate && this.focusIndex === 0) {
        this.createOption(this.searchInput)

        this.toggleDropdown()
      } else if (this.withCreateButton && this.focusIndex === this.optionsToRender.length) {
        this.$emit('click-create')
      } else {
        const index = this.displayCreate ? this.focusIndex + 1 : this.focusIndex
        const option = this.optionsToRender[index]

        if (option) {
          this.selectOption(option)
        }
      }
    },
    assignSelectedFromValue (value) {
      if (this.multiple) {
        if (value) {
          this.selectedOptionsData = value.map((val) => {
            return this.selectedOptionsData.find((option) => this.getValue(option).toString() === (val ?? '').toString()) ||
              this.optionsData.find((option) => this.getValue(option).toString() === (val ?? '').toString())
          })
        }
      } else {
        if (this.getValue(this.selectedOption).toString() === (value ?? '').toString()) {
          this.selectedOptionData = this.selectedOption
        } else {
          this.selectedOptionData = this.optionsData.find((option) => this.getValue(option).toString() === (value ?? '').toString())
        }

        const index = this.optionsToRender.indexOf(this.selectedOptionData)

        this.focusIndex = this.focusFirst && index === -1 ? 0 : index

        this.$emit('update:selectedOption', this.selectedOptionData)
      }
    },
    isSelected (option) {
      const hasSelected = this.getValue(option) && (this.selectedOptionData || this.selectedOptionsData.length)

      if (hasSelected) {
        return (this.multiple ? this.selectedOptionsData : [this.selectedOptionData]).find((opt) => this.getValue(opt) === this.getValue(option))
      } else {
        return false
      }
    },
    deselect () {
      this.selectedOptionData = null
      this.searchInput = ''
      this.$emit('update:modelValue', '')
      this.$emit('update:selectedOption', null)
      this.$emit('select', null)
    },
    selectOption (option) {
      if (this.multiple) {
        const existingOption = this.selectedOptionsData.find((opt) => this.getValue(opt) === this.getValue(option))

        if (existingOption) {
          this.selectedOptionsData.splice(this.selectedOptionsData.indexOf(existingOption), 1)
        } else {
          this.selectedOptionsData.push(option)
        }

        this.searchInput = ''

        if (this.remoteFunction) {
          this.remoteFunction(this.searchInput)
        }

        this.$emit('update:selectedOptions', this.selectedOptionsData)
        this.$emit('update:modelValue', this.selectedOptionsData.map(this.getValue))
        this.$emit('select', this.selectedOptionsData)

        this.focusIndex = this.optionsToRender.indexOf(option)

        this.popper?.update()
        this.$refs.input?.focus()
      } else {
        this.selectedOptionData = option
        this.searchInput = this.getLabel(option)
        this.focusIndex = this.optionsToRender.indexOf(option)
        this.$emit('update:modelValue', this.getValue(option))
        this.$emit('update:selectedOption', option)
        this.$emit('select', option)

        this.closeDropdown()
      }
    },
    onOptionMove () {
      this.$emit('update:modelValue', this.selectedOptionsData.map(this.getValue))
      this.$emit('update:selectedOptions', this.selectedOptionsData)
    },
    removeOption (option) {
      this.selectedOptionsData.splice(this.selectedOptionsData.indexOf(option), 1)

      this.$emit('update:modelValue', this.selectedOptionsData.map(this.getValue))
      this.$emit('update:selectedOptions', this.selectedOptionsData)
    },
    maybeRemoveOption () {
      if (this.multiple && this.searchInput === '') {
        this.removeOption(this.selectedOptions[this.selectedOptionsData.length - 1])
      }
    },
    closeDropdown () {
      this.isOpen = false

      if (this.selectedOptionData) {
        this.searchInput = this.getLabel(this.selectedOptionData)
      }

      this.$nextTick(() => {
        this.optionRefs[0]?.scrollIntoView({ block: 'nearest' })
      })
    },
    toggleDropdown () {
      if (!this.disabled) {
        this.isOpen = !this.isOpen

        this.popper ||= new Popper(this.$el, this.$refs.dropdown, {
          placement: 'bottom-start',
          modifiers: {
            computeStyle: {
              gpuAcceleration: false
            },
            preventOverflow: {
              boundariesElement: 'window'
            }
          }
        })

        this.popper.update()
        this.$refs.input?.focus()
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.ivu-select-custom-icon {
  color: #808695;
  font-size: 14px;
  line-height: 1;
  position: absolute;
  right: 8px;
  top: calc(50% - 7px);
}

.ivu-select-no-border {
  position: relative;
  height: 40px;
}

.ivu-select-input {
  cursor: initial;
}
</style>
