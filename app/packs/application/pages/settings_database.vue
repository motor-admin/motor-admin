<template>
  <Card
    v-if="!configs.length"
    class="mb-3"
  >
    <DatabaseForm
      :submit-text="'Update'"
      :is-default-setup="true"
      @submit="handleUpdate"
    />
  </Card>
  <Card
    v-for="(config, index) in configs"
    :key="index"
    class="mb-3"
  >
    <div v-if="config.name !== 'default'">
      <div class="row">
        <div class="col fs-3 fw-bold">
          {{ config.name }}
        </div>
        <div class="col">
          <VButton
            type="error"
            class="float-end"
            ghost
            icon="md-trash"
            @click="remove(index)"
          >
            Remove
          </VButton>
        </div>
      </div>
      <Divider class="mb-1 mt-3" />
    </div>
    <VForm
      v-if="!config.showFullForm"
      :model="config"
    >
      <FormItem
        prop="url"
        label="URL"
        class="col-12 mb-2"
        :rules="[{required: true}]"
      >
        <VInput
          :model-value="config.url.replace(/\/\/.*?@/, '//xxxxx:xxxxx@')"
          type="text"
          size="large"
          placeholder="postgresql://username:password@localhost:5432/db_name"
        />
      </FormItem>
      <VButton
        icon="ios-arrow-down"
        type="text"
        long
        @click="config.showFullForm = true"
      >
        Expand
      </VButton>
    </VForm>
    <DatabaseForm
      v-else
      :configs="config"
      :submit-text="'Update'"
      @submit="handleUpdate"
    />
  </Card>
  <VButton
    size="large"
    long
    type="dashed"
    class="mb-3"
    @click="openAddDatabaseModal"
  >
    <Icon type="md-add" />
    Add Database
  </VButton>
  <Spin
    v-if="!isLoaded"
    fix
  />
</template>

<script>
import api from 'application/api'

import DatabaseForm from 'application/components/database_form'

export default {
  name: 'DatabaseSettingsPage',
  components: {
    DatabaseForm
  },
  data () {
    return {
      isLoaded: false,
      configs: []
    }
  },
  mounted () {
    this.loadConfigs().then(() => {
      this.isLoaded = true
    })
  },
  methods: {
    loadConfigs () {
      return api.get('encrypted_configs/database.credentials').then((result) => {
        this.configs = result.data.data.value
      }).catch((error) => {
        console.error(error)
      })
    },
    openAddDatabaseModal () {
      this.$Modal.open(DatabaseForm, {
        withName: true,
        onSubmit: (data) => {
          this.handleUpdate(data).then(() => {
            this.$Modal.remove()
          })
        }
      }, {
        title: 'Add Database',
        closable: true
      })
    },
    remove (index) {
      this.$Dialog.confirm({
        title: 'Are you sure?',
        closable: true,
        onOk: () => {
          const dataConfigs = [...this.configs]

          dataConfigs.splice(index, 1)
          api.post('encrypted_configs', {
            data: {
              key: 'database.credentials',
              value: dataConfigs.map((config) => ({ name: config.name, url: config.url }))
            }
          }).then((result) => {
            this.$Message.info('Database credentials have been removed')

            this.configs = result.data.data.value
          }).catch((error) => {
            console.error(error)
          })
        }
      })
    },
    handleUpdate (configs) {
      const dataConfigs = [...this.configs]
      const index = dataConfigs.findIndex((c) => c.name === configs.name)

      if (index === -1) {
        dataConfigs.push(configs)
      } else {
        dataConfigs.splice(dataConfigs.findIndex((c) => c.name === configs.name), 1, configs)
      }

      return api.post('encrypted_configs', {
        data: {
          key: 'database.credentials',
          value: dataConfigs.map((config) => ({ name: config.name, url: config.url, schema_search_path: config.schema_search_path }))
        }
      }).then((result) => {
        this.$Message.info('Database credentials have been updated successfuly')

        this.configs = result.data.data.value
      }).catch((error) => {
        if (error.response?.data?.errors) {
          this.$Message.error(error.response.data.errors.join('\n'))
        } else {
          console.error(error)
        }
      })
    }
  }
}
</script>
