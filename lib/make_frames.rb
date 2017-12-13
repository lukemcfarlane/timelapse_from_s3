require 'fileutils'
require 'pry'
require_relative 'constants'
require_relative 'photo'

if !Dir.exist? PHOTOS_OUTPUT_DIR
  raise "#{PHOTOS_OUTPUT_DIR} does not exist."
end

photo_filenames = Dir.glob(File.join(PHOTOS_OUTPUT_DIR, '*'))
photos = photo_filenames.map { |filename| Photo.new(filename) }
valid_photos = photos.select &:valid?

puts "Selected #{valid_photos.count} out of #{photos.count} photos"

if Dir.exist? FRAMES_TEMP_DIR
  FileUtils.rm_rf Dir.glob(File.join(FRAMES_TEMP_DIR, '*'))
else
  Dir.mkdir FRAMES_TEMP_DIR
end

valid_photos.sort.each_with_index do |photo, i|
  FileUtils.cp(photo.filename, File.join(FRAMES_TEMP_DIR, "#{i}.jpg"))
end
