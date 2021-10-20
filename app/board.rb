require_relative './item'
require_relative './list'

class Board
  attr_accessor :lists

  def self.from_hash(hash)
    board = Board.new()
    board.lists = hash.fetch('lists', []).map { |hash| List.from_hash(hash) }
    board
  end

  def initialize()
    @lists = [
      List.new('todo', 'Todo'), 
      List.new('wip', 'WIP'),
      List.new('done', 'Done')
    ]
  end

  def next_item_id()
    latest_id = lists.flat_map(&:items).map(&:id).max 
    latest_id ? (latest_id + 1) : 1
  end

  def add(description)
    item = Item.new(next_item_id, description)
    lists.first.add(item)
  end

  def move(item_id, list_name)
    target_item = search_item(item_id)
    raise ArgumentError.new("Item #{item_id} not found") unless target_item

    from_list = search_list_contains_item(target_item)
    to_list = search_list(list_name)

    raise ArgumentError.new("List #{list_name} not found") unless from_list && to_list

    raise ArgumentError.new("Cannot move backward from #{from_list.name} to #{to_list.name}") if lists.find_index(from_list) > lists.find_index(to_list)

    from_list.remove(target_item)
    to_list.add(target_item)
  end

  def search_list(list_name)
    lists.find { |list| list.name == list_name }
  end

  def to_hash()
    {
      "saved_at": Time.now,
      "lists": lists.map(&:to_hash)
    }
  end

  private

  def search_item(item_id)
    lists.flat_map(&:items).find { |item| item.id == item_id }
  end

  def search_list_contains_item(item)
    lists.find { |list| list.items.any?(item) }
  end
end