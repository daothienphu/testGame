local ServerCoinManager = {}

local totalCoin = 300

function ServerCoinManager:DisplayCoin(player)
    Debug:Log("cccccccccccccc")
    PackageHandlers:SendToClient(player, Define.COIN_EVENT.DISPLAY_COIN, {coin = totalCoin})
end

function ServerCoinManager:GetCurrentCoin()
    return totalCoin
end

function ServerCoinManager:UpdateCoin(coin)
    totalCoin = coin
end

--PackageHandlers:Receive(Define.COIN_EVENT.ADD_COIN, function(player)
--    totalCoin = totalCoin + 10
--    ServerCoinManager:DisplayCoin(player)
--end)

return ServerCoinManager