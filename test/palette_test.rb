require File.expand_path("../test_helper", __FILE__)

class PaletteTest < Test::Unit::TestCase
  def setup
    @histogram = Histogram.new("test/fixtures/skydiver.jpg")
    @palette = Palette.default
  end
  
  def test_skydiver_photo_is_mostly_blue
    score, color = @palette.scores(@histogram.scores).first
    assert_equal Color::RGB.from_html('0099cc'), color
  end
end
