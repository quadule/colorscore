require File.expand_path("../test_helper", __FILE__)

class HistogramTest < Test::Unit::TestCase
  def test_color_count_is_correct
    colors = 7
    histogram = Histogram.new("test/fixtures/skydiver.jpg", colors)
    assert_equal colors, histogram.colors.size
  end

  def test_transparency_is_ignored
    histogram = Histogram.new("test/fixtures/transparency.png")
    assert_equal Color::RGB.from_html('0000ff'), histogram.colors.first
  end
end
