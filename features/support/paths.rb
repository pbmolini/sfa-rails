module NavigationHelpers

  def path_to(page_name)

    case page_name
    when /the list of boats/
      boats_path
    else
      raise "Can't find a mapping to #{page_name}!"
    end

  end

end

World(NavigationHelpers)