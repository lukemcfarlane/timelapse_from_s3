require 'date'
require 'time'

FRAMERATE=25
PHOTOS_BUCKET_NAME = 'timelapsephotos'
PHOTOS_OUTPUT_DIR = File.join(File.dirname(__FILE__), 'photos').freeze
OUTPUT_FILENAME = 'output.mp4'
