# Compatibility between ActiveAdmin and will_paginate (see https://github.com/activeadmin/activeadmin/blob/master/docs/0-installation.md#will_paginate)
# Kaminari.configure do |config|
#   config.page_method_name = :per_page_kaminari
# end

# Changed to this for compatibility with delayed_jobs too (see https://gist.github.com/webmat/1887148#gistcomment-824373)
if defined?(WillPaginate)
  module WillPaginate
    module ActiveRecord
      module RelationMethods
        def per(value = nil) per_page(value) end
        def total_count() count end
      end
    end
    module CollectionMethods
      alias_method :num_pages, :total_pages
    end
  end
end