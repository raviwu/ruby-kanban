require_relative './board.rb'
require 'json'

class Kanban
  SAVE_FILE_PATH = 'kanban.json'

  attr_reader :board

  def initialize()
    @board = load()
  end

  def process(argv)
    action = argv.first
    case action
    when 'new'
      board.add(argv[1])
      show_all
    when 'move'
      board.move(argv[1].to_i, argv[3])
      show_all
    when *board.lists.map(&:name)
      show_list(action)
    else
      raise ArgumentError.new("Unknown command #{argv}, use `new DESCRIPTION`, `move ID to LIST`, `todo`, `wip`, `done`.")
    end
  end

  def show_all()
    board.lists.map(&:name).each { |list| show_list(list) }
  end

  def show_list(list_name)
    print_list(board.search_list(list_name))
  end

  def save()
    File.open(SAVE_FILE_PATH,"w") do |f|
      f.write(JSON.pretty_generate(board.to_hash))
    end
  end

  private

  def print_list(list)
    puts ">> #{list.name} - #{list.display_name}"
    puts "=" * 50
    list.items.each { |item| print_item(item) }
  end

  def print_item(item)
    # https://apidock.com/ruby/DateTime/strftime
    puts "#{item.id}\t#{item.description}\t\t#{item.moved_at.strftime('%F %H:%M')}"
  end

  def load()
    File.open(SAVE_FILE_PATH,"r") do |f|
      data = JSON.load(f)
      Board.from_hash(data)
    end
  rescue
    Board.new
  end
end
