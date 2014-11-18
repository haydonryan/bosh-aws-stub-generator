#!/usr/bin/ruby

require 'erb'
require 'ostruct'
require 'openssl'
require 'yaml'
require 'socket'

#
# Commented out placeholders below are automatically generated by this script!
#

placeholders = {
#"placeholder_name"                                 => "hnrglobal",    # The Name of the Cloud Foundry install --- now taken from command line arg
#"placeholder_domain"                               => "cloud.hnrglobal.com",             # domain ie cloud.example.com
#"placeholder_director_uuid"                        => "",             # The director UUID - run 'bosh status' to get the UUID
#"placeholder_subnet_for_cf1"                       => "todo",
#"placeholder_subnet_for_cf2"                       => "todo",
#"placeholder_access_key_id"                        => "",             # AWS Access Key
#"placeholder_secret_key"                           => '',             # AWS Secret Key
#"placeholder_subnet_for_az1"                       => '',             # Get this value from AWS Console ie subnet-679a7c10
#"placeholder_subnet_for_az2"                       => '',             # Get this value from AWS Console ie subnet-679a7c10
"placeholder_uaa_cert"                              => 'null', 
"placeholder_skip_cert_verify"                       => 'false'        # Default to false
#"placeholder_uaa_jwt_signing_key"                  => '',              # Use the YAML "|" character to format multiline RSA key data
#"placeholder_uaa_jwt_verification_key"             => '',              # Use the YAML "|" character to format multiline RSA key data
#"placeholder_uaadb_properties"                     => '',             # get from aws_rds_receipt.yml
#"placeholder_ccdb_properties"                      => '',             # get from aws_rds_receipt.yml
#"placeholder_aws_region"                           => 'us-east-1',
#"placeholder_aws_az1"                              => 'us-east-1a',
#"placeholder_aws_az2"                              => 'us-east-1b',
#"placeholder_nats_user"                            => '',
#"placeholder_nats_password"                        => '',             # auto generated by this script.
#"placeholder_cc_db_encryption_key"                 => '',
#"placeholder_bulk_api_password"                    => '',
#"placeholder_staging_upload_password"              => '',
#"placeholder_staging_upload_user"                  => '',
#"placeholder_uaa_admin_client_secret"              => '',
#"placeholder_uaa_clients_login_secret"             => '',
#"placeholder_uaa_clients_developer_console_secret" => '',
#"placeholder_uaa_clients_app_direct_secret"        => '',
#"placeholder_uaa_clients_support_services_secret"  => '',
#"placeholder_uaa_clients_servicesmgmt_secret"      => '',
#"placeholder_uaa_clients_space_mail_secret"        => '',
#"placeholder_uaa_clients_notification_secret"      => '',
#"placeholder_uaa_batch_username"                   => '',
#"placeholder_uaa_batch_password"                   => '',
#"placeholder_uaa_cc_client_secret"                 => '',
#"placeholder_router_status_user"                   => '',
#"placeholder_router_status_password"               => '',
#:placeholder_loggregator_secret                    => "",
#:placeholder_buildpacks_key                        => "",
#:placeholder_resource_directory_key                => "",
#:placeholder_app_package_directory_key             => "",
#:placeholder_droplets_directory_key                => "",
#:placeholder_scim_admin_password                   => "",
#:placeholder_scim_services_password                => "",
#:placeholder_cloud_controler_admin_username         => "TODO",
#:placeholder_cloud_controler_admin_password         => "TODO",
#:placeholder_doppler_secret                         => ""
}

class ErbBinding < OpenStruct
    def get_binding
        return binding()
    end
end

def generatePassword ()
  o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
  string = (0...20).map { o[rand(o.length)] }.join
  return string
end

#
#check for correct parameters
#

if ( ARGV.count != 2 || ( ARGV[1] != "true" && ARGV[1] != "false" ) )
  print "USAGE: ./generate_stub.rb deployment_name use_ssl\n"
  print "use_ssl = true | false\n"
  exit(1)

