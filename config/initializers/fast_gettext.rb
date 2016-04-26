FastGettext.add_text_domain 'app', :path => 'locale', :type => :po, ignore_fuzzy: true
FastGettext.default_available_locales = ['en','it'] #all you want to allow
FastGettext.default_text_domain = 'app'