<!-- This template renders a drop down after a fleet is selected -->
<g:select name="fleetId" from="${availableFleets}" optionKey="id" optionValue="${{it.name+' ('+it.cars?.size()+' Cars)'}}"
          noSelection="['':'Select Fleet']"
          onchange="${remoteFunction (controller: 'configuration',
                  action: 'addExistentFleetToConfiguration',
                  params: '\'fleetId=\'+this.value+\'&configurationStubId=\'+\'' + configurationStubId + '\'' ,
                  update: 'fleetSelection'
          )}"/>