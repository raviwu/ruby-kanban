require 'time'

class Item
  attr_reader :id, :description
  attr_accessor :created_at, :moved_at

  def self.from_hash(hash)
    item = Item.new(hash.fetch('id', 0), hash.fetch('description', ''))
    item.created_at = Time.parse(hash.fetch('created_at')) || Time.now
    item.moved_at = Time.parse(hash.fetch('moved_at')) || Time.now
    item
  end

  def initialize(id, description)
    @id = id
    @description = description
    @created_at = Time.now
    @moved_at = Time.now
  end

  def to_hash
    {
      "created_at": created_at,
      "moved_at": moved_at,
      "id": id,
      "description": description
    }
  end
end