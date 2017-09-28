require 'bundler/setup'
require 'aws-sdk'
require 'pry'

DATE_RANGE = DateTime.new(2017, 9, 1)..DateTime.now
TIME_RANGE = Time.parse('07:00')..Time.parse('18:00')
MAX_INTERVAL_MINS = 60 * 24

def mins_between (datetime1, datetime2)
  ((datetime2.to_time - datetime1.to_time) / 60).floor
end

def is_within_time_range (time, range)
  time.strftime( "%H%M%S%N" ) >= range.first.strftime( "%H%M%S%N" ) &&
    time.strftime( "%H%M%S%N" ) <= range.last.strftime( "%H%M%S%N" )
end

s3 = Aws::S3::Resource.new(
  region: 'us-east-2',
  credentials: Aws::Credentials.new(
    ENV.fetch('ACCESS_KEY_ID'),
    ENV.fetch('SECRET_ACCESS_KEY')
  )
)

bucket = s3.bucket('timelapsephotos')
objects = bucket.objects

datetimes = objects.map { |obj| DateTime.parse(obj.key) }

within_ranges = datetimes.select do |datetime|
  DATE_RANGE.cover?(datetime) && is_within_time_range(datetime, TIME_RANGE)
end

filtered = within_ranges.inject([]) do |memo, datetime|
  if !memo.last || mins_between(memo.last, datetime) >= MAX_INTERVAL_MINS
    memo << datetime
  else
    memo
  end
end

puts "Selected #{filtered.count} out of #{objects.count}"

filtered.each_with_index do |datetime, index|
  filename = "#{datetime}.jpg"
  object = bucket.object datetime.to_s
  if object.download_file "./objects/#{filename}"
    puts "Downloaded #{filename} (#{index + 1} of #{filtered.count})"
  end
end
