import { reactive } from 'vue'

const appNode = document.getElementById('app')
const userAttrs = JSON.parse(appNode.getAttribute('data-current-user') || 'null') || {}
const currentUser = reactive(userAttrs)

function setCurrentUser (attrs) {
  Object.assign(currentUser, attrs)
}

export { currentUser, setCurrentUser }
