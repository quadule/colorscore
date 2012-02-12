# Colorscore

Colorscore is a simple library that uses ImageMagick to quantize an image and find its representative colors. It can also score those colors against a palette using the CIE2000 Delta E formula. This could be used to index images for a "search by color" feature.

## Requirements

* ImageMagick 6.5+

## Usage

```ruby
include Colorscore
histogram = Histogram.new('test/fixtures/skydiver.jpg')

# This image is 78.8% #7a9ab5:
histogram.scores.first # => [0.7884625, RGB [#7a9ab5]]

# This image is closest to pure blue:
palette = Palette.from_hex(['ff0000', '00ff00', '0000ff'])
scores = palette.scores(histogram.scores, 1)
scores.first # => [0.16493763694876, RGB [#0000ff]]
```