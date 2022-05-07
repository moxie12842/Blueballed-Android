function onCreate()
	precacheImage('badEndPico')
	precacheImage('badEndKids')
	precacheImage('noteSplashesRIGHT')
    precacheImage('noteSplashesLEFT')
    precacheImage('noteSplashesDOWN')
    precacheImage('noteSplashesUP')
	precacheImage('pibbly/behindTrain')
	precacheImage('pibbly/city')
	precacheImage('pibbly/sky')
	precacheImage('pibbly/street')
	precacheImage('spookstageP')

	-- for icons (don't know of a better way as of now)
	addCharacterToList('bf@ITSYOU-wP', 'dad')
	addCharacterToList('bf@ITSYOU-wSp', 'dad')
	addCharacterToList('bf@ITSYOU-wAll', 'dad')

	-- background shit
	-- this might be demanding I think

	-- part 1
	
	makeLuaSprite('stageback', 'stagebackP', -600, -300);
	setScrollFactor('stageback', 0.9, 0.9);
	setProperty('stageback.alpha', tonumber(0))
	
	makeLuaSprite('stagefront', 'stagefrontP', -650, 600);
	setScrollFactor('stagefront', 0.9, 0.9);
	scaleObject('stagefront', 1.1, 1.1);
	setProperty('stagefront.alpha', tonumber(0))

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

	makeLuaSprite('stagecurtains', 'stagecurtainsP', -500, -300);
	setScrollFactor('stagecurtains', 1.3, 1.3);
	scaleObject('stagecurtains', 0.9, 0.9);
	setProperty('stagecurtains.alpha', tonumber(0))
	

	addLuaSprite('stageback', false);
	addLuaSprite('stagefront', false);
	addLuaSprite('stagelight_left', false);
	addLuaSprite('stagelight_right', false);
	addLuaSprite('stagecurtains', false);
end
-- only once
local swaggy = false

function onEndSong()
	swaggy = true
end

function onBeatHit()
	if curStep >= 384 then -- and curStep <= then
		-- for their specific parts
		if curBeat % 2 == 0 and curBeat <= 320 then
			setProperty('pibbco.offset.x', -30)
			setProperty('pibbco.offset.y', 10)
			objectPlayAnimation('pibbco', 'idle', true)
		end
		if curBeat % 2 == 0 and curBeat <= 320 then
			setProperty('scaryKids.offset.x', 40)
			setProperty('scaryKids.offset.y', 10)
			objectPlayAnimation('scaryKids', 'idleLeft', true)
		elseif curBeat % 2 == 1 and curBeat <= 320 then
			--setProperty('scaryKids.offset.x', 40)
			--setProperty('scaryKids.offset.y', 10)
			objectPlayAnimation('scaryKids', 'idleRight', true)
		end
		-- end point
		if curBeat % 2 == 0 and curBeat > 320 then
			setProperty('pibbco.offset.x', -40)
			setProperty('pibbco.offset.y', 10)
			objectPlayAnimation('pibbco', 'idle', true)
		end
		if curBeat % 2 == 0 and curBeat > 320 then
			setProperty('scaryKids.offset.x', 130)
			setProperty('scaryKids.offset.y', 10)
			objectPlayAnimation('scaryKids', 'idleLeft', true)
		elseif curBeat % 2 == 1 and curBeat > 320 then
			--setProperty('scaryKids.offset.x', 40)
			--setProperty('scaryKids.offset.y', 10)
			objectPlayAnimation('scaryKids', 'idleRight', true)
		end
	end
end

function onStepHit()
	if swaggy == false then
		cameraShake('hud', 0.003, 0.2);
		if curStep == 15 then
			doTweenAlpha('comeIn', 'stageback', 1, 2, 'linear')
			doTweenAlpha('comeIn2', 'stagefront', 1, 2, 'linear')
			doTweenAlpha('comeIn3', 'stagelight_left', 1, 2, 'linear')
			doTweenAlpha('comeIn4', 'stagelight_right', 1, 2, 'linear')
			doTweenAlpha('comeIn5', 'stagecurtains', 1, 2, 'linear')
		end
		if curStep == 384 and not lowQuality then
			cameraFlash('game', '0xFFFFFF', 0.5, true)
			removeLuaSprite('stageback', false)
			removeLuaSprite('stagefront', false)
			removeLuaSprite('stagelight_left', false)
			removeLuaSprite('stagelight_right', false)
			removeLuaSprite('stagecurtains', false)
			-- part 2
			triggerEvent('Change Character', 'dad', 'bf@ITSYOU-wP')
			makeLuaSprite('sky', 'pibbly/sky', -92, 90);
			setScrollFactor('sky', 0.6, 0.6);
			
			makeLuaSprite('city', 'pibbly/city', -70, 50);
			setScrollFactor('city', 0.7, 0.7);
		
			makeLuaSprite('trainThing', 'pibbly/behindTrain', -55, 100);
			
			makeLuaSprite('street', 'pibbly/street', -55, 100);

			makeAnimatedLuaSprite('pibbco', 'badEndPico', 360, 325)
			setObjectOrder('pibbco', '2')
			addAnimationByPrefix('pibbco', 'idle', 'Pico Idle Dance0', 24, false)
			addAnimationByPrefix('pibbco', 'down', 'Pico Down Note0', 24, true)
			setProperty('pibbco.flipX', true)

			addLuaSprite('sky', false)
			addLuaSprite('city', false)
			addLuaSprite('trainThing', false)
			addLuaSprite('street', false)
			addLuaSprite('pibbco', false)
			--setProperty('gf.offset.y', 10)
		end
		if curStep == 767  and not lowQuality then
			-- parto 3o
			removeLuaSprite('sky', true)
			removeLuaSprite('city', true)
			removeLuaSprite('trainThing', true)
			removeLuaSprite('street', true)
			removeLuaSprite('pibbco', false)

			triggerEvent('Change Character', 'dad', 'bf@ITSYOU-wSp')
			makeAnimatedLuaSprite('scaryKids', 'badEndKids', 360, 270)
			addAnimationByIndices('scaryKids', 'idleLeft', 'spooky dance idle00', '0,1,2,3,4,5,6,7')
    		addAnimationByIndices('scaryKids', 'idleRight', 'spooky dance idle00','8,9,10,11,12,13,14,15')
			addAnimationByPrefix('scaryKids', 'toss', 'spooky sing right0', 24, true)
			setObjectOrder('scaryKids', '2')

			cameraFlash('game', '0xFFFFFF', 0.5, true)
			makeLuaSprite('spookstage', 'spookstageP', -200, -125);
			addLuaSprite('spookstage', false);
			addLuaSprite('scaryKids', false)
		end
		if curStep == 1294 then
			-- back to start
			triggerEvent('Change Character', 'dad', 'bf@ITSYOU')
			removeLuaSprite('spookstage', true)
			removeLuaSprite('scaryKids', false)
			cameraFlash('game', '0xFFFFFF', 0.5, true)
			addLuaSprite('stageback', false);
			addLuaSprite('stagefront', false);
			addLuaSprite('stagelight_left', false);
			addLuaSprite('stagelight_right', false);
			addLuaSprite('stagecurtains', false);
		end
		if curStep == 1310 then
			triggerEvent('Change Character', 'dad', 'bf@ITSYOU-wAll')
			cameraFlash('game', 'ffffff', 0.3, true)
			addLuaSprite('scaryKids', false)
			setObjectOrder('scaryKids', '7')

			addLuaSprite('pibbco', false)
			setProperty('pibbco.flipX', true)
			setObjectOrder('pibbco', '7')

		end
	end
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

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Shootems' then
		if curBeat > 320 then
			setProperty('pibbco.offset.x', 70)
			setProperty('pibbco.offset.y', -70)
			objectPlayAnimation('pibbco', 'down', true)
			--setProperty('pibbco.specialAnim', true)
		else
			setProperty('pibbco.offset.x', 70)
			setProperty('pibbco.offset.y', -70)
			objectPlayAnimation('pibbco', 'down', true)
			--setProperty('pibbco.specialAnim', true)
		end
	end
	if noteType == 'Whoops' then
		if curBeat > 320 then
			setProperty('scaryKids.offset.x', -10)
			setProperty('scaryKids.offset.y', -5)
			objectPlayAnimation('scaryKids', 'toss', true)
			--setProperty('scaryKids.specialAnim', true)
		else
			setProperty('scaryKids.offset.x', -10)
			setProperty('scaryKids.offset.y', -5)
			objectPlayAnimation('scaryKids', 'toss', true)
			--setProperty('scaryKids.specialAnim', true)
		end
	end
end