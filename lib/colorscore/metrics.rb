module Colorscore
  module Metrics
    def self.similarity(a, b)
      1 - distance(a, b)
    end

    def self.distance(color_1, color_2)
      l1, a1, b1 = xyz_to_lab(*rgb_to_xyz(color_1))
      l2, a2, b2 = xyz_to_lab(*rgb_to_xyz(color_2))

      distance = delta_e_cie_2000(l1, a1, b1, l2, a2, b2)
      scale(distance, 0..100)
    end

    # Ported from colormath for Python.
    def self.delta_e_cie_2000(l1, a1, b1, l2, a2, b2)
      kl = kc = kh = 1

      avg_lp = (l1 + l2) / 2.0
      c1 = Math.sqrt((a1 ** 2) + (b1 ** 2))
      c2 = Math.sqrt((a2 ** 2) + (b2 ** 2))
      avg_c1_c2 = (c1 + c2) / 2.0

      g = 0.5 * (1 - Math.sqrt((avg_c1_c2 ** 7.0) / ((avg_c1_c2 ** 7.0) + (25.0 ** 7.0))))

      a1p = (1.0 + g) * a1
      a2p = (1.0 + g) * a2
      c1p = Math.sqrt((a1p ** 2) + (b1 ** 2))
      c2p = Math.sqrt((a2p ** 2) + (b2 ** 2))
      avg_c1p_c2p = (c1p + c2p) / 2.0

      h1p = ([b1, a1p] == [0.0, 0.0]) ? 0.0 : degrees(Math.atan2(b1,a1p))
      h1p += 360 if h1p < 0

      h2p = ([b2, a2p] == [0.0, 0.0]) ? 0.0 : degrees(Math.atan2(b2,a2p))
      h2p += 360 if h2p < 0

      if (h1p - h2p).abs > 180
        avg_hp = (h1p + h2p + 360) / 2.0
      else
        avg_hp = (h1p + h2p) / 2.0
      end

      t = 1 - 0.17 * Math.cos(radians(avg_hp - 30)) + 0.24 * Math.cos(radians(2 * avg_hp)) + 0.32 * Math.cos(radians(3 * avg_hp + 6)) - 0.2 * Math.cos(radians(4 * avg_hp - 63))

      diff_h2p_h1p = h2p - h1p
      if diff_h2p_h1p.abs <= 180
        delta_hp = diff_h2p_h1p
      elsif diff_h2p_h1p.abs > 180 && h2p <= h1p
        delta_hp = diff_h2p_h1p + 360
      else
        delta_hp = diff_h2p_h1p - 360
      end

      delta_lp = l2 - l1
      delta_cp = c2p - c1p
      delta_hp = 2 * Math.sqrt(c2p * c1p) * Math.sin(radians(delta_hp) / 2.0)

      s_l = 1 + ((0.015 * ((avg_lp - 50) ** 2)) / Math.sqrt(20 + ((avg_lp - 50) ** 2.0)))
      s_c = 1 + 0.045 * avg_c1p_c2p
      s_h = 1 + 0.015 * avg_c1p_c2p * t

      delta_ro = 30 * Math.exp(-((((avg_hp - 275) / 25) ** 2.0)))
      r_c = Math.sqrt(((avg_c1p_c2p ** 7.0)) / ((avg_c1p_c2p ** 7.0) + (25.0 ** 7.0)));
      r_t = -2 * r_c * Math.sin(2 * radians(delta_ro))

      delta_e = Math.sqrt(((delta_lp / (s_l * kl)) ** 2) + ((delta_cp / (s_c * kc)) ** 2) + ((delta_hp / (s_h * kh)) ** 2) + r_t * (delta_cp / (s_c * kc)) * (delta_hp / (s_h * kh)))
    end

    def self.rgb_to_xyz(color)
      color = color.to_rgb
      r, g, b = color.r, color.g, color.b

      # assuming sRGB (D65)
      r = (r <= 0.04045) ? r/12.92 : ((r+0.055)/1.055) ** 2.4
      g = (g <= 0.04045) ? g/12.92 : ((g+0.055)/1.055) ** 2.4
      b = (b <= 0.04045) ? b/12.92 : ((b+0.055)/1.055) ** 2.4

      r *= 100
      g *= 100
      b *= 100

      x = 0.412453*r + 0.357580*g + 0.180423*b
      y = 0.212671*r + 0.715160*g + 0.072169*b
      z = 0.019334*r + 0.119193*g + 0.950227*b

      [x, y, z]
    end

    def self.xyz_to_lab(x, y, z)
      x /= 95.047
      y /= 100.000
      z /= 108.883

      if x > 0.008856
        x = x ** (1.0/3)
      else
        x = (7.787 * x) + (16.0 / 116)
      end

      if y > 0.008856
        y = y ** (1.0/3)
      else
        y = (7.787 * y) + (16.0 / 116)
      end

      if z > 0.008856
        z = z ** (1.0/3)
      else
        z = (7.787 * z) + (16.0 / 116)
      end

      l = (116.0 * y) - 16.0
      a = 500.0 * (x - y)
      b = 200.0 * (y - z)

      [l, a, b]
    end

    def self.scale(number, from_range, to_range=0..1, clamp=true)
      if clamp && number <= from_range.begin
        position = 0
      elsif clamp && number >= from_range.end
        position = 1
      else
        position = (number - from_range.begin).to_f / (from_range.end - from_range.begin)
      end

      position * (to_range.end - to_range.begin) + to_range.begin
    end

    def self.radians(degrees); degrees * Math::PI / 180; end
    def self.degrees(radians); radians * 180 / Math::PI; end
  end
end