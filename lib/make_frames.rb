require 'fileutils'
require_relative 'constants'
require_relative 'photo'
require_relative 'logging'

if !Dir.exist? PHOTOS_OUTPUT_DIR
  raise "#{PHOTOS_OUTPUT_DIR} does not exist."
end

photo_filenames = Dir.glob(File.join(PHOTOS_OUTPUT_DIR, '*'))
photos = photo_filenames.map { |filename| Photo.new(filename) }.sort

valid_photos = photos.select.with_index do |photo, i|
  valid = photo.valid?

  percent_complete = ((i/photos.count.to_f) * 100).round
  show_status "Filtering photos outside exposure range: #{percent_complete}%"

  valid
end

puts "Removed #{photos.count - valid_photos.count} photos that were outside exposure range"

filtered_photos = valid_photos.select.with_index do |_, i|
  i % SELECT_EVERY == 0
end
filtered_photos = valid_photos

puts "Selected total of #{filtered_photos.count} photos"

if Dir.exist? FRAMES_TEMP_DIR
  FileUtils.rm_rf Dir.glob(File.join(FRAMES_TEMP_DIR, '*'))
else
  Dir.mkdir FRAMES_TEMP_DIR
end

filtered_photos.each_with_index do |photo, i|
  FileUtils.cp(photo.filename, File.join(FRAMES_TEMP_DIR, "#{i}.jpg"))
end
