require 'pry'
require 'rmagick'
require_relative 'constants'

class Photo
  include Magick

  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def <=> (other)
    self.filename <=> other.filename
  end

  def valid?
    EXPOSURE_RANGE.include? channel_mean
  end

  private

  def channel_mean
    image = Image.read(filename).first
    mean = image.channel_mean.first.round
    image.destroy!
    mean
  end
end
