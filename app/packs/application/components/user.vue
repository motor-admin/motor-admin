<template>
  <Card>
    <div class="row">
      <div class="col-10 d-flex justify-content-center flex-column">
        <div class="row">
          <div class="col-lg-5">
            <Icon type="ios-mail" />
            {{ user.email }}
          </div>
          <div class="col-lg-5">
            <template v-if="fullName">
              <Icon type="ios-person" />
              {{ fullName }}
            </template>
          </div>
          <div class="col-lg-2">
            <div
              v-for="role in user.roles"
              :key="role.id"
              class="ivu-tag ivu-tag-size-default ivu-tag-checked"
            >
              <span class="ivu-tag-text">{{ role.name }}</span>
            </div>
          </div>
        </div>
      </div>
      <div class="col-2 d-flex justify-content-end align-items-center">
        <Dropdown
          trigger="click"
          placement="bottom-end"
        >
          <VButton
            type="text"
            size="large"
          >
            <Icon
              type="md-more"
              size="large"
            />
          </VButton>
          <template #list>
            <DropdownMenu>
              <DropdownItem
                @click="editUser"
              >
                Edit
              </DropdownItem>
              <DropdownItem
                @click="resetPassword"
              >
                Reset password
              </DropdownItem>
              <DropdownItem
                v-if="removable"
                @click="deleteUser"
              >
                Remove
              </DropdownItem>
            </DropdownMenu>
          </template>
        </Dropdown>
      </div>
    </div>
    <Spin
      v-if="isLoading"
      fix
    />
  </Card>
</template>

<script>
import api from 'application/api'
import UserForm from 'application/components/user_form'

export default {
  name: 'User',
  props: {
    user: {
      type: Object,
      required: true
    },
    removable: {
      type: Boolean,
      required: false,
      default: true
    }
  },
  emits: ['update'],
  data () {
    return {
      isLoading: false
    }
  },
  computed: {
    fullName () {
      return [this.user.first_name, this.user.last_name].filter(Boolean).join(' ')
    }
  },
  methods: {
    editUser () {
      this.$Modal.open(UserForm, {
        user: this.user,
        requirePassword: false,
        mode: 'update',
        onSuccess: (data) => {
          this.$Modal.remove()
          this.$Message.info(`${data.email} user has been updated`)

          this.$emit('update')
        }
      }, {
        closable: true
      })
    },
    resetPassword () {
      this.isLoading = true

      api.post(`admin_users/${this.user.id}/reset_password`).then(() => {
        this.$Message.info(`Reset password instructions have been sent to ${this.user.email}`)
      }).catch((error) => {
        console.error(error)

        this.$Message.error('Unable to perform this action')
      }).finally(() => {
        this.isLoading = false
      })
    },
    deleteUser () {
      this.$Dialog.confirm({
        title: 'Are you sure?',
        closable: true,
        onOk: () => {
          api.delete(`admin_users/${this.user.id}`).then(() => {
            this.$Message.info(`${this.user.email} user has been removed`)

            this.$emit('update')
          }).catch((error) => {
            console.error(error)
            this.$Message.error('Unable to perform this action')
          })
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
:deep(.ivu-card-body) {
  padding: 8px 16px;
}
</style>
