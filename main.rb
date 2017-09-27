require 'bundler/setup'
require 'aws-sdk'
require 'fileutils'
require 'pry'
require_relative 'constants'

def mins_between (datetime1, datetime2)
  ((datetime2.to_time - datetime1.to_time) / 60).floor
end

# this kinda sucks
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

if Dir.exist? FRAMES_OUTPUT_DIR
  FileUtils.rm_rf Dir.glob(File.join(FRAMES_OUTPUT_DIR, '*'))
else
  Dir.mkdir FRAMES_OUTPUT_DIR
end

filtered.each_with_index do |datetime, index|
  filename = "#{index + 1}.jpg"
  object = bucket.object datetime.to_s
  if object.download_file File.join(FRAMES_OUTPUT_DIR, filename)
    puts "Downloaded #{filename} (#{index + 1} of #{filtered.count})"
  end
end
