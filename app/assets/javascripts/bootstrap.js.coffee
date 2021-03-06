jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
  $('.carousel').carousel({
          interval: 5000
  });

$ ->
  $('#article_search').typeahead
    name: "article"
    remote: '/home/autocomplete?query=%QUERY'
    limit: 10
    valueKey: [0]
    template: (datum) ->
      '<p><a href="'+datum[1]+'">'+datum[0]+'</a></p>'


$ ->
  $('a.load-more-articles').on 'inview', (e, visible) ->
    return unless visible

    $.getScript $(this).attr('href')

$ ->
  $('a.load-more-tags').on 'inview', (e, visible) ->
    return unless visible

    $.getScript $(this).attr('href')




