import { createRouter, createWebHistory } from 'vue-router'

import SetupPage from 'application/pages/setup'
import SettingsPage from 'application/pages/settings'
import UsersSettingsPage from 'application/pages/settings_users'
import RolesSettingsPage from 'application/pages/settings_roles'
import GeneralSettingsPage from 'application/pages/settings_general'
import DatabaseSettingsPage from 'application/pages/settings_database'
import EmailSettingsPage from 'application/pages/settings_email'
import StorageSettingsPage from 'application/pages/settings_storage'
import OtherSettingsPage from 'application/pages/settings_other'

import { basePath } from 'application/scripts/configs'

const routes = [
  {
    path: '/setup',
    component: SetupPage,
    name: 'setup'
  },
  {
    path: '/settings',
    component: SettingsPage,
    name: 'settings',
    redirect: { name: 'general_settings' },
    children: [
      {
        path: 'general',
        component: GeneralSettingsPage,
        name: 'general_settings'
      },
      {
        path: 'users',
        component: UsersSettingsPage,
        name: 'users_settings'
      },
      {
        path: 'roles',
        component: RolesSettingsPage,
        name: 'roles_settings'
      },
      {
        path: 'database',
        component: DatabaseSettingsPage,
        name: 'database_settings'
      },
      {
        path: 'email',
        component: EmailSettingsPage,
        name: 'email_settings'
      },
      {
        path: 'storage',
        component: StorageSettingsPage,
        name: 'storage_settings'
      },
      {
        path: 'other',
        component: OtherSettingsPage,
        name: 'other_settings'
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(basePath),
  routes
})

export default router
