--Some quick settings here
local YourName = 'Plotsh'
local ImageFileName = 'Plotsh'
local BoxTransparency = 0.6
---------------------------

local HideInfoCard = false
function onCreatePost()
    if getProperty('cpuControlled') == true then
        NewCardHudSprite('BotplayLol', '💀', 0, 250, 0.5, 0.5, 1, true);
        setProperty('healthBar.alpha', 0);
    else
        NewCardHudSprite('Rectangle', 'rectangle', 0, 250, 0.5, 0.5, BoxTransparency, true);
        NewCardHudSprite('Card', 'Picture/'..ImageFileName, 0, 250, 0.545, 0.545, 1, true);
        NewCardHudText('Name', YourName, 999, 86, 251, 'left', 23);
        if getProperty('practiceMode') == true then
            NewCardHudText('PMMisses', '0', 400, -13, 280, 'center', 42);
            NewCardHudText('PMText', 'Misses', 300, 38, 324, 'center', 25);
        else
            NewCardHudText('Score', '0', 999, 86, 282, 'left', 19);
            NewCardHudText('Accuracy', '?', 999, 86, 308, 'left', 19);
            NewCardHudText('Misses', '0 Misses', 999, 86, 334, 'left', 19);
            NewCardHudText('MissRating', '', 999, -705, 334, 'right', 19);
            NewCardHudText('AccRating', '', 999, -705, 308, 'right', 19);
        end
    end
    --Clan TX the "setProperty" function stan
    setProperty('scoreTxt.visible', false);
    setProperty('iconP1.visible', false);
    setProperty('iconP2.visible', false);
    setProperty('healthBar.x', -147);
    setProperty('healthBar.y', 240);
    setProperty('healthBar.scale.x', 0.507);
    setProperty('healthBar.scale.y', 0.75);
    setProperty('healthBar.angle', 180);
    setProperty('healthBarBG.scale.x', 0);
    setProperty('timeBar.x', -46);
    setProperty('timeBar.y', 361.2);
    setProperty('timeBar.scale.x', 0.749);
    setProperty('timeBar.scale.y', 0.88);
    setProperty('timeBarBG.scale.x', 0.749);
    setProperty('timeBarBG.scale.y', 0.88);
    setProperty('timeTxt.x', -50);
    setProperty('timeTxt.y', 374.2);
    setProperty('timeTxt.scale.x', 0.85);
    setProperty('timeTxt.scale.y', 0.85);
end

