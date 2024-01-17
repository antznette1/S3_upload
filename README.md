# **S3 Bucket Upload Script - Step-by-Step Guide**

Welcome to my step-by-step guide on using the AWS CLI to upload files to Amazon S3. This guide adheres to best practices by creating an IAM role, assigning a profile, and ensuring the secure handling of AWS credentials.

## **Prerequisites**
1. AWS Account. If you don't have an AWS account, [Create an AWS account](https://aws.amazon.com/resources/create-account/)
   
2. AWS CLI Installation [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)


## **AM Role Creation**
When using the AWS CLI to interact with AWS services, it's a best practice to employ IAM roles rather than exposing access keys directly. Follow these steps to create an IAM role with the minimal privileges required for S3 operations:

  Open the AWS Management Console and navigate to the IAM dashboard.

  Select "Roles" and click "Create role."

  Choose "AWS service" as the trusted entity and "EC2" as the use case.

  Attach policies, such as AmazonS3FullAccess, based on your requirements.

  Provide a meaningful name, e.g., S3UploadRole, and click "Create role."

  Click on the created role, and copy the Role ARN. You'll need this for the next step.

### **IAM User Association**:
    You need an IAM user, who will assume the S3UploadRole.
    Ensure the IAM user has the necessary permissions to assume roles (sts:AssumeRole permission).
    Edit the trust relationship of the Role to allow the IAM user to assume this role.

Example trust relationship policy:

json

{
  "Effect": "Allow",
  "Principal": {
    "AWS": "arn:aws:iam::<account-id>:user/<iamusername>"
  },
  "Action": "sts:AssumeRole"
}

## **AWS CLI Profile Configuration**

Open a terminal.Run the following command to configure the antznette profile:

aws configure --profile <profilename>

You'll be prompted to enter AWS access key, secret key, default region, and output format. Provide the access and secret key associated with the IAM user with the attached role.

## **create the Script**

Create a file and navigate into the file to write your script using the command below (your script name can be anything but end with .sh)

touch s3_upload.sh
nano s3_upload.sh


Explanation:

   display_error Function: Displays error messages and exits the script in case of an error.

    display_success Function: Displays a success message upon successful completion of the file upload process.

    Command-line Arguments: The script expects a minimum of two arguments: <bucket_name> and <file1>. Additional files (file2 ... fileN) and an optional target directory can be provided.

    File Existence Check: Checks if each specified file exists before attempting to upload. Displays an error message if a file is not found.

    AWS S3 Upload Command: Utilizes the AWS CLI to upload each file to the specified S3 bucket and directory. The --profile antznette option specifies the AWS CLI profile.

    Exit Status Check: After each file upload, the script checks the exit status of the last command (aws s3 ...). A non-zero exit status indicates an error, triggering the display of an appropriate error message.

    Success Message: Displays a success message if all file uploads are successful.

The shift command removes the first argument (BUCKET_NAME) from the list of parameters, simplifying the processing of the remaining arguments.


## **Save and Exit**

In Nano, Ctrl + X to exit, Press Y to confirm changes and Enter to save the file.

## **Set Execution Permission**

Make the script executable by running chmod +x s3_upload.sh


Usage
Basic Usage

bash

./s3_upload.sh s3_bucket_name file1.txt [file2 ... fileN] [target_directory]

Examples

    Upload a Single File:

    bash

./s3_upload.sh my_bucket_name my_file.txt

Upload Multiple Files to a Specific Directory:

bash

    ./s3_upload.sh my_bucket_name file1.txt file2.txt target_directory

Folder or No Folder

    If only one file is uploaded, it will be placed directly in the root of the bucket.
    If multiple files are uploaded, they will be placed in the specified target directory.

Troubleshooting

    If you encounter an "Upload failed" error, check the error message displayed. Common issues include incorrect file paths or AWS CLI configuration.
