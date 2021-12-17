# Resource file attachments

Motor Admin allows to attach images and files to resources via associated built-it `Attachment` table.
By default, all files are stored on disk in the current working directory inside the `motor-admin-attachments` folder.

### Attachment column

Single attachment can be defined via reference column on `Attachment` resource:

![Image](https://user-images.githubusercontent.com/5418788/146550340-12dedae9-be16-4e64-8fd7-fc90132e4c7b.png)

### Attachments association

Multiple attachments can be defined via association on `Attachment` resource:

![Files](https://user-images.githubusercontent.com/5418788/146551151-7f5b9d5e-2d11-4cd4-9bb6-7311db364df1.png)

### AWS S3

Alternatively, it's possible to store attachments on S3 by specifying AWS credentials:

![Settings](https://user-images.githubusercontent.com/5418788/146551348-3b2e97b6-b759-489e-8fb8-993154e1195e.png)
