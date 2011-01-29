module Performance
  require "fileutils"
  #Comandos do asset
  def commands
    exec("rake asset:packager:create_yml")
    exec("rake asset:packager:build_all")
  end
  
  
  #Copiando as configuracoes de compreesao e cache de 1 mes para figuras em geral.
  def configs_apache
    File.open(".htaccess", "w") do |file|
      file.puts "<IfModule mod_deflate.c>\n\tAddOutputFilterByType DEFLATE text/html text/plain text/xml text/css application/x-javascript\n</IfModule>\n\n"
      file.puts "ExpiresActive On\n<FilesMatch '\\.(ico|jpg|jpeg|png|gif|js|css)'>\n\tExpiresDefault 'access plus 1 month'\n</FilesMatch>"
      file.close
    end
  end
  
  def join_jscss
    numero = 0
    p "Downloading Dependencies"
    #Olhar como baixar o plugin usando a gem dependencies
    system ("gem sources -a http://gems.github.com/")
    system ("script/plugin install git://github/sbecker/asset_packager.git")
    p "Join Images and CSS"
    commands
    p "Making procedures into app helper"
    
    dir_helper =  "#{Rails.root}/app/helpers"
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
            temp.puts "\t\t\t<title><%= title %><\/title>\n\t\t\t<%= csrf_meta_tag %>\n\t\t\t<%= stylesheet_link_merged :base %>\n\t\t\t<%= yield stylesheets %>\n"            
          else 
            temp.puts "#{line}"
          end    
          temp.puts "\n\t\t<%= javascript_link_merged :base %>\n\t\t<%= yield javascripts %>\n" if line =~ /<\/body>/
        end
        temp.close
      end
    else 
      puts "Arquivo app nao existe"
    end
    FileUtils.mv("application.html.erb", "old_application.html.erb")
    FileUtils.mv("app.html.erb", "application.html.erb")
  end
  
  def echo_memoize
    p "Finding by memoize"
  end
  
  def run
    join_jscss
    configs_apache
    echo_memoize    
  end
end
