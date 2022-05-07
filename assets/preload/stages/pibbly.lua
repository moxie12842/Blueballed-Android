function onCreate()
    --spooky
    addCharacterToList('pico', 'dad')
	addCharacterToList('bf-pico', 'boyfriend')
    addCharacterToList('bf@NOWYOU', 'boyfriend')
	precacheImage('Ghost_Pico')
	precacheSound('HESGOTAGUN')
	precacheSound('1pico_gets_slid')
	precacheSound('3right_in_the_jaw')
	precacheSound('HA_HA')

	-- background shit
	makeLuaSprite('sky', 'pibbly/sky', -92, 90);
	setScrollFactor('sky', 0.6, 0.6);
	
	makeLuaSprite('city', 'pibbly/city', -70, 50);
	setScrollFactor('city', 0.7, 0.7);
	--scaleObject('city', 1.1, 1.1);

	makeLuaSprite('trainThing', 'pibbly/behindTrain', -55, 100);
	--setScrollFactor('trainThing', 0.9, 0.9);
	
	makeLuaSprite('street', 'pibbly/street', -55, 100);
	--setScrollFactor('street', 0.9, 0.9);
	--scaleObject('street', 1.1, 1.1);

	makeAnimatedLuaSprite('picos_dead!1!!', 'Ghost_Pico', 400, 300);
	setObjectOrder('picos_dead!1!!', '1')
	addAnimationByPrefix('picos_dead!1!!', 'idle', 'Pico Idle Dance0', 24, false)
	addAnimationByPrefix('picos_dead!1!!', 'left', 'Pico NOTE LEFT0', 24, true)
	addAnimationByPrefix('picos_dead!1!!', 'right', 'Pico Note Right0', 24, true)
	addAnimationByPrefix('picos_dead!1!!', 'up', 'pico Up note0', 24, true)
	addAnimationByPrefix('picos_dead!1!!', 'down', 'Pico Down Note0', 24, true)
	addAnimationByPrefix('picos_dead!1!!', 'damn', 'Pico NOTE LEFT miss0', 24, true)
	
	addLuaSprite('sky', false)
	addLuaSprite('city', false)
	addLuaSprite('trainThing', false)
	addLuaSprite('street', false)
	addLuaSprite('picos_dead!1!!', false)
	setProperty('picos_dead!1!!.alpha', tonumber(0))

	makeAnimatedLuaSprite('glitch', 'static', -600, -300);
	scaleObject('glitch', 2, 2);
	addAnimationByPrefix('glitch', 'glitchout', 'static glitch', 24, true);
	objectPlayAnimation('glitch', 'glitchout');
	addLuaSprite('glitch', true); -- false = add behind characters, true = add over characters

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
		-- weak pc? didn't ask
	end
end
local stopFucknShakn = false
function onEndSong()
	stopFucknShakn = true
end

function onStepHit()
	if stopFucknShakn == false then
    	cameraShake('hud', 0.003, 0.2);
	end
end

function opponentNoteHit()
    local luckyRoll = math.random(1, 50)
    local luckyRoll2 = math.random(1, 50)
    
    if mustHitSection == false and curStep <= 1280 then
        if (luckyRoll >= 45) then
            cameraShake('hud', 0.08, 0.05);
        end
    end
    if mustHitSection == false then
        if (luckyRoll2 >= 45) and curStep <= 1280 then
            cameraShake('game', 0.08, 0.05);
        end
    end
end

function onUpdate()
	if getProperty('boyfriend.curCharacter') == 'bf@NOWYOU' then
		setProperty('picos_dead!1!!.offset.x', -680)
		setProperty('picos_dead!1!!.offset.y', -80)
		objectPlayAnimation('picos_dead!1!!', 'damn')
		doTweenAlpha('noPoint', 'picos_dead!1!!', 0, 0.7, 'linear')
	end
end

function onBeatHit()
	if curBeat == 32 then
		doTweenAlpha('ahShit', 'picos_dead!1!!', 0.6, 0.6, 'linear')
	end
	--local ran = math.random(1, 6)
	if curBeat % 2 == 0 and getProperty('boyfriend.animation.curAnim.name') == 'idle' or getProperty('boyfriend.animation.curAnim.name') == 'dodge' --[[ran > 4 and curBeat <= 290]] then
		setProperty('picos_dead!1!!.offset.x', -740)
		setProperty('picos_dead!1!!.offset.y', -100)
		objectPlayAnimation('picos_dead!1!!', 'idle')
	end
	-- offsets are funky
	--[[if ran == 1 and curBeat <= 290 then
		setProperty('picos_dead!1!!.offset.x', -740)
		setProperty('picos_dead!1!!.offset.y', -75)
		objectPlayAnimation('picos_dead!1!!', 'up')
	elseif ran == 2 and curBeat <= 290 then
		setProperty('picos_dead!1!!.offset.x', -660)
		setProperty('picos_dead!1!!.offset.y', -180)
		objectPlayAnimation('picos_dead!1!!', 'down')
	elseif ran == 3 and curBeat <= 290 then
		setProperty('picos_dead!1!!.offset.x', -800)
		setProperty('picos_dead!1!!.offset.y', -100)
		objectPlayAnimation('picos_dead!1!!', 'right')
	elseif ran == 4 and curBeat <= 290 then
		setProperty('picos_dead!1!!.offset.x', -645)
		setProperty('picos_dead!1!!.offset.y', -110)
		objectPlayAnimation('picos_dead!1!!', 'left')
	end]]
	if curBeat == 159 and getProperty('boyfriend.curCharacter') ~= 'bf@NOWYOU' then
		doTweenAlpha('blammedLights', 'picos_dead!1!!', 0, 0.5, 'linear')
	end
	if curBeat == 192 and getProperty('boyfriend.curCharacter') ~= 'bf@NOWYOU' then
		doTweenAlpha('notBlammedLights', 'picos_dead!1!!', 0.6, 0.5, 'linear')
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if direction == 0 and noteType ~= 'Shootems' then
		setProperty('picos_dead!1!!.offset.x', -645)
		setProperty('picos_dead!1!!.offset.y', -110)
		objectPlayAnimation('picos_dead!1!!', 'left', true)
	elseif direction == 1 and noteType ~= 'Shootems' then
		setProperty('picos_dead!1!!.offset.x', -660)
		setProperty('picos_dead!1!!.offset.y', -180)
		objectPlayAnimation('picos_dead!1!!', 'down', true)
	elseif direction == 2 and noteType ~= 'Shootems' then
		setProperty('picos_dead!1!!.offset.x', -740)
		setProperty('picos_dead!1!!.offset.y', -75)
		objectPlayAnimation('picos_dead!1!!', 'up', true)
	elseif direction == 3 and noteType ~= 'Shootems' then
		setProperty('picos_dead!1!!.offset.x', -800)
		setProperty('picos_dead!1!!.offset.y', -100)
		objectPlayAnimation('picos_dead!1!!', 'right', true)
	end
end