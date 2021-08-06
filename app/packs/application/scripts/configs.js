const appNode = document.getElementById('app')

const basePath = appNode.getAttribute('data-base-path')
const version = appNode.getAttribute('data-version')

export { version, basePath }
