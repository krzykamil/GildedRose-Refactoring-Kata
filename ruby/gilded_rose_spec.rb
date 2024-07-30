# frozen_string_literal: true

require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  it 'does not change the name' do
    items = [Item.new('foo', 0, 0)]
    GildedRose.new(items).update_quality
    expect(items[0].name).to eq 'foo'
  end

  describe 'Item' do
    it 'should have a name, sell_in, and quality' do
      item = Item.new('foo', 0, 0)
      expect(item.name).to eq 'foo'
      expect(item.sell_in).to eq 0
      expect(item.quality).to eq 0
    end

    it '#to_s' do
      item = Item.new('foo', 0, 0)
      expect(item.to_s).to eq 'foo, 0, 0'
    end

  end

  context 'with quality' do
    it 'degrades twice as fast if sell_in has passed (negative value)' do
      items = [Item.new('foo', -1, 10)]

      GildedRose.new(items).update_quality

      expect(items[0].quality).to eq 8
    end

    it 'cannot be negative' do
      items = [Item.new('foo', 0, 0)]

      GildedRose.new(items).update_quality

      expect(items[0].quality).to eq 0
    end

    it 'gets higher with passage of time for Aged Brie' do
      items = [Item.new('Aged Brie', 0, 0)]

      GildedRose.new(items).update_quality

      expect(items[0].quality).to eq 2
    end

    it 'cannot be higher than 50' do
      items = [Item.new('Aged Brie', 0, 50)]

      GildedRose.new(items).update_quality

      expect(items[0].quality).to eq 50
    end

    it 'is always 80 for Sulfuras' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', 0, 80)]

      GildedRose.new(items).update_quality

      expect(items[0].quality).to eq 80
    end

    it 'decreases by 1 for all other items' do
      items = [Item.new('foo', 0, 1)]

      GildedRose.new(items).update_quality

      expect(items[0].quality).to eq 0
    end

    context 'with Backstage passes' do
      it 'increases by 2 when sell_in is 10 or less' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 10)]

        GildedRose.new(items).update_quality

        expect(items[0].quality).to eq 12
      end

      it 'increases by 3 when sell_in is 5 or less' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 10)]

        GildedRose.new(items).update_quality

        expect(items[0].quality).to eq 13
      end

      it 'drops to 0 after the concert' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 10)]

        GildedRose.new(items).update_quality

        expect(items[0].quality).to eq 0
      end
    end

    context 'with conjured items' do
      it 'degrades twice as fast as normal items' do
        items = [Item.new('Conjured Mana Cake', 1, 10)]

        GildedRose.new(items).update_quality

        expect(items[0].quality).to eq 8
      end
    end
  end

  context 'with sell_in' do
    it 'never decreases for Sulfuras' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', 0, 80)]

      GildedRose.new(items).update_quality

      expect(items[0].sell_in).to eq 0
    end

    it 'decreases by 1 for all other items' do
      items = [Item.new('foo', 1, 1)]

      GildedRose.new(items).update_quality

      expect(items[0].sell_in).to eq 0
    end
  end
end
