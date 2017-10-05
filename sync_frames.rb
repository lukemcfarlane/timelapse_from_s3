require 'bundler/setup'
require 'aws-sdk'
require 'fileutils'
require 'pry'
require_relative 'constants'

unless Dir.exist? PHOTOS_OUTPUT_DIR
  Dir.mkdir PHOTOS_OUTPUT_DIR
end

puts `aws s3 sync s3://#{PHOTOS_BUCKET_NAME} #{PHOTOS_OUTPUT_DIR}`
