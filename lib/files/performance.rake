desc 'Make a Cache Server-Side'
task :cache_page_server => :production do
    controller = ENV["controller"]  
    action = ENV["action"]
    Perfomance::cache_page_server(controller,action)
end

desc 'Join .css and .js files'
task :join_css_js => :production do
  Performance::join_css_js
  
end

desc 'Make a cache and gzip function in Apache Servers'
task :configs_apache => :production do
  Performance::configs_apache
  
end

desc 'Config Static Server'
task :config_static_server => :production do
  server = ENV["server"]
  Performance::config_static_server(server)
end

desc 'Client Performance'
task :client_performance => :production do
  Performance::configs_apache
  Performance::join_css_js
end

desc 'Improve Memory Performance'
task :memory => :development do
  size = ENV["size"]
  Performance::memory(size)
end

desc 'Improve Memory Performance'
task :multi_memory => :development do
  s1 = ENV["s1"]
  s2 = ENV["s2"]
  Performance::multi_memory(s1,s2)
end


