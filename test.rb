require "sqlite3"
DB = SQLite3::Database.new("tasks.db")
DB.results_as_hash = true
require_relative "task"
# Note: Tasks have a title, a description and a done attribute

### TESTS

# READ (one)
task = Task.find(1)
puts "[#{ task.done? ? "X" : " "}] #{task.title}: #{task.description}"

task = Task.find(99999999)
puts "[#{ task.done? ? "X" : " "}] #{task.title}: #{task.description}" unless task.nil?

# CREATE
task = Task.new(title: "Shopping", description: "Buy stuff (mostly games)")
task.save
new_task = Task.find(2)
puts "[#{ new_task.done? ? "X" : " "}] #{new_task.title}: #{new_task.description}"

# UPDATE
task = Task.find(1)
task.done = true
task.save
puts "[#{ task.done? ? "X" : " "}] #{task.title}: #{task.description}"

# READ (all)

tasks = Task.all
tasks.each do |task|
  puts "[#{ task.done? ? "X" : " "}] #{task.title}: #{task.description}"
end

# DESTROY
task = Task.find(1)
task.destroy
p Task.find(1)