require 'camper'

client = Camper.configure do |config|
  config.client_id = ENV['BASECAMP3_CLIENT_ID']
  config.client_secret = ENV['BASECAMP3_CLIENT_SECRET']
  config.account_number = ENV['BASECAMP3_ACCOUNT_NUMBER']
  config.refresh_token = ENV['BASECAMP3_REFRESH_TOKEN']
  config.access_token = ENV['BASECAMP3_ACCESS_TOKEN']
end

projects = client.projects

projects.auto_paginate do |p|
  puts "Project: #{p.name}"

  todoset = client.todoset(p)

  puts "Ratio of completed Todos in Todoset: #{todoset.completed_ratio}"

  client.todolists(todoset).auto_paginate(5) do |list|
    puts "Todolist: #{list.title}"

    client.todos(list).auto_paginate(1) do |todo|
      puts "Todo: #{todo.title}"
      puts "Get Todo using project id: #{client.todo(p.id, todo.id).title}"
      puts "Get Todo using project resource: #{client.todo(p, todo.id).title}"
      puts "Get Todo using todolist resource: #{client.todo(list, todo.id).title}"
    end
  end
end