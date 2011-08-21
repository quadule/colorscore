require File.expand_path("../test_helper", __FILE__)

class HistogramTest < Test::Unit::TestCase
  def setup
    @colors = 7
    @histogram = Histogram.new("test/fixtures/skydiver.jpg", @colors)
  end
  
  def test_color_count_is_correct
    assert_equal @colors, @histogram.colors.size
  end
end
