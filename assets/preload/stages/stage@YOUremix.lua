function onCreate()
	-- prolly dont need to make a whole new stage for this but eh, it's easier
	-- background shit

	makeLuaSprite('stagebackG', 'stagebackP', -600, -300);
	setScrollFactor('stagebackG', 0.9, 0.9);
	setProperty('stagebackG.alpha', tonumber(0))
	
	makeLuaSprite('stagefrontG', 'stagefrontP', -650, 600);
	setScrollFactor('stagefrontG', 0.9, 0.9);
	scaleObject('stagefrontG', 1.1, 1.1);
	setProperty('stagefrontG.alpha', tonumber(0))

	makeAnimatedLuaSprite('glitch', 'static', -600, -300);
	scaleObject('glitch', 2, 2);
	addAnimationByPrefix('glitch', 'glitchout', 'static glitch', 24, true);
	objectPlayAnimation('glitch', 'glitchout');
	addLuaSprite('glitch', true); -- false = add behind characters, true = add over characters

	makeLuaSprite('stagelight_left', 'stage_light', -125, -100);
	setScrollFactor('stagelight_left', 0.9, 0.9);
	scaleObject('stagelight_left', 1.1, 1.1);
	setProperty('stagelight_left.alpha', tonumber(0))
	
	makeLuaSprite('stagelight_right', 'stage_light', 1225, -100);
	setScrollFactor('stagelight_right', 0.9, 0.9);
	scaleObject('stagelight_right', 1.1, 1.1);
	setProperty('stagelight_right.flipX', true); --mirror sprite horizontally
	setProperty('stagelight_right.alpha', tonumber(0))

	makeLuaSprite('stagecurtainsG', 'stagecurtainsP', -500, -300);
	setScrollFactor('stagecurtainsG', 1.3, 1.3);
	scaleObject('stagecurtainsG', 0.9, 0.9);
	setProperty('stagecurtainsG.alpha', tonumber(0))

	-- not gloop
	makeLuaSprite('stagebackR', 'stagebackF', -600, -300);
	setScrollFactor('stagebackR', 0.9, 0.9);
	setProperty('stagebackR.alpha', tonumber(0))
	
	makeLuaSprite('stagefrontR', 'stagefrontF', -650, 600);
	setScrollFactor('stagefrontR', 0.9, 0.9);
	scaleObject('stagefrontR', 1.1, 1.1);
	setProperty('stagefrontR.alpha', tonumber(0))

	makeLuaSprite('stagecurtainsR', 'stagecurtainsF', -500, -300);
	setScrollFactor('stagecurtainsR', 1.3, 1.3);
	scaleObject('stagecurtainsR', 0.9, 0.9);
	setProperty('stagecurtainsR.alpha', tonumber(0))
	

	addLuaSprite('stagebackR', false);
	addLuaSprite('stagebackG', false);
	addLuaSprite('stagefrontR', false);
	addLuaSprite('stagefrontG', false);
	addLuaSprite('stagecurtainsR', false);
	addLuaSprite('stagecurtainsG', false);

	
	
	addLuaSprite('stagelight_left', false); -- can't even see these
	addLuaSprite('stagelight_right', false);
	

	
end

local tesTickle = false
function onEndSong()
	tesTickle = true
end

function onBeatHit()
	if curBeat == 3 then
		cameraFlash('game', '0xffffff', 0.4, true)
		setProperty('stagebackG.alpha', tonumber(1))
		setProperty('stagefrontG.alpha', tonumber(1))
		setProperty('stagelight_left.alpha', tonumber(1))
		setProperty('stagelight_right.alpha', tonumber(1))
		setProperty('stagecurtainsG.alpha', tonumber(1))
		setProperty('stagebackR.alpha', tonumber(1))
		setProperty('stagefrontR.alpha', tonumber(1))
		setProperty('stagecurtainsR.alpha', tonumber(1))
	end


	
end

local thing = ''

function onStepHit()
	if tesTickle == false then
		cameraShake('hud', 0.003, 0.2);
	end
	
	local stageFlicker = math.random(1, 5)

	if curBeat > 5 then
		if stageFlicker == 1 then
			setProperty('stagebackG.alpha', tonumber(0))
			thing = 'stagebackG'
			runTimer('flicker', 0.2, 1)
		elseif stageFlicker == 2 then
			setProperty('stagefrontG.alpha', tonumber(0))
			thing = 'stagefrontG'
			runTimer('flicker', 0.2, 1)
		elseif stageFlicker == 3 then
			setProperty('stagecurtainsG.alpha', tonumber(0))
			thing = 'stagecurtainsG'
			runTimer('flicker', 0.2, 1)
		end
	end
end

function opponentNoteHit()
    local luckyRoll = math.random(1, 50)
    local luckyRoll2 = math.random(1, 50)
    
    if mustHitSection == false and tesTickle == false then
        if (luckyRoll >= 45) then
            cameraShake('hud', 0.08, 0.05);
        end
    end
    if mustHitSection == false and tesTickle == false then
        if (luckyRoll2 >= 45) then
            cameraShake('game', 0.08, 0.05);
        end
    end
end


function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'flicker' then
		setProperty(thing..'.alpha', tonumber(1))
		thing = ''
	end
end