end


placeholders["placeholder_name"] = ARGV[0]


placeholders["placeholder_nats_password"] = generatePassword() 
placeholders["placeholder_nats_user"] = generatePassword() 
placeholders["placeholder_cc_db_encryption_key"] = generatePassword() 
placeholders["placeholder_bulk_api_password"] = generatePassword() 
placeholders["placeholder_staging_upload_password"] = generatePassword()
placeholders["placeholder_staging_upload_user"] = generatePassword()
placeholders["placeholder_uaa_admin_client_secret"] = generatePassword()
placeholders["placeholder_uaa_clients_login_secret"] = generatePassword()
placeholders["placeholder_uaa_clients_developer_console_secret"] = generatePassword()
placeholders["placeholder_uaa_clients_app_direct_secret"] = generatePassword()
placeholders["placeholder_uaa_clients_support_services_secret"] = generatePassword()
placeholders["placeholder_uaa_clients_servicesmgmt_secret"] = generatePassword()
placeholders["placeholder_uaa_clients_space_mail_secret"] = generatePassword()
placeholders["placeholder_uaa_clients_notification_secret"] = generatePassword()
placeholders["placeholder_uaa_batch_username"] = generatePassword()
placeholders["placeholder_uaa_batch_password"] = generatePassword()
placeholders["placeholder_uaa_cc_client_secret"] = generatePassword()
placeholders["placeholder_router_status_user"] = generatePassword()
placeholders["placeholder_router_status_password"] = generatePassword()
placeholders["placeholder_loggregator_secret"] = generatePassword()
placeholders["placeholder_doppler_secret"] = generatePassword()
placeholders["placeholder_scim_admin_password"] = generatePassword()
placeholders["placeholder_scim_services_password"] = generatePassword()


placeholders["placeholder_cloud_controler_admin_password"] = placeholders["placeholder_scim_admin_password"]
#
#
# Load AWS VPC receipt into placeholder
aws_vpc = YAML.load_file('aws_vpc_receipt.yml')
aws = aws_vpc["aws"]
vpc = aws_vpc["vpc"]
placeholders["placeholder_aws_region"] = aws["region"]
placeholders["placeholder_aws_az1"] = aws["region"]+"a"  #hack regions in now assuming a and b
placeholders["placeholder_aws_az2"] = aws["region"]+"b"
placeholders["placeholder_access_key_id"] = aws["access_key_id"]
placeholders["placeholder_secret_key"] = aws["secret_access_key"] 




placeholders["placeholder_domain"] = vpc["domain"]
#placeholders["placeholder_director_uuid"] =
placeholders["placeholder_subnet_for_cf1"]= vpc["subnets"]["cf1"]
placeholders["placeholder_subnet_for_cf2"]= vpc["subnets"]["cf2"]

# If we are using self signed certs then download the cert from the ELB
# otherwise do nothing.

if ( ARGV[1] == "true" )
  tcp_client = TCPSocket.new("api." + vpc["domain"], 443)
  ssl_client = OpenSSL::SSL::SSLSocket.new(tcp_client)
  ssl_client.connect
  cert = OpenSSL::X509::Certificate.new(ssl_client.peer_cert)
  ssl_client.sysclose
  tcp_client.close
  cert = " \'" + cert.to_s + "\'"
  cert = cert.gsub("\n","\n\n      ")
  placeholders["placeholder_uaa_cert"] = cert

#  cert = cert.to_yaml.gsub("---\n","");
#  uaadb_fragment = "\n      " + uaadb_fragment.gsub("\n","\n      ") #indent text to correct YML position 
#  uaadb_fragment = uaadb_fragment.gsub(/(\n      )$/,"")            #remove errant whitespace at the end of the sub


placeholders["placeholder_skip_cert_verify"] = "true"


end


#cert = `openssl s_client -showcerts -connect api.#{vpc["domain"]}:443 2>%1 |sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'`
#print cert


