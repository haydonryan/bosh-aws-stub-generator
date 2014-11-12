#!/usr/bin/ruby

require 'erb'
require 'ostruct'

placeholders = {
"placeholder_name"                                 => "hnrglobal",     #
"placeholder_director_uuid"                        => "",
"placeholder_access_key_id"                        => '456',
"placeholder_secret_key"                           => '',
"placeholder_subnet_for_az1"                       => '',
"placeholder_subnet_for_az2"                       => '',
"placeholder_domain"                               => '',
"placeholder_uaa_cert"                             => '', 
"placeholder_nats_user"                            => '',
"placeholder_nats_password"                        => '',
"placeholder_cc_db_encryption_key"                 => '',
"placeholder_bulk_api_password"                    => '',
"placeholder_staging_upload_password"              => '',
"placeholder_staging_upload_user"                  => '',
"placeholder_uaa_admin_client_secret"              => '',
"placeholder_uaa_jwt_signing_key"                  => '',  # Use the YAML "|" character to format multiline RSA key data
"placeholder_uaa_jwt_verification_key"             => '', # Use the YAML "|" character to format multiline RSA key data
"placeholder_uaa_clients_login_secret"             => '',
"placeholder_uaa_clients_developer_console_secret" => '',
"placeholder_uaa_clients_app_direct_secret"        => '',
"placeholder_uaa_clients_support_services_secret"  => '',
"placeholder_uaa_clients_servicesmgmt_secret"      => '',
"placeholder_uaa_clients_space_mail_secret"        => '',
"placeholder_uaa_clients_notification_secret"      => '',
"placeholder_uaa_batch_username"                   => '',
"placeholder_uaa_batch_password"                   => '',
"placeholder_uaa_cc_client_secret"                 => '',
"placeholder_uaadb_properties"                     => '', 
"placeholder_ccdb_properties"                      => '',
"placeholder_router_status_user"                   => '',
"placeholder_router_status_password"               => '',
:PLACEHOLDER_LOGGREGATOR_SECRET                    => "HELL YES" 
}

class ErbBinding < OpenStruct
    def get_binding
        return binding()
    end
end



data = {:bar => "baz"}
vars = ErbBinding.new(placeholders)

template = "foo <%= bar %>"
template = File.read("./template.erb")
erb = ERB.new(template)

vars_binding = vars.send(:get_binding)
puts erb.result(vars_binding)





#ns = Namespace.new(placeholders)
#print ERB.new(template).result(ns.instance_eval { binding })


#puts placeholders

#new_file = File.open("./result.txt", "w+")
#puts ErbalT::render_from_hash(template, placeholders)
#new_file.close

#puts placeholders["PLACEHOLDER_LOGGREGATOR_SECRET"]

#foo = Foo.new
#foo.PLACEHOLDER_NATS_PASSWORD = "Hello"
#new_file << ERB.new(template).result(foo.template_binding)
#new_file.close
