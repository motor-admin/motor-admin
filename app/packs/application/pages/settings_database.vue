<template>
  <Card>
    <DatabaseForm
      :configs="configs"
      :submit-text="'Update'"
      @success="showSuccessMessage"
    />
  </Card>
  <VButton
    size="large"
    long
    type="dashed"
    class="my-3"
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
import { databaseUrlToObject } from 'application/scripts/urls'

import DatabaseForm from 'application/components/database_form'

export default {
  name: 'DatabaseSettingsPage',
  components: {
    DatabaseForm
  },
  data () {
    return {
      isLoaded: false,
      configs: { protocol: 'postgres' }
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
        const dbUrl = result.data.data.value[0].url

        this.configs = { url: dbUrl, ...databaseUrlToObject(dbUrl) }
      }).catch((error) => {
        console.error(error)
      })
    },
    openAddDatabaseModal () {
      this.$Dialog.info({
        title: 'Multiple databases are available in Motor Admin Pro',
        okText: 'Learn More',
        onOk () {
          location.href = 'https://www.getmotoradmin.com/pro'
        }
      })
    },
    showSuccessMessage () {
      this.$Message.info('Database credentials have been updated successfuly')
    }
  }
}
</script>
