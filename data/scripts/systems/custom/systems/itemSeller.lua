local conf = {
    exhaust = 5,
    maxValuePerSell = 50,
    onlyLootPouch = true,
    lootPouchId = 23721,
    percentPrice = 0.9, -- if u want to change to lose price, use 0.9 to earn 90% of origin price, 0.55 to 55% etc...
}

local itemSeller = Action()

function itemSeller.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local inbox = player:getStoreInbox():getItems()
    local lootPouch = nil
    for _, lookPouch in pairs(inbox) do
        if lookPouch:getId() == conf.lootPouchId then
            lootPouch = Container(lookPouch:getUniqueId())
        end
    end

    if player:getExhaustion("itemSellerExhaustion") > 0 then
        player:sendCancelMessage("Voce deve esperar "..player:getExhaustion("itemSellerExhaustion").." segundos.")
        return true
    end

    if not lootPouch then
        player:sendCancelMessage("Só pode ser usado com uma loot pouch.")
        player:setExhaustion("itemSellerExhaustion", conf.exhaust)
        return true
    end

    if lootPouch:getItemHoldingCount() < 1 then
        return player:sendCancelMessage("Sem itens para vender.")
    end

        local getcontainer = lootPouch:getItems()
        local itemsToSell = {}
        local totalEarn = 0
        local totalSelled = 0

        local i = 0
        while (i < conf.maxValuePerSell) do
            i = i+1
            table.insert(itemsToSell, getcontainer[i]) 
        end


        for _, it in ipairs(itemsToSell) do
            local count = it:getCount()

                if not it:isContainer() then
                    for _, eachType in pairs(LootShopConfigTable) do
                        for _, eachPrice in ipairs(eachType) do
                            if eachPrice.clientId == it:getId() then
                                if it:remove() then
                                Bank.credit(player:getName(), count * eachPrice.sell * conf.percentPrice)
                                totalSelled = totalSelled + count
                                totalEarn = totalEarn + (count * eachPrice.sell * conf.percentPrice)
                                end
                            end
                        end
                    end
                end
        end

        player:setExhaustion("itemSellerExhaustion", conf.exhaust)
        if totalSelled < 1 then
            player:sendCancelMessage("Sem itens para vender.")
            return true 
        end
        player:sendTextMessage(MESSAGE_TRADE, "Voce vendeu " ..totalSelled.. " itens que rendeu: " ..totalEarn.. " golds, creditados direto na sua bank account.")

    return true
end

itemSeller:id(3116)
itemSeller:register()
    
