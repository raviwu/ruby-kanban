require "minitest/autorun"
require_relative "../app/board"
require_relative "../app/list"
require_relative "../app/item"

class TestBoard < Minitest::Test
  def setup
    @board = Board.new
  end

  def test_new_board_has_empty_default_lists
    assert_equal @board.lists.map(&:name), ['todo', 'wip', 'done']
    assert_equal @board.lists.map(&:items), [[],[],[]]
  end

  def test_next_item_id_when_empty
    assert_equal @board.next_item_id, 1
  end

  def test_add_item_default_to_first_list
    @board.add('Write test')
    assert_equal @board.lists.first.items.map(&:id), [1]
    assert_equal @board.lists.first.items.map(&:description), ['Write test']
    assert_equal @board.next_item_id, 2
  end

  def test_move_item_happy
    @board.add('item')
    @board.move(1, 'wip')
    assert_equal @board.lists.first.items, []
    assert_equal @board.lists[1].items.map(&:id), [1]
    assert_equal @board.lists[1].items.map(&:description), ['item']
  end

  def test_move_item_not_found
    assert_raises ArgumentError do 
      @board.move(1, 'wip')
    end
  end

  def test_move_list_not_found
    @board.add('item')
    assert_raises ArgumentError do 
      @board.move(1, 'nil')
    end
  end

  def test_move_list_backward
    @board.add('item')
    @board.move(1, 'wip')
    assert_raises ArgumentError do 
      @board.move(1, 'todo')
    end
  end

  def test_show_list
    assert_equal @board.search_list('wip')&.name, 'wip'
    assert_nil @board.search_list('non')&.name
  end
end