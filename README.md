# Ruby Kanban

```
bundle install
```

https://devdocs.io/minitest/

```
bundle exec rake test
```

## Usage

```shell
# create a item to todo list
$ ./bin/kanban.rb new “I want to drink water”
# move item with id 1 to wip list
$ ./bin/kanban.rb move 1 to wip
# move item with id 1 to done list
$ ./bin/kanban.rb move 1 to done
# display all items in todo list
$ ./bin/kanban.rb todo
# display all items in wip list
$ ./bin/kanban.rb wip
# display all items in done list
$ ./bin/kanban.rb done
```

## Requirement

A CLI version kanban.

- user can add a new task to kanban
- user can see todo list in chronological order that item moved to the Done
- user can move a todo item to WIP
- user can see WIP list in chronological order that item moved to the Done
- user can move a WIP item to Done
- user can see Done list in chronological order that item moved to the Done

### Constrains

- State is in order -> no backward movement
- TODO -> WIP -> Done (new state might add in the middle)

## Design

Board has_many Lists
- Rule of movement
- Order of list

List has_many Items
- Order of Item

Item
- Description
- Id

Kanban
- CLI interface
- Persist Kanban state
