function databaseUrlToObject (url) {
  const pattern = /^(?:([^:/?#\s]+):\/{2})?(?:([^@/?#\s]+)@)?([^/?#\s]+)?(?:\/([^?#\s]*))?(?:[?]([^#\s]+))?\S*$/
  const matches = url.match(pattern)

  return {
    protocol: matches[1] === 'mysql' ? 'mysql2' : matches[1],
    username: matches[2] !== undefined ? matches[2].split(':')[0] : undefined,
    password: matches[2] !== undefined ? matches[2].split(':')[1] : undefined,
    host: matches[3] !== undefined ? matches[3].split(/:(?=\d+$)/)[0] : undefined,
    port: matches[3] !== undefined ? matches[3].split(/:(?=\d+$)/)[1] : undefined,
    database: matches[4]
  }
}

export { databaseUrlToObject }
