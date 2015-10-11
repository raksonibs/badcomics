require 'aws-sdk'
# Rails.configuration.aws is used by AWS, Paperclip, and S3DirectUpload
Rails.configuration.aws = YAML.load(ERB.new(File.read("#{Rails.root}/config/aws.yml")).result)[Rails.env].symbolize_keys!
AWS.config(logger: Rails.logger)
AWS.config(Rails.configuration.aws)
 
# config/initializers/paperclip.rb
Paperclip::Attachment.default_options.merge!(
  url:                  ':s3_domain_url',
  path:                 ':class/:attachment/:id/:style/:filename',
  storage:              :s3,
  s3_credentials:       Rails.configuration.aws,
  s3_permissions:       :private,
  s3_protocol:          'https'
)
 
#config/initializers/s3_direct_upload.rb
S3DirectUpload.config do |c|
  c.access_key_id     = Figaro.env.aws_access_key_id
  c.secret_access_key = Figaro.env.aws_secret_access_key
  c.bucket            = Figaro.env.bucket
  c.region            = "s3"
end