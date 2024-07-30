# frozen_string_literal: true

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      update_item(item, item.sell_in, item.name)
    end
  end

  private

  def update_item(item, *pattern)
    case pattern
    in [_, 'Sulfuras, Hand of Ragnaros']
      set_quality(item, 80)
    in [_, 'Aged Brie']
      age_item(item)
      increase_quality(item, 1)
    in [6..10, 'Backstage passes to a TAFKAL80ETC concert']
      age_item(item)
      increase_quality(item, 2)
    in [1..5, 'Backstage passes to a TAFKAL80ETC concert']
      age_item(item)
      increase_quality(item, 3)
    in [Integer => sell_in, 'Backstage passes to a TAFKAL80ETC concert']
      age_item(item)
      sell_in.negative? || sell_in.zero? ? set_quality(item, 0) : increase_quality(item, 1)
    in [_, 'Conjured Mana Cake']
      age_item(item)
      item.sell_in.negative? ? degrade_quality(item, 4) : degrade_quality(item, 2)
    in [Integer, String]
      age_item(item)
      item.sell_in.negative? ? degrade_quality(item, 2) : degrade_quality(item, 1)
    end
  end

  def degrade_quality(item, level)
    item.quality = [item.quality - level, 0].max
  end

  def increase_quality(item, level)
    item.quality = [item.quality + level, 50].min
  end

  def set_quality(item, quality)
    item.quality = quality
  end

  def age_item(item)
    item.sell_in -= 1
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
