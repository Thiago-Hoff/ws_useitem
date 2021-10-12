RegisterServerEvent("ws_useitem:daritem")
AddEventHandler("ws_useitem:daritem", function(id, item, quantidade)
  print(id)
  print(item)
  print(quantidade)
  TriggerClientEvent("ws_useitem:daritem", id, source, item, quantidade)
  

end)


RegisterServerEvent("ws_useitem:devolveritem")
AddEventHandler("ws_useitem:devolveritem", function(id, item, quantidade)
  print("devolver")
  print(id)
  print(item)
  print(quantidade)
  TriggerClientEvent("ws_useitem:devolveritem", id, item, quantidade)
  

end)



