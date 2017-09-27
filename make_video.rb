require_relative 'constants'

if !Dir.exist? FRAMES_OUTPUT_DIR
  raise "#{FRAMES_OUTPUT_DIR} does not exist."
end

`ffmpeg -f image2 -framerate #{FRAMERATE} -pattern_type sequence \
-i #{FRAMES_OUTPUT_DIR}/%d.jpg -s 640x480 #{OUTPUT_FILENAME}`
