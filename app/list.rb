require_relative './item'

class List
  attr_reader :name, :display_name
  attr_accessor :items

  def self.from_hash(hash)
    list = List.new(hash.fetch('name', ''), hash.fetch('display_name', ''))
    list.items = hash.fetch('items', []).map { |hash| Item.from_hash(hash) }
    list
  end

  def initialize(name, display_name)
    @name = name
    @display_name = display_name
    @items = []
  end

  def add(item)
    @items << item
    item.moved_at = Time.now
    order_items
  end

  def remove(item)
    @items.delete(item)
    order_items
  end

  def to_hash()
    {
      "name": name,
      "display_name": display_name,
      "items": items.map(&:to_hash)
    }
  end

  private

  def order_items()
    @items.sort_by!(&:moved_at).reverse!
  end
end