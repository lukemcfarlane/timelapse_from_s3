require 'fileutils'
require_relative 'constants'

FRAMES_TEMP_DIR = File.join(File.dirname(__FILE__), 'frames_temp').freeze

if !Dir.exist? PHOTOS_OUTPUT_DIR
  raise "#{PHOTOS_OUTPUT_DIR} does not exist."
end

photos = Dir.glob(File.join(PHOTOS_OUTPUT_DIR, '*'))

if Dir.exist? FRAMES_TEMP_DIR
  FileUtils.rm_rf Dir.glob(File.join(FRAMES_TEMP_DIR, '*'))
else
  Dir.mkdir FRAMES_TEMP_DIR
end

photos.sort.each_with_index do |f, i|
  FileUtils.cp(f, File.join(FRAMES_TEMP_DIR, "#{i}.jpg"))
end

puts `ffmpeg -f image2 -framerate #{FRAMERATE} -pattern_type sequence \
  -i #{FRAMES_TEMP_DIR}/%d.jpg -s 960x720 -pix_fmt yuv420p -y #{OUTPUT_FILENAME}`

FileUtils.rm_rf FRAMES_TEMP_DIR
