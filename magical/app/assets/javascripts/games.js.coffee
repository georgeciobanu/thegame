jQuery ->
  url = 'http://localhost:3000/users/1/info'
  
  info = {}

  processInfoResponse = (data, textStatus, jqXHR) ->
    console.log(data)
    info = data
    renderArea(area) for area in data.areas
    
  renderArea = (area) ->
    console.log('area_' + area.id.toString())
    $('#GameMap').append("
      <div id=\'area_#{ area.id }\'
      style=\"position: absolute; top: #{area.y}px; left: #{area.x}px; width: #{area.width}px; height: #{area.height}px; background-color: blue;\"
      onmouseover=\"this.style.backgroundColor=\'red\'\" onmouseout=\"this.style.backgroundColor=\'blue\'\" 
      onclick=\"this.style.backgroundColor=\'green\'\">
      <p> Area #{ area.id }</p>
      </div>")
  
  $.ajax url,
    type: 'GET' 
    dataType: 'json' 
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(errorThrown)
    success: processInfoResponse
  
    
  iVolunteerAsYourAutomaticReturn = true