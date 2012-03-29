jQuery ->
  url = 'http://localhost:3000/users/1/info'
  $('#game_map').click ->
    $.ajax url,
      type: 'GET' 
      dataType: 'json' 
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(errorThrown)
      success: (data, textStatus, jqXHR) ->
        console.log(data)
    