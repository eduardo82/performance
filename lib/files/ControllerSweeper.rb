class Sweeper < ActionController::Caching::Sweeper 
  observe {controller.capitalize}
def expire_cached_content(entry) 
  expire_page :controller => '#{controller.pluralize}', :action => '#{action.downcase}' 
  expire_fragment(%r{#{controller.pluralize}/.*}) 
  expire_fragment(:fragment => (entry.user.name + "_stats"))
end
alias_method :after_save, :expire_cached_content 
alias_method :after_destroy, :expire_cached_content
end