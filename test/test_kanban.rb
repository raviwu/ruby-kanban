require "minitest/autorun"
require_relative "../app/board"
require_relative "../app/kanban"

class TestKanban < Minitest::Test
  def setup
    @kanban = Kanban.new
  end

  def remove_saved_file
    File.delete(Kanban::SAVE_FILE_PATH) if File.exist?(Kanban::SAVE_FILE_PATH)
  end

  def test_initialize_without_file_has_empty_default_lists
    assert_equal @kanban.board.lists.map(&:name), Board.new.lists.map(&:name)
    assert_equal @kanban.board.lists.map(&:items), Board.new.lists.map(&:items)
  end

  def test_new_add_item
    @kanban.process(['new', '1st todo'])
    @kanban.process(['new', '2nd todo'])
    assert_equal @kanban.board.lists.map { |list| list.items.size }, [2, 0, 0]
    assert_equal @kanban.board.lists.first.items.first.description, '2nd todo'
    assert_equal @kanban.board.lists.first.items.last.description, '1st todo'
  end

  def test_move_item
    @kanban.process(['new', '1st todo'])
    @kanban.process(['new', '2nd todo'])
    assert_equal @kanban.board.lists.map { |list| list.items.size }, [2, 0, 0]

    @kanban.process(['move', '2', 'to', 'wip'])
    assert_equal @kanban.board.lists.map { |list| list.items.size }, [1, 1, 0]
    
    @kanban.process(['move', '2', 'to', 'done'])
    assert_equal @kanban.board.lists.map { |list| list.items.size }, [1, 0, 1]
  end

  def test_show_list
    Board.new.lists.map(&:name).each do |list_name|
      @kanban.process([list_name])
    end
  end

  def test_save_persists_board
    @kanban.save
    assert File.exist?(Kanban::SAVE_FILE_PATH) 
    remove_saved_file
  end

  def test_initialize_with_file_imports_saved_lists
    assert_equal @kanban.board.lists.map { |list| list.items.size }, [0, 0, 0]
    @kanban.process(['new', 'new todo'])
    assert_equal @kanban.board.lists.map { |list| list.items.size }, [1, 0, 0]
    @kanban.save

    loaded_kanban = Kanban.new
    assert_equal loaded_kanban.board.lists.map { |list| list.items.size }, [1, 0, 0]
    assert_equal loaded_kanban.board.lists.first.items.first.description, 'new todo'
    remove_saved_file
  end
end