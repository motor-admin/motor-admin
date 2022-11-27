<template>
  <Card
    class="mb-3"
    style="line-height: normal"
  >
    <div class="d-flex align-items-center mt-2">
      Language
      <select
        v-model="language"
        size="1"
        class="ms-2"
        @change="changeLanguage"
      >
        <option value="en">
          English
        </option>
        <option value="es">
          Español
        </option>
        <option value="el">
          Ελληνικά
        </option>
      </select>
    </div>
    <Divider />
    <div class="align-items-center mb-2">
      <VForm>
        <FormItem
          prop="token"
          label="Slack Token"
          class="col-12 mb-2"
        >
          <VInput
            v-model="slackApiKey"
            type="text"
            placeholder="API Token"
          />
        </FormItem>
        <a
          href="https://my.slack.com/services/new/bot"
          target="_blank"
        >Create a Slack Bot here</a>
        <VButton
          type="primary"
          class="mt-3"
          size="large"
          long
          @click="setSlackToken"
        >
          Submit
        </VButton>
      </VForm>
    </div>
    <Divider />
    <div class="align-items-center mb-2">
      <VForm>
        <FormItem
          prop="html"
          label="Tracking script"
          class="col-12 mb-2"
        >
          <VInput
            v-model="configs['ui.custom_html']"
            type="textarea"
            placeholder="<script> </script>"
            :autosize="{ minRows: 4, maxRows: 7 }"
          />
        </FormItem>
        <VButton
          type="primary"
          class="mt-3"
          size="large"
          long
          @click="setCustomHtml(configs['ui.custom_html'])"
        >
          Submit
        </VButton>
      </VForm>
    </div>
    <Spin
      v-if="isLoading"
      fix
    />
  </Card>
</template>

<script>
import api from 'application/api'

export default {
  name: 'OtherSettingsPage',
  data () {
    return {
      isLoading: false,
      checked: false,
      slackApiKey: '',
      language: document.documentElement.getAttribute('lang'),
      configs: {}
    }
  },
  mounted () {
    this.loadSlackCredentials()
    this.loadConfigs()
  },
  methods: {
    changeLanguage (event) {
      api.post('configs', {
        key: 'language',
        value: event.target.value
      }).then(() => {
        this.$Message.info('Admin panel language has been changed!')

        document.documentElement.setAttribute('lang', event.target.value)
      })
    },
    setCustomHtml (value) {
      api.post('configs', {
        key: 'ui.custom_html',
        value: value
      }).then(() => {
        this.$Message.info('Changes have been saved!')
      })
    },
    setSlackToken (event) {
      api.post('encrypted_configs', {
        key: 'slack.credentials',
        value: { api_key: this.slackApiKey }
      }).then(() => {
        this.$Message.info('Credentials has been saved!')
      })
    },
    loadConfigs () {
      api.get('configs').then((result) => {
        this.configs = result.data.data.reduce((acc, conf) => {
          acc[conf.key] = conf.value

          return acc
        }, {})
      })
    },
    loadSlackCredentials () {
      api.get('encrypted_configs/slack.credentials').then((result) => {
        this.slackApiKey = result.data.data.value.api_key || ''
      })
    },
    showDialog () {
      this.$nextTick(() => {
        this.checked = false
      })

      this.$Dialog.info({
        title: 'This feature is available in Motor Admin Pro',
        okText: 'Learn More',
        onOk () {
          location.href = 'https://www.getmotoradmin.com/pro'
        }
      }, {
        closable: true
      })
    }
  }
}
</script>
