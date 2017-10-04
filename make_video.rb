require_relative 'constants'

if !Dir.exist? FRAMES_OUTPUT_DIR
  raise "#{FRAMES_OUTPUT_DIR} does not exist."
end

`ffmpeg -f image2 -framerate #{FRAMERATE} -pattern_type sequence \
-i #{FRAMES_OUTPUT_DIR}/%d.jpg -s 960x720 -pix_fmt yuv420p #{OUTPUT_FILENAME}`
