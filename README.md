
# Nuwe: Zurich Cloud hackathon 
**Team: TeamRain**



The current github repository is an automation of below requirements with the attach json file.

- Create a Lambda function that automates inserting data into DynamoDB.
- Create Terraform files to automatically create all the necessary resources.
- Automate the execution of the Lambda function to be triggered when uploading a JSON file to an s3 Bucket.
- Create a short README with the infrastructure created and the decisions taken during the process.

Reference Link: https://nuwe.io/dev/competitions/zurich-cloud-hackathon/online-preselection-cloud-challenge






## Installations
- Install and Configure AWS CLI from the aws documentation based on your environment(Linux/Mac/Windows)

   https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html 

- Configure your aws profile or access_key and secret_key (mentioned in above link **setup** left navigation)
- Validate your setup by running:
    ``` aws sts get-caller-identity ```

- Install the specified Terraform version from below link as the code tested on **v1.4.6**

```bash
  https://developer.hashicorp.com/terraform/downloads
```

## Steps
- Clone the repo 
- Goto the folder **/NUWE-Zurich-Cloud-Hackathon/terraform**
- Trigger below commands
```bash
  terraform init 
  terraform plan
  terraform apply -auto-approve
```
- Goto the AWS S3 console and upload the json file downloaded from the github repo.(**customer.json**)
- Goto AWS DynamoDB service and search for the table: **hackthon_dynamodb_table** and explore table item. You will able to see the customer.json data there. 




    👍 👍 


## FAQ

#### Can we do it with Terraform latest version?

Yes, You can give a try. However i have tested it on the above mention version in the installation steps. 

#### Have you used local backend?

Yes, I have used local backed. However the code is provided for S3 backend as well. Only thing you need to do is to provide the your s3 bucket name and uncomment that part of code in the provider.tf 


#### What will happen if we put multiple customer file in one upload?

You can put multiple customer json file in one go. however things to keep in mind that all json file should have the same scheme(attribute) mention below:
```json 
{
    "customer_id" :123456,
    "customer_name": "Amit Kumar",
    "location": "Krakow, Poland",
    "other_data": "Based on Requirement"

}
```

#### Do i need to provide any variable value in the terrform code?
Not required, All variable has a default value provided, You can alter as well

#### Can we alter schema of the jsonfile?
Partially yes, The customer_id and Customer_name are primary and secondry indexes of the table. You cant modify just the file. You need to alter the terraform variables as well to fix that.

#### How do we know the failures of events if we uploaded multiple customers file?
You can check the cloudwatch logs for the successful and failures of customer with customer_id also you can use dynamodb query to search the suspected one




## 🚀 About Me
I'm a Cloud DevOps Engineer working in Cisco Krakow, Poland



### Hi, I'm Amit! 👋
Reach me at **amitkumar8636@gmail.com**

