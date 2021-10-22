class Task
  attr_reader :title, :description, :id
  attr_accessor :done

  def initialize(attributes = {})
    @title = attributes[:title] || attributes["title"]
    @description = attributes[:description] || attributes["description"]
    @done = attributes[:done] || attributes["done"] || false
    @id = attributes[:id] || attributes["id"]
  end

  def done?
    @done
  end

  def self.find(id)
    query = <<-SQL
    SELECT * FROM tasks
    WHERE id = ?
    SQL
    attribute = DB.execute(query, id)[0]
    return nil if attribute.nil?
    
    # if attribute['done'] == 1
    #   attribute['done'] = true
    # else 
    #   attribute['done'] = false
    # end
    attribute['done'] = attribute['done'] == 1
    Task.new(attribute)
  end
  
  def save
    if @id
      DB.execute('UPDATE tasks SET title = ?, description = ?, done = ? WHERE id = ?', @title, @description, @done ? 1 : 0, @id)
    else
      DB.execute('INSERT INTO tasks (title, description, done)
      VALUES (?, ?, ?)', @title, @description, @done ? 1 : 0)
      @id = DB.last_insert_row_id
    end
  end

  def self.all
    tasks = DB.execute("SELECT * FROM tasks")
    tasks.map do |task_hash|
      task_hash['done'] = task_hash['done'] == 1
      Task.new(task_hash)
    end
  end

  def destroy
    DB.execute("DELETE FROM tasks WHERE id = ?", id)
  end
end
