# Roles and permissions

## Defining role permissions

Motor Admin uses roles-based permissions control - users can contain multiple roles. Roles can be defined using [/settings/roles](http://localhost:3000/settings/roles) page.

### Resource permissions

![Resource permissions](https://user-images.githubusercontent.com/5418788/169973967-884fa1cd-f3f3-41aa-80bf-4d1fb91ebc46.png)

Resources permission rule can contain default `read`, `edit`, `create`, `remove` actions as well as any custom action. `manage` permission allows to perform all actions with the resource.

#### Resource columns

![Resource columns](https://user-images.githubusercontent.com/5418788/169974082-47090707-106f-4067-ae37-ef53afde4ccf.png)

It's possible to specify only a set of columns available for specific role via permission configurations.

#### Conditions and scopes

![Conditions and scopes](https://user-images.githubusercontent.com/5418788/169974661-e9135b22-434b-4f07-8fc2-3e5b7b69102a.png)

It's possible to set conditions on resource roles to scope the rows. On the screenshot above, user will be able to manage only customer where `kind` field equals `vip` and where `operator` field refers to current user.

### Reports and Forms permissions

![Reports and Forms permissions](https://user-images.githubusercontent.com/5418788/169975662-6df751b2-5154-4808-ad46-32b8a61cc023.png)

Queries, Dashboards and Forms can contain multiple tags which then can be used to build roles with permissions based on tags. On the screenshot above, users with given role will be able to access only forms with `operations` tag.

## Attaching role to users

![Attaching role to users](https://user-images.githubusercontent.com/5418788/169976078-d693f0cd-14a5-4c10-bf58-ff9a7c376079.png)

Roles can be assigned to users on [/settings/users](http://localhost:3000/settings/users) page.
