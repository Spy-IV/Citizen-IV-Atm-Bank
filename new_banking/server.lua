
RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local _source = source
    TriggerClientEvent('deposit', _source, amount)
    print('amount ' .. amount .. '')
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    TriggerClientEvent('withdraw', source, amount)
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
    local _source = source
    balance = bankmoney
    TriggerClientEvent('currentbalance1', _source, balance)
end)
