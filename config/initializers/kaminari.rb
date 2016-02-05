# Compatibility between ActiveAdmin and will_paginate (see https://github.com/activeadmin/activeadmin/blob/master/docs/0-installation.md#will_paginate)
Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end