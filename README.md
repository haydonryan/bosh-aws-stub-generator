# Cloud Foundry - BOSH deployment Stub Generator for AWS

## Introduction
This tool is used for generating a bosh stub file after you have run bosh aws
boostrap micro. It automates the generation of the inital stub.

Making the correct changes to the stub and generating secure passwords is
annoying.  This ruby script automates as much as possible.

Note this script assumes that the bosh aws create receipts are in the
current directory.

## Usage
run ```ruby generate deployment_name``` where deployment name is the name of the deployment.

To save this to a file pipe the output of the command to your desired YAML
file.


