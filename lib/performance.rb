module Performance
  
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
    dir_helper =  File.dirname(__FILE__) + '/app/helpers/'
    arr = IO.readlines("#{dir_helper}application_helper.rb") 
    lines = arr.size
    File.open("#{dir_helper}application_helper.rb","a+") do |write_helper|
      write_helper.lineno = lines - 1
      write_helper.puts "\n\ndef stylesheets(*files)\n\tcontent_for(:stylesheets)  { stylesheet_link_tag(*files) }\nend"
      write_helper.puts "def javascripts(*files)\n\tcontent_for(:javascripts)  { javascripts_link_tag(*files) }\nend"
      write_helper.close
    end
    
    dir_view =  File.dirname(__FILE__) + '/app/views/layouts/'
    IO.foreach("#{teste}application.html.erb") do |line|
      puts "<%= csrf_meta_tag %>\n\t<%= stylesheet_link_merged :base %>\n\t<%= javascript_link_merged :base %>\n" if line =~ /TESTE/ 
    end
    
end
  
  def echo_memoize
    File.open
    File.open() do |file|
      file.puts "<%= stylesheet_link_merged :base %>"
      file.puts "<%= javascript_link_merged :base %>"
    end
  end
  
  def execall
    join_jscss
        
  end
end
