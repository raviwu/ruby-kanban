#!/usr/bin/env ruby

require_relative '../app/kanban'

KANBAN = Kanban.new

begin
  KANBAN.process(ARGV)
rescue => e
  puts e.message
ensure
  KANBAN.save()
end
