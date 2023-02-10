# Customizing resource table

## [Demo](https://app.getmotoradmin.com/demo/data/customers)

Resource table can be customized via resource columns settings. Additional columns can be added via custom SQL query:

![Resource SQL](https://user-images.githubusercontent.com/5418788/132258795-0ea5f4aa-cc96-4fb8-8524-0eea0c7663ea.png)

## Column types

| Type          | Table cell                                                                                                     | Description |
|---------------|----------------------------------------------------------------------------------------------------------------|-------------|
| Text          | ![image](https://user-images.githubusercontent.com/5418788/132329364-893809c5-394a-4c11-8981-21a2bdb7e365.png) | Single line text |
| Integer       | ![image](https://user-images.githubusercontent.com/5418788/132329871-2efd7aa4-3080-455b-8705-fe79e1b61c7d.png) | Number input |
| Decimal       | ![image](https://user-images.githubusercontent.com/5418788/132330560-156afeb8-32a2-43b5-8230-e7869792ddf8.png) | Number with floating point |
| Reference     | ![image](https://user-images.githubusercontent.com/5418788/132330652-6ccefa3e-b295-4527-b776-86b8cf119914.png) | Link to the related resource |
| Date and Time | ![image](https://user-images.githubusercontent.com/5418788/132330736-efeb2b7d-4a65-4938-94cf-81794d0537b0.png) | Date selector with time. Time is displayed using browser timezone |
| Date          | ![image](https://user-images.githubusercontent.com/5418788/132330973-69f3b428-b801-49a1-bfa0-d7e891a52da7.png) | Date selector |
| Boolean       | ![image](https://user-images.githubusercontent.com/5418788/132331042-c4aa005a-e737-42cc-9718-0aab9ebcf7b8.png) | Checkbox |
| Long text     | ![image](https://user-images.githubusercontent.com/5418788/132331095-dcb08cf2-39ab-477f-8840-0495ec3f919e.png) | Multiline text with textarea |
| Richtext      | ![image](https://user-images.githubusercontent.com/5418788/132331313-d4f22994-eae9-4b0e-8ce8-a703fc5dac4c.png) | HTML text with ActionText editor |
| Currency      | ![image](https://user-images.githubusercontent.com/5418788/132331360-d324056b-bb93-4b25-bfa8-711ca55b5ee5.png) | Formatted number with currency symbol. Cents currency base option formats currency from cents to decimal |
| Percentage    | ![image](https://user-images.githubusercontent.com/5418788/132331433-11751128-37c7-4a45-bb3f-705dbea82c36.png) | Expects a number between 0 and 100 to display it as a progress bar |
| Change        | ![image](https://user-images.githubusercontent.com/5418788/132331477-00e76e14-58de-4461-a892-0d809aa1ee39.png) | Expects positive or negative number |
| Chart         | ![image](https://user-images.githubusercontent.com/5418788/132331523-028b81de-04a8-499b-98af-b176694b1a3a.png) | Expects an array of numbers to build a simple line chart |
| Tag           | ![image](https://user-images.githubusercontent.com/5418788/132331579-95fbd0d8-ad4e-4bc1-baf9-479af04306e7.png) | Input with select options            |
| Link          | ![image](https://user-images.githubusercontent.com/5418788/132331632-d1e108d6-07f9-4335-b287-7d5cf9457dee.png) | URL or path displayed as a link or as a button |
| Color         | ![image](https://user-images.githubusercontent.com/5418788/132331659-252440a6-b358-4312-8614-a025ec8e348c.png) | Color in hex format with color picker |
| Image         | ![image](https://user-images.githubusercontent.com/5418788/132331706-68ae307c-971f-48c1-8ed3-eae3ab50287e.png) | Image with file input |
| File          | ![image](https://user-images.githubusercontent.com/5418788/132335004-c6e75e60-e043-4058-a299-071cfd59f5a2.png) | File link with file input |
| JSON          | ![image](https://user-images.githubusercontent.com/5418788/132335140-8a7e783f-6061-4ad1-9e7f-618baa35d11a.png) | JSON text editor |

