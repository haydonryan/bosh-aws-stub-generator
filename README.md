# Cloud Foundry - BOSH deployment Stub Generator for AWS

## Introduction
This tool is used for generating a bosh stub file after you have run bosh aws
bootstrap micro. It automates the generation of the initial stub.

Making the correct changes to the stub and generating secure passwords is
annoying.  This ruby script automates as much as possible.

Note this script assumes that the bosh aws create receipts are in the
current directory.

## Usage
run ```ruby generate_stub.rb deployment_name use_ssl``` where deployment_name is the name of the deployment and use_ssl is either true or false.

To save this to a file pipe the output of the command to your desired YAML
file.
