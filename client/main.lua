
cosumiveis = {
    {
        item = "pao",
        duracao = 50,
        step = 25, 
        dict = 'mp_player_inteat@burger',
        anim = 'mp_player_int_eat_burger',
        time_anim = 900,
        prop = 'prop_cs_burger_01',
        prop_config = {18905, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
    },
}

print('teste de edição')

usando = nil 
duracao = 0 
item_hand = nil
qtd_item = 0
step = 0
dict = nil
anim = nil
time_anim = 0
prop = nil
prop_config =  nil 
prop_hand = nil



RegisterCommand("usar", function(source, args, raw)

     

    if usando == true then
        return
    else
        usando = true
        local  item = args[1]
        print(item)
        for k,v in ipairs(cosumiveis) do
            if item == v.item then
                item_hand = v.item
                qtd_item = v.duracao
                step = v.step
                anim = v.anim
                dict = v.dict
                time_anim = v.time_anim
                prop = v.prop
                prop_config = v.prop_config
                duracao = v.duracao
            end
        end
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
        prop_hand = CreateObject(GetHashKey(prop), x, y, z+0.2,  true,  true, true)
        AttachEntityToEntity(prop_hand, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), prop_config[1]), prop_config[2], prop_config[3], prop_config[4], prop_config[5], prop_config[6], prop_config[7], true, true, false, true, 1, true)
    
        SendNUIMessage({
            type = 'consume',
            width = '100'
            
        })
    end 
    

end,false)
RegisterCommand("anim", function(source, args, raw)
    local dict, anim = 'mp_player_inteat@burger', 'mp_player_int_eat_burger'
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    TaskPlayAnim(GetPlayerPed(-1), dict, anim, 1.0, 1.0, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(900)
    ClearPedTasks(GetPlayerPed(-1))
end,false)

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local tempo = 500
        if item_hand ~= nil  then
            tempo = 1 

                -- Usar item  com H
            if IsControlPressed(0, 74) then
                
                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do 
                    Citizen.Wait(100)
                end
                TaskPlayAnim(GetPlayerPed(-1), dict, anim, 1.0, 1.0, -1, 49, 0, 0, 0, 0)
                Citizen.Wait(time_anim)
                ClearPedTasks(GetPlayerPed(-1))
                if qtd_item - step >= 0 then
                    qtd_item =  qtd_item - step
                    if qtd_item - step < 0 then
                        qtd_item =  0 
                    end     
                end
                if qtd_item == 0 then
                    DeleteObject(prop_hand)
                    
                    SendNUIMessage({
                        type = 'off',
                    })
                end
                print(qtd_item) 
                --Mandando coisa para o JS
                SendNUIMessage({
                    type = 'consume',
                    width = (qtd_item * 100)/ duracao
                })
            end
            
            
                -- Jogar item no chão  E
            if IsControlJustPressed(0, 38) then
                if qtd_item >= 0 then
                    DeleteObject(prop_hand)
                    local dict, anim ='random@domestic', 'pickup_low'
                    RequestAnimDict(dict)
                    while not HasAnimDictLoaded(dict) do 
                        Citizen.Wait(100)
                    end
                    TaskPlayAnim(GetPlayerPed(-1), dict, anim, 2.0, 2.0, -1, 120, 0, 0, 0, 0)

                    item_hand = nil
                    usando =nil
                end
                print(item_hand)

                SendNUIMessage({
                    type = 'off',
                    
                })
            end


                -- Jogar passar item G
            if IsControlJustPressed(0, 47) then
                print("G")
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 2 then
                    print(closestPlayer)
                    print(GetPlayerServerId(closestPlayer))
                    TriggerServerEvent("ws_useitem:daritem", GetPlayerServerId(closestPlayer), item_hand, qtd_item)
                    item_hand = nil
                    qtd_item = 500
                    
                    print(closestPlayer)
                end
            end
        end
        
        Citizen.Wait(tempo)
    end
end)

RegisterNetEvent("ws_useitem:daritem")
AddEventHandler("ws_useitem:daritem", function(id, item, quantidade)
    
    if item_hand == nil then
        item_hand = item
        qtd_item = quantidade
        for k,v in ipairs(consumiveis) do 
            step = v.step
            anim = v.anim
            dict = v.dict
            time_anim = v.time_anim
            prop = v.prop
            prop_config = v.prop_config
            duracao = v.duracao
        end
        print(item)
        print(quantidade)
    else 
        TriggerServerEvent("ws_useitem:devolveritem", id, item, quantidade)
    end
    
    
end)

RegisterNetEvent("ws_useitem:devolveritem")
AddEventHandler("ws_useitem:devolveritem", function(item, quantidade)
    item_hand = item
    qtd_item = quantidade
    for k,v in ipairs(consumiveis) do 
        step = v.step
        anim = v.anim
        dict = v.dict
        time_anim = v.time_anim
        prop = v.prop
        prop_config = v.prop_config
        duracao = v.duracao
    end
end)




