# NodeJS CLI Application Template Generator

A Node.js CLI application that generates a lambda function, s3 bucket and api gateway from template. This application helps you to easily create a Node.js or Python application with the desired project name, description, and selected features. If you are new with AWS and Terraform, I'm sure this repo will help you!!

## Requirements
* Node.js and npm installed on your machine.

## Installation
Clone the repository to your local machine and install the required packages by running the following command:

``` bash
npm install
```

## Usage

### Clone the repository

``` bash
git clone
```

### To install it globally, run the following command:

``` bash
npm install aws-basic-s3-lambda-apigateway-generator -g
```

Then, run the following command to start the application:

``` bash
aws-basic-s3-lambda-apigateway-generator
```

### To run it by cloning the repo:

Run the following command to start the application:

``` bash
npm start
```

The application will prompt you for the following information:

* Project Name (default: "my-node-app")
* Project Description (default: "A Node.js application")
* Lambda Name (default: "Lambda Name")
* Lambda Language (choices: "node" or "python")
* S3 Backend Bucket Name (default: "MY-AWS-BUCKET")

### Project Directory will be created on the same directory where you run the application, with project name as the directory name.

## Deployment of the application

### AWS Account
* Create an AWS account if you don't have one already. You can do it by following the instructions here: https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/

## Backend S3 Bucket
* Create a backend S3 bucket in AWS before running the application. The bucket name should be unique across all existing bucket names in Amazon S3. You can do it manually or using the AWS CLI.

## Github Repository
* Create a Github repository for your project. You can do it manually or using the Github CLI. Commit and push your changes to the repository.

## Github AWS Credentials
* Create a Github repository secret for your AWS credentials. You can do it manually or using the Github CLI. The secret name should be AWS_ACCESS_KEY and AWS_SECRET_KEY.

## Github Actions
* This repo has a default Github Actions workflow file that will be created when you run the application. You can modify the workflow file to suit your needs. The workflow file will be created in the .github/workflows directory. This will run the Terraform commands to deploy the application to AWS automatically when you push your changes to the Github repository branch master or main.

## NPM Package
https://www.npmjs.com/package/aws-basic-s3-lambda-apigateway-generator

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

