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
    system ("script/plugin install git://github/sbecker/asset_packager.git")
    p "Join Images and CSS"
    commands
    p "Making procedures into app helper"
    dir_helper =  "#{Rails.root}/app/helpers"
    arr = IO.readlines("#{dir_helper}application_helper.rb") 
    lines = arr.size
    File.open("#{dir_helper}application_helper.rb","a+") do |write_helper|
      write_helper.lineno = lines - 1
      write_helper.puts "\n\ndef stylesheets(*files)\n\tcontent_for(:stylesheets)  { stylesheet_link_tag(*files) }\nend\n\ndef javascripts(*files)\n\tcontent_for(:javascripts)  { javascripts_link_tag(*files) }\nend"
      write_helper.close
    end
    
    dir_view_app =  "#{Rails.root}/app/views/layouts/"
    FileUtils.move("#{Rails.root}/files/_stylesheets.html.erb","#{dir_view_app}/_stylesheets.html.erb")    
    
    #Copia o conteudo do arquivo application.html.erb e cria a melhoria dos links de js e css agrupados
    temp = File.new("#{dir_view_app}copy_app","w")
    if File.exists?("#{dir_view_app}app.html.erb") then
      File.open("#{teste}app.html.erb", "r") do |file_reader|
        file_reader.readlines().each do |line|    
          p line
          if line =~ /<\/title>/ then
            temp.puts "\t\t\t<\/title><%= title %><\/title>\n\t\t\t<%= csrf_meta_tag %>\n\t\t\t<%= stylesheet_link_merged :base %>\n\t\t\t<%= javascript_link_merged :base %>\n"
          else
            temp.puts "#{line}"
          end    
        end
        temp.close
      end
    else 
      puts "Arquivo app nao existe"
    end
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
