import axios from 'axios'

import { basePath } from 'application/scripts/configs'

const api = axios.create({
  baseURL: basePath.replace(/\/?$/, '/api')
})

export default api
