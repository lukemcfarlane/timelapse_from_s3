require 'aws-sdk'

s3 = Aws::S3::Resource.new(
  region: 'us-east-2',
  credentials: Aws::Credentials.new(
    ENV.fetch('ACCESS_KEY_ID'),
    ENV.fetch('SECRET_ACCESS_KEY')
  )
)

bucket = s3.bucket('timelapsephotos')

total_num_objects = bucket.objects.count

bucket.objects.each_with_index do |object, index|
  filename = "#{object.key}.jpg"
  if object.download_file "./objects/#{filename}"
    puts "Downloaded #{filename} (#{index + 1} of #{total_num_objects})"
  end
end
