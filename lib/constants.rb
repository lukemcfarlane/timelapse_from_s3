require 'date'
require 'time'

FRAMERATE=25
PHOTOS_OUTPUT_DIR = File.join(File.dirname(__FILE__), '..', 'photos').freeze
FRAMES_TEMP_DIR = File.join(File.dirname(__FILE__), '..', 'frames_temp').freeze
OUTPUT_FILENAME = File.join(File.dirname(__FILE__), '..', 'output.mp4').freeze

SELECT_EVERY=3
EXPOSURE_RANGE = 25000..41000
