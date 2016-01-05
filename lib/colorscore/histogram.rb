module Colorscore
  class Histogram
    def initialize(image_path, colors=16, depth=8)
      output = `convert #{image_path.inspect} -resize 400x400 -format %c -dither None -quantize YIQ -colors #{colors.to_i} -depth #{depth.to_i} -alpha deactivate histogram:info:-`
      @lines = output.lines.map(&:strip).reject(&:empty?).
        sort_by { |l| l[/(\d+):/, 1].to_i }
    end

    # Returns an array of colors in descending order of occurances.
    def colors
      hex_values = @lines.map { |line| line[/#([0-9A-F]{6}) /, 1] }.compact
      hex_values.map { |hex| Color::RGB.from_html(hex) }
    end

    def color_counts
      @lines.map { |line| line.split(':')[0].to_i }
    end

    def scores
      total = color_counts.inject(:+).to_f
      scores = color_counts.map { |count| count / total }
      scores.zip(colors)
    end
  end
end
