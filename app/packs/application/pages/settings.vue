<template>
  <div class="header">
    <div class="d-flex align-items-center">
      <a
        class="ivu-btn ivu-btn-primary d-flex align-items-center justify-content-center"
        :href="basePath"
        target="_self"
        style="width: 44px; height: 42px;"
      ><span><div
        class="d-flex align-items-center"
      ><svg
        xmlns="http://www.w3.org/2000/svg"
        width="26"
        height="26"
        viewBox="0 0 24 24"
        stroke-width="2"
        stroke="currentColor"
        fill="none"
        stroke-linecap="round"
        stroke-linejoin="round"
      ><path
        stroke="none"
        d="M0 0h26v26H0z"
        fill="none"
      /><polyline
        points="13 3 13 10 19 10 11 21 11 14 5 14 13 3"
      /></svg></div></span></a>
      <span
        class="ms-2 text-white"
        style="font-size: 15px; font-weight: 500;"
      >Settings</span>
    </div>

    <a
      class="ivu-btn ivu-btn-primary ivu-btn-large ms-2"
      :href="basePath"
    >
      <span><i
        class="ion ion-md-arrow-round-back"
      /><span
        style="vertical-align: middle;"
      >Admin Panel</span></span>
    </a>
  </div>
  <div
    class="container mt-3"
    style="max-width: 800px"
  >
    <div class="ivu-tabs">
      <div class="ivu-tabs-bar">
        <div
          class="ivu-tabs-nav-container"
        >
          <div
            class="ivu-tabs-nav-wrap"
            style="position: relative;"
          >
            <div class="ivu-tabs-scroll">
              <div
                class="ivu-tabs-nav text-center w-100"
              >
                <RouterLink
                  v-for="tab in tabs"
                  :key="tab.title"
                  :class="{ 'ivu-tabs-tab-focused ivu-tabs-tab-active' : tab === currentTab }"
                  class="ivu-tabs-tab"
                  :to="tab.to"
                >
                  {{ tab.title }}
                </RouterLink>
              </div>
            </div>
          </div>
        </div>
      </div>
      <slot />
    </div>
    <div class="position-relative">
      <RouterView />
      <div
        class="text-center"
        style="bottom: 0"
      >
        <a
          href="https://github.com/motor-admin/motor-admin"
          target="_blank"
        >Motor Admin v{{ version }}</a>
      </div>
    </div>
  </div>
</template>

<script>
import { basePath, version } from 'application/scripts/configs'

export default {
  name: 'SettingsPage',
  computed: {
    basePath: () => basePath,
    version: () => version,
    currentTab () {
      return this.tabs.find((tab) => tab.to.name === this.$route.name)
    },
    tabs () {
      return [
        { title: 'General', to: { name: 'general_settings' } },
        { title: 'Users', to: { name: 'users_settings' } },
        { title: 'Roles', to: { name: 'roles_settings' } },
        { title: 'Database', to: { name: 'database_settings' } },
        { title: 'Email', to: { name: 'email_settings' } },
        { title: 'Storage', to: { name: 'storage_settings' } },
        { title: 'Other', to: { name: 'other_settings' } }
      ]
    }
  }
}
</script>

<style lang="scss">
@import 'application/styles/variables';

.header {
  background-color: $primary-color;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 12px;

  .ivu-btn {
    font-size: 15px;
    font-weight: 500;
    display: flex;
    align-items: center;

    .ion {
      vertical-align: sub;
      line-height: 1;
    }

    .ion-md-arrow-round-back {
      font-size: 20px;
    }
  }
}

.ivu-tabs-tab {
  padding: 8px 32px;
  margin: 0;

  @media screen and (max-width: $breakpoint-md) {
    padding: 8px 18px;
  }
}

a.ivu-tabs-tab {
  color: inherit;
}

.ivu-tabs-tab-active {
  border-bottom: 3px solid $primary-color;
}

.ivu-tabs-tab {
  user-select: none;
}

.ivu-tabs-scroll {
  overflow-x: auto;

  &::-webkit-scrollbar {
    display: none;
  }
}
</style>
