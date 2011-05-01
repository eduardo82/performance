class EntrySweeper < ActionController::Caching::Sweeper observe Entry
def expire_cached_content(entry) 
  expire_page :controller => 'entries', 
  :action => 'public' expire_fragment(%r{entries/.*}) 
  expire_fragment(:fragment => (entry.user.name + "_stats"))
end
alias_method :after_save, :expire_cached_content 
alias_method :after_destroy, :expire_cached_content
end