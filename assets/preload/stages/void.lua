function onCreate()
	-- you're rapping in a fake world! Can't you see that idiot? Nothing here is real! Your mind is dying and there's nothing you can do about it!

	makeLuaSprite('stageback', 'stagebackF', -600, -300);
	setScrollFactor('stageback', 0.9, 0.9);
	
	makeLuaSprite('stagefront', 'stagefrontF', -650, 600);
	setScrollFactor('stagefront', 0.9, 0.9);
	scaleObject('stagefront', 1.1, 1.1);

	makeAnimatedLuaSprite('glitch', 'static', -600, -300);
	scaleObject('glitch', 2, 2);
	addAnimationByPrefix('glitch', 'glitchout', 'static glitch', 24, true);
	objectPlayAnimation('glitch', 'glitchout');
	addLuaSprite('glitch', true);
	setProperty('glitch.alpha', tonumber(0))

	makeLuaSprite('stagelight_left', 'stage_lightF', -125, -100);
	setScrollFactor('stagelight_left', 0.9, 0.9);
	scaleObject('stagelight_left', 1.1, 1.1);
		
	makeLuaSprite('stagelight_right', 'stage_lightF', 1225, -100);
	setScrollFactor('stagelight_right', 0.9, 0.9);
	scaleObject('stagelight_right', 1.1, 1.1);
	setProperty('stagelight_right.flipX', true); --mirror sprite horizontally

	makeLuaSprite('stagecurtains', 'stagecurtainsF', -500, -300);
	setScrollFactor('stagecurtains', 1.3, 1.3);
	scaleObject('stagecurtains', 0.9, 0.9);

	if not lowQuality then
		-- won't look as intended, but not everyone has a strong or decent computer :/
		makeLuaSprite('stagebackGlt', 'stagebackP', -600, -300);
		setScrollFactor('stagebackGlt', 0.9, 0.9);
		
		makeLuaSprite('stagefrontGlt', 'stagefrontP', -650, 600);
		setScrollFactor('stagefrontGlt', 0.9, 0.9);
		scaleObject('stagefrontGlt', 1.1, 1.1);
		
		makeLuaSprite('stagelight_leftGlt', 'stage_lightF', -125, -100);
		setScrollFactor('stagelight_leftGlt', 0.9, 0.9);
		scaleObject('stagelight_leftGlt', 1.1, 1.1);
			
		makeLuaSprite('stagelight_rightGlt', 'stage_lightF', 1225, -100);
		setScrollFactor('stagelight_rightGlt', 0.9, 0.9);
		scaleObject('stagelight_rightGlt', 1.1, 1.1);
		setProperty('stagelight_rightGlt.flipX', true); --mirror sprite horizontally

		makeLuaSprite('stagecurtainsGlt', 'stagecurtainsP', -500, -300);
		setScrollFactor('stagecurtainsGlt', 1.3, 1.3);
		scaleObject('stagecurtainsGlt', 0.9, 0.9);

		addLuaSprite('stagebackGlt', false);
		addLuaSprite('stagefrontGlt', false);
		addLuaSprite('stagelight_leftGlt', false);
		addLuaSprite('stagelight_rightGlt', false);
		addLuaSprite('stagecurtainsGlt', false);
	end
	
	addLuaSprite('stageback', false);
	addLuaSprite('stagefront', false);
	addLuaSprite('stagelight_left', false);
	addLuaSprite('stagelight_right', false);
	addLuaSprite('stagecurtains', false);

	
end
local thing = ''
function onStepHit()
	if curStep == 220 and getProperty('glitch.alpha') ~= 1 then
		doTweenAlpha('whatsThis', 'glitch', 1, 1, 'linear')
	end

	if curStep > 280 then
		cameraShake('hud', 0.003, 0.2);
	end
	
	if curStep > 300 and curStep < 522 then
		local stageFlicker = math.random(1, 5)
		if stageFlicker == 1 then
			setProperty('stageback.alpha', tonumber(0))
			thing = 'stageback'
			runTimer('flicker', 0.2, 1)
		elseif stageFlicker == 2 then
			setProperty('stagefront.alpha', tonumber(0))
			thing = 'stagefront'
			runTimer('flicker', 0.2, 1)
		elseif stageFlicker == 3 then
			setProperty('stagecurtains.alpha', tonumber(0))
			thing = 'stagecurtains'
			runTimer('flicker', 0.2, 1)
		end
	end
	if curStep == 523 then
		setProperty('stageback.alpha', tonumber(1))
		setProperty('stagefront.alpha', tonumber(1))
		setProperty('stagecurtains.alpha', tonumber(1))
	end
end

function onBeatHit()
	if curBeat == 139 then
		doTweenAlpha('Goodbye1', 'stageback', 0, 0.8, 'linear')
		doTweenAlpha('Goodbye2', 'stagefront', 0, 0.8, 'linear')
		doTweenAlpha('Goodbye3', 'stagelight_left', 0, 0.8, 'linear')
		doTweenAlpha('Goodbye4', 'stagelight_right', 0, 0.8, 'linear')
		doTweenAlpha('Goodbye5', 'stagecurtains', 0, 0.8, 'linear')

		doTweenAlpha('Goodbye6', 'stagebackGlt', 0, 0.8, 'linear')
		doTweenAlpha('Goodbye7', 'stagefrontGlt', 0, 0.8, 'linear')
		doTweenAlpha('Goodbye8', 'stagelight_leftGlt', 0, 0.8, 'linear')
		doTweenAlpha('Goodbye9', 'stagelight_rightGlt', 0, 0.8, 'linear')
		doTweenAlpha('Goodbye10', 'stagecurtainsGlt', 0, 0.8, 'linear')
	end
end

function opponentNoteHit()
    local luckyRoll = math.random(1, 50)
    local luckyRoll2 = math.random(1, 50)
    
    if mustHitSection == false and curStep > 414 then
        if (luckyRoll >= 45) then
            cameraShake('hud', 0.08, 0.05);
        end
    end
    if mustHitSection == false and curStep > 280 then
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