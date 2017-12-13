require 'fileutils'
require_relative 'constants'

if !Dir.exist? FRAMES_TEMP_DIR
  raise "#{FRAMES_TEMP_DIR} does not exist."
end

puts `ffmpeg -f image2 -framerate #{FRAMERATE} -pattern_type sequence \
  -i #{FRAMES_TEMP_DIR}/%d.jpg -s 960x720 -pix_fmt yuv420p -y #{OUTPUT_FILENAME}`

FileUtils.rm_rf FRAMES_TEMP_DIR
