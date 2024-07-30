# frozen_string_literal: true

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      item.sell_in -= 1 unless item.name == 'Sulfuras, Hand of Ragnaros'
      change_quality(item)
    end
  end

  private

  def change_quality(item)
    case item.name
    when 'Aged Brie'
      item.quality += 1
    when 'Backstage passes to a TAFKAL80ETC concert'
      if item.sell_in.negative? || item.sell_in.zero?
        item.quality = 0
        return
      end
      item.quality += case item.sell_in
                      when 1..5
                        3
                      when 6..10
                        2
                      else
                        1
                      end
    when 'Sulfuras, Hand of Ragnaros'
      item.quality = 80
      return
    when 'Conjured Mana Cake'
      item.quality -= item.sell_in.negative? ? 4 : 2
    else
      item.quality -= item.sell_in.negative? ? 2 : 1
    end
    item.quality = 50 if item.quality > 50
    item.quality = 0 if item.quality.negative?
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
