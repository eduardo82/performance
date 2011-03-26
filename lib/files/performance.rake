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

desc 'Config Assets'
task :config_static_server => :production do
  Performance::config_static_server
end

desc 'Client Performance'
task :client_performance => :production do
  Performance::configs_apache
  Performance::join_css_js
end



