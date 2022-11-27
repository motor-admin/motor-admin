import { reactive } from 'vue'

const appNode = document.getElementById('app')

const schema = reactive(JSON.parse(appNode.getAttribute('data-schema')))
const modelSlugMap = Object.fromEntries(schema.map((res) => [res.slug, res]))
const modelNameMap = Object.fromEntries(schema.map((res) => [res.name, res]))

export { schema, modelSlugMap, modelNameMap }
