module Colorscore
  class Palette < Array
    DEFAULT = ["660000", "990000", "cc0000", "cc3333", "ea4c88", "993399",
               "663399", "333399", "0066cc", "0099cc", "66cccc", "77cc33",
               "669900", "336600", "666600", "999900", "cccc33", "ffff00",
               "ffcc33", "ff9900", "ff6600", "cc6633", "996633", "663300",
               "000000", "999999", "cccccc", "ffffff"]

    def self.default
      from_hex DEFAULT
    end

    def self.from_hex(hex_values)
      new hex_values.map { |hex| Color::RGB.from_html(hex) }
    end

    def scores(histogram_scores, distance_threshold=0.275)
      scores = map do |palette_color|
        score = 0

        histogram_scores.each_with_index do |item, index|
          color_score, color = *item

          color = color.to_hsl.tap { |c| c.s = 0.05 + c.s * (4 - c.l * 2.5) }.to_rgb

          if (distance = Metrics.distance(palette_color, color)) < distance_threshold
            distance_penalty = (1 - distance) ** 4
            score += color_score * distance_penalty
          end
        end

        [score, palette_color]
      end

      scores.reject { |score, color| score <= 0.05 }.
             sort_by { |score, color| score }.
             reverse
    end
  end
end
