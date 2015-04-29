menuItemTpl = _.template """
<li><a href="#heading-<%= id %>"><%= title %></a></li>
"""

$.fn.extend
  makeTocFor: (id) ->
    headings = $("#{id} h2")
    $.each headings, (idx, h) =>
      $(h).attr('id',"heading-#{idx}")
      $(@).find('.panel-body ul').append menuItemTpl
        id: idx
        title: $(h).text()