# Generate Bucket Names for AWS
# Take domain name and change . to - and append the key type (Note: this is
# because AWS does not support the . character in bucket names)
placeholders["placeholder_buildpacks_key"] = placeholders["placeholder_domain"].gsub('.','-') + "-buildpacks"
placeholders["placeholder_resource_directory_key"] = placeholders["placeholder_domain"].gsub('.','-')  + "-resources"
placeholders["placeholder_app_package_directory_key"] = placeholders["placeholder_domain"].gsub('.','-')  + "-packages"
placeholders["placeholder_droplets_directory_key"] = placeholders["placeholder_domain"].gsub('.','-')  + "-droplets"

# Generate RSA Keys for JWT
rsa_key = OpenSSL::PKey::RSA.new(2048)
public_key = rsa_key.public_key.to_pem
private_key =  rsa_key.to_pem

# Format Keys for use in stub
private_key = private_key.gsub("\n","\n        ")
private_key = private_key.gsub(/(\n        )$/,"\n")            #remove errant whitespace at the end of the sub
public_key = public_key.gsub("\n","\n        ")
public_key = public_key.gsub(/(\n        )$/,"\n")            #remove errant whitespace at the end of the sub
placeholders["placeholder_uaa_jwt_signing_key"]       = " |\n        " + private_key
placeholders["placeholder_uaa_jwt_verification_key"]  = " |\n        " + public_key



#
#
# Load AWS RDS receipt into placeholder
rds = YAML.load_file('aws_rds_receipt.yml')["deployment_manifest"]["properties"]
ccdb = rds["ccdb"]
uaadb = rds["uaadb"]

#print "cCDB:\n" + ccdb.to_yaml
#print "\n"

#print "uAAdb:\n" + uaadb.to_yaml
#print "\n"

uaadb_fragment = uaadb.to_yaml.gsub("---\n","");
uaadb_fragment = "\n      " + uaadb_fragment.gsub("\n","\n      ") #indent text to correct YML position 
uaadb_fragment = uaadb_fragment.gsub(/(\n      )$/,"")            #remove errant whitespace at the end of the sub
ccdb_fragment = ccdb.to_yaml.gsub("---\n","");
ccdb_fragment = "\n      " + ccdb_fragment.gsub("\n","\n      ")  #indent text to correct YML position  
ccdb_fragment = ccdb_fragment.gsub(/(\n      )$/,"")              #remove errant whitespace at the end of the sub


placeholders["placeholder_uaadb_properties"] = uaadb_fragment
placeholders["placeholder_ccdb_properties"] = ccdb_fragment

#print rds.to_yaml
#YAML.dump(rds)


#
# Get Director UUID
#
output = `bosh status|grep "UUID"`
placeholders["placeholder_director_uuid"] =  output.match(/([a-z]|[0-9]){8}-([a-z]|[0-9]){4}-([a-z]|[0-9]){4}-([a-z]|[0-9]){4}-([a-z]|[0-9]){12}/) # Match for the UUID regular expression

uaadb_fragment = uaadb.to_yaml.gsub("---\n","");
uaadb_fragment = "\n      " + uaadb_fragment.gsub("\n","\n      ") #indent text to correct YML position 
uaadb_fragment = uaadb_fragment.gsub(/(\n      )$/,"")            #remove errant whitespace at the end of the sub
ccdb_fragment = ccdb.to_yaml.gsub("---\n","");
ccdb_fragment = "\n      " + ccdb_fragment.gsub("\n","\n      ")  #indent text to correct YML position  
ccdb_fragment = ccdb_fragment.gsub(/(\n      )$/,"")              #remove errant whitespace at the end of the sub


placeholders["placeholder_uaadb_properties"] = uaadb_fragment
placeholders["placeholder_ccdb_properties"] = ccdb_fragment

# Process ERB template
vars = ErbBinding.new(placeholders)
template = File.read("./template.erb")
erb = ERB.new(template)

vars_binding = vars.send(:get_binding)
puts erb.result(vars_binding)
