local xx = 580;
local yy = 450;
local xx2 = 820;
local yy2 = 450;
local ofs = 15;
local followchars = true;

function onCreate()
    addCharacterToList('bf-spook', 'boyfriend')
    addCharacterToList('bf@NOWYOU', 'boyfriend')
    precacheImage('Ghost_Kids')
    precacheSound('splat')
    precacheSound('HA_HA')
	-- background shit
	makeLuaSprite('spookstage', 'spookstageP', -200, -125);

    makeAnimatedLuaSprite('goostKids', 'Ghost_Kids', 400, 200)
    setObjectOrder('goostKids', '1')
    addAnimationByIndices('goostKids', 'idleLeft', 'spooky dance idle00', '0,1,2,3,4,5,6,7')
    addAnimationByIndices('goostKids', 'idleRight', 'spooky dance idle00','8,9,10,11,12,13,14,15')
    --eventually
    addAnimationByPrefix('goostKids', 'right', 'spooky sing right0', 24, true)
    addAnimationByPrefix('goostKids', 'down', 'spooky DOWN note0', 24, true)
    addAnimationByPrefix('goostKids', 'up', 'spooky UP NOTE0', 24, true)
    addAnimationByPrefix('goostKids', 'ey', 'spooky kids YEAH!!0', 24, true)
    setProperty('goostKids.alpha', tonumber(0.6))

	addLuaSprite('spookstage', false);
    addLuaSprite('goostKids', false)

    makeAnimatedLuaSprite('glitch', 'static', -600, -300);
    scaleObject('glitch', 2, 2);
    addAnimationByPrefix('glitch', 'glitchout', 'static glitch', 24, true);
    objectPlayAnimation('glitch', 'glitchout');
    addLuaSprite('glitch', true);
    triggerEvent('Load Shader', '', '')-- delete if you dont want the shader // Does this do anything?
        
end

function onStepHit()
    cameraShake('hud', 0.003, 0.2);
end

function onBeatHit()
    local ran = math.random(1, 6)
    local boogiL = false
    local boggiR = false

    if --[[curBeat % 2 == 0 and]] getProperty('gf.animation.curAnim.name') == 'danceLeft' then
        objectPlayAnimation('goostKids', 'idleLeft', true)
        boogiL = true
        boggiR = false
    elseif --[[curBeat % 2 == 1 and]] getProperty('gf.animation.curAnim.name') == 'danceRight' then 
        objectPlayAnimation('goostKids', 'idleRight', true)
        boggiR = true
        boogiL = false
    end

    if curBeat == 64 then
        triggerEvent('Set GF Speed', '2', '')
    end
    if curBeat == 128 then
        triggerEvent('Set GF Speed', '1', '')
    end
    if curBeat == 224 then
        triggerEvent('Set GF Speed', '4', '')
    end
    if curBeat == 288 then
        triggerEvent('Set GF Speed', '1', '')
    end
    if curBeat == 320 then
        triggerEvent('Set GF Speed', '2', '')
    end
    if curBeat == 352 then
        triggerEvent('Set GF Speed', '4', '')
    end
    if curBeat == 416 then
        triggerEvent('Set GF Speed', '1', '')
    end
	--[[if ran > 3 and curBeat >= 35 and mustHitSection == false then
		if boogiL == true and boogiR == false then
            objectPlayAnimation('goostKids', 'idleRight', true)
            boggiR = true
            boggiL = false
        elseif boggiL == false and boogiR == true then
            objectPlayAnimation('goostKids', 'idleLeft', true)
            boogiL = true
            boogiR = false
        end
	end]]
	-- offsets are funky
	--[[if ran == 1 and curBeat <= 290 and curBeat >= 35 then
	    --setProperty('goostKids.offset.x', 80)
        setProperty('goostKids.offset.y', -35)
		objectPlayAnimation('goostKids', 'up')
	elseif ran == 2 and curBeat <= 290 and curBeat >= 35 then
	    setProperty('goostKids.offset.x', 80)
        setProperty('goostKids.offset.y', -35)
		objectPlayAnimation('goostKids', 'down')
	elseif ran == 3 and curBeat <= 290 and curBeat >= 35 then
        setProperty('goostKids.offset.x', 80)
        setProperty('goostKids.offset.y', -35)
		objectPlayAnimation('goostKids', 'right')
    end]]
end

function opponentNoteHit()	
    local luckyRoll = math.random(1, 50)
    local luckyRoll2 = math.random(1, 50)
    
    if mustHitSection == false then
        if (luckyRoll >= 45) then
            cameraShake('hud', 0.08, 0.05);
        end
    end
    if mustHitSection == false then
        if (luckyRoll2 >= 45) then
            cameraShake('game', 0.08, 0.05);
        end
    end
end

function onUpdate()
    --[[if keyJustPressed('space') then
        setProperty('goostKids.offset.x', 80)
        setProperty('goostKids.offset.y', -35)
        objectPlayAnimation('goostKids', 'ey', true)
        setProperty('goostKids.specialAnim', true)
        runTimer('spokHey', 0.4, 1)
    end]]
    if followchars == true then
        if mustHitSection == false then
            setProperty('defaultCamZoom',0.85)
            if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle-alt' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
        else
            setProperty('defaultCamZoom',1.05)
            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                    triggerEvent('Camera Follow Pos',xx2,yy2)
            end
        end
    else
        triggerEvent('Camera Follow Pos','','')
    end
end