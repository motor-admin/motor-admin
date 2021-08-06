<template>
  <Card
    class="mb-3"
    style="line-height: normal"
  >
    <div class="d-flex align-items-center mb-4">
      <Switch
        v-model="checked"
        @on-change="showDialog"
      />
      <div class="ms-2">
        <span>Live Collaboration</span>
        <br>
        <small>Leave notes for team members and resolve customer support issues directly in the admin panel</small>
      </div>
    </div>
    <div class="d-flex align-items-center mb-4">
      <Switch
        v-model="checked"
        @on-change="showDialog"
      />
      <div class="ms-2">
        <span>Sales CRM</span>
        <br>
        <small>Sales stages, notes, reminders, and reports integrated with the application database data</small>
      </div>
    </div>
    <div class="d-flex align-items-center mb-4">
      <Switch
        v-model="checked"
        @on-change="showDialog"
      />
      <div class="ms-2">
        <span>Audit Logs</span>
        <br>
        <small>Log all changes made by users with the ability to review and revert the changed data</small>
      </div>
    </div>
    <div class="d-flex align-items-center">
      <Switch
        v-model="checked"
        @on-change="showDialog"
      />
      <div class="ms-2">
        <span>Slack/Teams Integration</span>
        <br>
        <small>Share resources and reports from the admin panel via direct integration</small>
      </div>
    </div>
  </Card>
</template>

<script>
export default {
  name: 'OtherSettingsPage',
  data () {
    return {
      checked: false
    }
  },
  methods: {
    showDialog () {
      this.$nextTick(() => {
        this.checked = false
      })

      this.$Dialog.info({
        title: 'This feature is available in Motor Admin Pro',
        okText: 'Learn More',
        onOk () {
          location.href = 'https://www.getmotoradmin.com/'
        }
      }, {
        closable: true
      })
    }
  }
}
</script>
