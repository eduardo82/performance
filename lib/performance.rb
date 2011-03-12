module Performance
  require "fileutils"
  require "jammit"
  
  #Copiando as configuracoes de compreesao de imagens em geral e cache de 1 mes para outros formatos.
  def configs_apache
    if File.exists?("#{Rails.root}/public/.htaccess")  then
      File.open("#{Rails.root}/public/.htaccess", "a") do |file|
        file.puts "<IfModule mod_deflate.c>\n\tAddOutputFilterByType DEFLATE text/html text/plain text/xml text/css application/x-javascript\n</IfModule>\n\n"
        file.puts "ExpiresActive On\n<FilesMatch '\\.(ico|jpg|jpeg|png|gif|js|css)'>\n\tExpiresDefault 'access plus 1 month'\n</FilesMatch>"
        file.puts "<Directory '#{Rails.root}/public/assets'>\n\tExpiresDefault 'access plus 1 month'\n</Directory>"
      end
    else
      File.open("#{Rails.root}/public/.htaccess", "w") do |file|
        file.puts "<IfModule mod_deflate.c>\n\tAddOutputFilterByType DEFLATE text/html text/plain text/xml text/css application/x-javascript\n</IfModule>\n\n"
        file.puts "ExpiresActive On\n<FilesMatch '\\.(ico|jpg|jpeg|png|gif|js|css)'>\n\tExpiresDefault 'access plus 1 month'\n</FilesMatch>"
        file.puts "<Directory '#{Rails.root}/public/assets'>\n\tExpiresDefault 'access plus 1 month'\n</Directory>"
      end
    end
  end
  
  def join_jscss    
    make_datas
    system("jammit")
    p "Making procedures into app helper"    
    dir_helper =  "#{Rails.root}/app/helpers/"
    File.open("#{dir_helper}application_helper.rb","r") do |read_helper|
      read_reader.readlines().each do |line|    
        if line =~ /ApplicationHelper/ then
          read_helper.puts "module ApplicationHelper\n\n\tdef stylesheets(*files)\n\tcontent_for(:stylesheets)  { stylesheet_link_tag(*files) }\nend\n\ndef javascripts(*files)\n\tcontent_for(:javascripts)  { javascripts_link_tag(*files) }\nend"
        else
          read_helper.puts "#{line}"
        end
      end
    end
    
    dir_view_app =  "#{Rails.root}/app/views/layouts/"
    Dir.chdir("#{dir_view_app}")
    #Copia o conteudo do arquivo application.html.erb e cria a melhoria dos links de js e css agrupados
    temp = File.new("app.html.erb","w")
    if File.exists?("application.html.erb") then
      File.open("application.html.erb", "r") do |file_reader|
        file_reader.readlines().each do |line|    
          if line =~ /<\/title>/
            temp.puts "\t\t\t<title><%= title %><\/title>\n\t\t\t<%= csrf_meta_tag %>\n\t\t\t<%= include_stylesheets :workspace, :media => 'all' %>\n\t\t\t<%= yield stylesheets %>\n"            
          else 
            temp.puts "#{line}"
          end    
          temp.puts "\n\t\t<%= include_javascripts :workspace %>\n\t\t<%= yield javascripts %>\n" if line =~ /<\/body>/
        end
        temp.close
      end
    else 
      puts "Arquivo application.html.erb Inexistente"
    end
    p "Renaming your application.html.erb to old_application.html.erb"
    FileUtils.mv("application.html.erb", "old_application.html.erb")
    FileUtils.mv("app.html.erb", "application.html.erb")
  end
  
  def make_datas
    Dir.mkdir("#{Rails.root}/public/config") if !Dir.exists?
    Dir.chdir("#{Rails.root}/public/config")
    File.new("assets.yml", "w") do |file|
      file.puts("embed_assets: on\njavascripts:\n\tworkspace:\n\t\t - public/javascripts/*.js")
      file.puts("\nstylesheets:\n\tworkspace:\n\t\t - public/stylesheets/*.css")
    end  
  end
  
  def query_performance
    p "Finding by N+1 queries"
    dir_models = "#{Rails.root}/app/models"
    list = Dir.entries("#{dir_models}")
        list.each do |file|
          strings = file.to_s
          if strings =="." || strings ==".."
          else
            IO.foreach("#{file}") do |line|
              if line =~ /has_one:/ then
                p "Possible N+1 query found in #{file}"
                p "Analyzing"
              end
            end
          end
        end    
  end
  
  def cache_server
    #controller - ARG[0]
    #action - ARG[1]
    
    echo "\n\tcaches_page :public \n\tcache_sweeper :entry_sweeper, :only => [:create, :update, :destroy]"
    File.new("../files/ControllerSweeper.rb", "r") do |observer|
      FileUtils.cp(observer, "#{Rails.root}/app/models/ControllerSweeper.rb", :verbose => true)
    end    
  end
  
  def config_static_server
  end
  
  def run
    join_jscss
    configs_apache
    query_performance    
    cache_server
    config_static_server
  end
end