function onUpdate()
    setTextString('Score', getProperty('songScore'));
    setTextString('MissRating', getProperty('ratingFC'));
    setTextString('PMMisses', getProperty('songMisses'));
    if getProperty('songMisses') == 0 then
        setTextString('Misses', 'No misses');
    else
        if getProperty('songMisses') == 1 then
            setTextString('Misses', getProperty('songMisses').. ' Miss')
            setTextString('PMText', 'Miss');
        else
            setTextString('Misses', getProperty('songMisses').. ' Misses');
            setTextString('PMText', 'Misses');
        end
    end
    if getProperty('songScore') == 0 then
        setTextString('Accuracy', '?');
    else
        setTextString('Accuracy', '' .. round((getProperty('ratingPercent') * 100), 2) .. '%');
        --I'm sorry for this
        if getProperty('ratingPercent') == 1 then
            modifyAccText('X', 'ececec');
        elseif getProperty('ratingPercent') >= 0.99 then
            modifyAccText('SS', 'f3f87e');
        elseif getProperty('ratingPercent') >= 0.95 then
            modifyAccText('S', 'e9d31f')
        elseif getProperty('ratingPercent') >= 0.9 then
            modifyAccText('A', '05b30e');
        elseif getProperty('ratingPercent') >= 0.8 then
            modifyAccText('B', '2450d1');
        elseif getProperty('ratingPercent') >= 0.7 then
            modifyAccText('C', 'b624d1');
        else
            modifyAccText('D', 'd40e10')
        end
    end
    --Thing that hides the thing ("doTweenX" CRASHES THE GAME IF "close(true)" IS USED IN ANY SCRIPT. TO FIX IT (for now) JUST FIND THAT COMMAND AND REMOVE IT or just remove all of these tweens, disabling entirely the tab button. Help is appreciated for this. i'm typing too much kthxbai)
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.TAB') then
        if HideInfoCard == false then
            HideInfoCard = true
            doTweenX('moveCard1', 'Card', -400, 0.5, 'circOut');
            doTweenX('moveCard2', 'Rectangle', -400, 0.5, 'circOut');
            doTweenX('moveCard3', 'Name', -314, 0.5, 'circOut');
            doTweenX('moveCard4', 'Score', -314, 0.5, 'circOut');
            doTweenX('moveCard5', 'Accuracy', -314, 0.5, 'circOut');
            doTweenX('moveCard6', 'Misses', -314, 0.5, 'circOut');
            doTweenX('moveCard7', 'MissRating', -1105, 0.5, 'circOut');
            doTweenX('moveCard8', 'AccRating', -1105, 0.5, 'circOut');
            doTweenX('moveCard9', 'healthBar', -547, 0.5, 'circOut');
            doTweenX('moveCard10', 'timeBar', -446, 0.5, 'circOut');
            doTweenX('moveCard11', 'timeTxt', -450, 0.5, 'circOut');
            doTweenX('moveCard12', 'BotplayLol', -400, 0.5, 'circOut');
            doTweenX('moveCard13', 'PMMisses', -265, 0.5, 'circOut');
            doTweenX('moveCard14', 'PMText', -365, 0.5, 'circOut');
        else
            HideInfoCard = false
            doTweenX('moveCard1', 'Card', 0, 0.5, 'circOut');
            doTweenX('moveCard2', 'Rectangle', 0, 0.5, 'circOut');
            doTweenX('moveCard3', 'Name', 86, 0.5, 'circOut');
            doTweenX('moveCard4', 'Score', 86, 0.5, 'circOut');
            doTweenX('moveCard5', 'Accuracy', 86, 0.5, 'circOut');
            doTweenX('moveCard6', 'Misses', 86, 0.5, 'circOut');
            doTweenX('moveCard7', 'MissRating', -705, 0.5, 'circOut');
            doTweenX('moveCard8', 'AccRating', -705, 0.5, 'circOut');
            doTweenX('moveCard9', 'healthBar', -147, 0.5, 'circOut');
            doTweenX('moveCard10', 'timeBar', -46, 0.5, 'circOut');
            doTweenX('moveCard11', 'timeTxt', -50, 0.5, 'circOut');
            doTweenX('moveCard12', 'BotplayLol', 0, 0.5, 'circOut');
            doTweenX('moveCard13', 'PMMisses', 135, 0.5, 'circOut');
            doTweenX('moveCard14', 'PMText', 38, 0.5, 'circOut');
        end
    end
end

function NewCardHudSprite(tag, image, x, y, xscale, yscale, alpha, top)
    makeLuaSprite(tag, 'ProfileCardAssets/'..image, x, y);
    scaleObject(tag, xscale, yscale);
    setProperty(tag..'.alpha', alpha);
    setObjectCamera(tag, 'hud');
    addLuaSprite(tag, top);
end

function NewCardHudText(tag, text, width, x, y, alignment, size)
    makeLuaText(tag, text, width, x, y);
    setTextAlignment(tag, alignment);
    setTextSize(tag, size);
    addLuaText(tag);
end

function modifyAccText(text, color)
    setTextString('AccRating', text);
    setTextColor('AccRating', color);
end

function round(x, n) --https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate (everyone uses this in their scripts as if this was some kind of gift sent by god)                                            (it is)
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end

--[[
    Doodoo script made by Clan TX / tx
        if some actual programmer looks at this code and gets a headache, I'm sorry    
--]]