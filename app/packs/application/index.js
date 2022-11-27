import { createApp } from 'vue'

import App from './app'
import router from './router'

import DynamicModal from 'view3/src/plugins/dynamic-modal'
import DynamicDrawer from 'view3/src/plugins/dynamic-drawer'
import DynamicDialog from 'view3/src/plugins/dynamic-dialog'
import DynamicMessage from 'view3/src/plugins/dynamic-message'

import Button from 'view3/src/components/button'
import Dropdown from 'view3/src/components/dropdown'
import DropdownMenu from 'view3/src/components/dropdown-menu'
import DropdownItem from 'view3/src/components/dropdown-item'
import Card from 'view3/src/components/card'
import Icon from 'view3/src/components/icon'
import Input from 'view3/src/components/input'
import Form from 'view3/src/components/form'
import FormItem from 'view3/src/components/form-item'
import Radio from 'view3/src/components/radio'
import RadioGroup from 'view3/src/components/radio-group'
import Spin from 'view3/src/components/spin'
import Divider from 'view3/src/components/divider'
import Switch from 'view3/src/components/switch'
import Checkbox from 'view3/src/components/checkbox'
import Badge from 'view3/src/components/badge'
import MinimalSelect from './components/minimal_select'

const app = createApp(App)

app.component('VButton', Button)
app.component('Icon', Icon)
app.component('Card', Card)
app.component('VInput', Input)
app.component('VForm', Form)
app.component('FormItem', FormItem)
app.component('Spin', Spin)
app.component('Switch', Switch)
app.component('Radio', Radio)
app.component('RadioGroup', RadioGroup)
app.component('Divider', Divider)
app.component('Dropdown', Dropdown)
app.component('Checkbox', Checkbox)
app.component('Badge', Badge)
app.component('DropdownMenu', DropdownMenu)
app.component('DropdownItem', DropdownItem)
app.component('MSelect', MinimalSelect)

app.use(router)

app.use(DynamicModal)
app.use(DynamicDrawer)
app.use(DynamicDialog)
app.use(DynamicMessage)

export default app
