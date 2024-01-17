# **S3 Bucket Upload Script - Step-by-Step Guide**

Welcome to my step-by-step guide on using the AWS CLI to upload files to Amazon S3. This guide adheres to best practices by creating an IAM role, assigning a profile, and ensuring the secure handling of AWS credentials.

## **Prerequisites**
1. AWS Account. If you don't have an AWS account, [Create an AWS account](https://aws.amazon.com/resources/create-account/)
   
2. AWS CLI Installation [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)


## **AM Role Creation**
When interacting with AWS services using the AWS CLI, it is a best practice to use IAM roles rather than exposing access keys directly. Below are the steps to create an IAM role with the least privileges needed for S3 operations.
To do this: 
    Open AWS Management Console and go to IAM dashboard.
    Select "Roles" and click "Create role."
    Choose "AWS service" as trusted entity, and "EC2" as use case.
    Attach policies (e.g., AmazonS3FullAccess).
    Provide a name (e.g., S3UploadRole) and click "Create role."
    Click on the created role. Copy the Role ARN. (You will need this for the next step

IAM User Association:
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

AWS CLI Profile Configuration:

    Open a terminal.Run the following command to configure the antznette profile:

aws configure --profile <profilename>

You'll be prompted to enter AWS access key, secret key, default region, and output format. Provide the access and secret key associated with the IAM user with the attached role.

5. create the Script

Create a file and navigate into the file to write your script using the command below (your script name can be anything but end with .sh)

touch s3_upload.sh
nano s3_upload.sh


Explanation:

    display_error Function: This function is used to show error messages and exit the script if an error occurs during the execution.

    display_success Function: This function displays a success message when the file upload process completes without errors.

    Command-line Arguments: The script expects at least two arguments: <bucket_name> and <file1>. Additional files (file2 ... fileN) and an optional target directory can also be provided.

    File Existence Check: Before uploading each file, the script checks whether the file exists. If not, it displays an error message.

    AWS S3 Upload Command: The AWS CLI is used to upload each file to the specified S3 bucket and directory. The --profile antznette option is used to specify the AWS CLI profile.

    Exit Status Check: After each file upload, the script checks the exit status of the last command (aws s3 ...). If the exit status is non-zero, it indicates an error, and the script displays an appropriate error message.

    Success Message: If all file uploads are successful, the script displays a success message.

    The shift command in the script is used to shift the positional parameters to the left, effectively removing the first argument (BUCKET_NAME) from the list of parameters. This is done to make it easier to process the remaining arguments.


    7. Save and Exit

In Nano:

    Press Ctrl + X to exit.
    Press Y to confirm changes.
    Press Enter to save the file.

8. Set Execution Permission

Make the script executable:

bash

chmod +x s3_upload.sh


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
