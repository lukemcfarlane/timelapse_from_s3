require 'date'
require 'time'

FRAMERATE=25
FRAMES_OUTPUT_DIR = File.join(File.dirname(__FILE__), 'frames').freeze
OUTPUT_FILENAME = 'output.mp4'
DATE_RANGE = DateTime.new(2017, 9, 1)..DateTime.now
TIME_RANGE = Time.parse('07:00')..Time.parse('18:00')
MAX_INTERVAL_MINS = 60 * 6
