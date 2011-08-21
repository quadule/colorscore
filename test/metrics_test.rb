require File.expand_path("../test_helper", __FILE__)

class MetricsTest < Test::Unit::TestCase
  def test_no_distance_between_identical_colors
    color = Color::RGB.new(123, 45, 67)
    assert_equal 0, Metrics.distance(color, color)
  end
  
  def test_maximum_similarity_between_identical_colors
    color = Color::RGB.new(123, 45, 67)
    assert_equal 1, Metrics.similarity(color, color)
  end
end
