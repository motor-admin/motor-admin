# Building custom forms

## [Demo](https://app.getmotoradmin.com/demo/forms/2)

Custom forms can include regular field, field groups, and lists which allow to send complex JSON data to the API to process the form.

![Form builder](https://user-images.githubusercontent.com/5418788/122927844-f29be400-d371-11eb-8f11-0efd2268d941.png)

* Fields allow to send a regular JSON key-value pair: `{"field1": "value1"}`
* Fields with multiple options allow to send an array of values: `{"field1": ["value1", "value2"]}`
* Field groups allow to send a nested JSON: `{"field1": {"nested_field_1": "value1"}}`
* Field groups with multiple option allow to send an array of JSON objects: `{"field1": [{"nested_field_1": "value1"}, {"nested_field_1": "value2"}]}`

## Using custom selectors

Sometimes selector field options should be updated based on a specific form field. For instance, if the state selector field is set to 'Michigan' then only cities from Michigan should be displayed in the cities selector options. Custom selector queries with variables allow to achieve this behavior:

```sql
SELECT id as value, name as label FROM cities
{{#state}} WHERE state = {{state}} {{/state}}
```

## Loading form data

It's possible to load initial form data from the API by specified an API endpoint in form settings. Loading initial data is useful for forms which are used for `update` actions where the existing data should be prefilled and further modified in the form.

![Loading data](https://user-images.githubusercontent.com/5418788/122924891-f1b58300-d36e-11eb-9a38-688bcc4590e3.png)

## Authorizing form

All custom forms are submitted with `Authorization` header which contains JWT that can be used to verify the request and fetch user id. `SECRET_KEY_BASE` key from Motor Admin can be used to verify jwt:

```js
const express = require('express')
const jwt = require('jsonwebtoken')
const app = express()

app.post('/custom_form_api_enpoint', (req, res) => {
  const [_, jwtToken] = req.headers.authorization.split(' ')

  jwt.verify(jwtToken, process.env.SECRET_KEY_BASE, (err, decoded) => {
    if (err) {
      res.send('Unauthorized')
    } else {
      res.send(decoded)
    }
  })
})

app.listen(3000, () => {
  console.log(`Example app listening at http://localhost:3000`)
})
```
