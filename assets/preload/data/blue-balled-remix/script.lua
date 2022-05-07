local allowCountdown = false
local startedEndDialogue = false
local botty = false
-- this var is to prevent the shit from happening again in the dialogue
local playedThrough = false
function onStartCountdown()
    if getProperty('cpuControlled') == true then
        botty = true
    end
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and isStoryMode and not seenCutscene and botty == false then
		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.8);
		allowCountdown = true;
		return Function_Stop;
    elseif not allowCountdown and isStoryMode and not seenCutscene and botty == true then
		setProperty('inCutscene', true);
		runTimer('startDialogueBeepBop', 0.8);
		allowCountdown = true;
		return Function_Stop;
    end
    
	return Function_Continue;
end

function onEndSong()
    allowCountdown = false
    if not allowCountdown and isStoryMode and not startedEndDialogue then
        setProperty('inCutscene', true);
        playedThrough = true
        if getProperty('boyfriend.curCharacter') == 'bfYOUGHOST' then
            runTimer('startDialogueBadEnd', 0.8);
        else
            runTimer('startDialogueEnd', 0.8);
        end

        startedEndDialogue = true;

        return Function_Stop;
    end
    if getProperty('boyfriend.curCharacter') == 'bfYOUGHOST' then
        --os.exit() haha no more compatibility for 5.2
        close(); -- think this works the same hoepfully
    else
        return Function_Continue;
    end
end

local keepScroll = false

function onCreate()
    addCharacterToList('bf@NOTYOU', 'dad')
    addCharacterToList('bf@NOTYOUghost', 'dad')
    addCharacterToList('bfYOUgf', 'gf')
    addCharacterToList('bfYOUghost', 'boyfriend')
    addCharacterToList('bfYOUghost-scared', 'boyfriend')
    addCharacterToList('bfYOU-scared', 'boyfriend')
    precacheImage('balls_overlay')
    precacheImage('miicrophonee')
    -- prolly no need for this many note splashes
    -- I could probably just use one, but I don't feel like it right now
    precacheImage('noteSplashesRIGHT')
    precacheImage('noteSplashesLEFT')
    precacheImage('noteSplashesDOWN')
    precacheImage('noteSplashesUP')
    precacheSound('HA_HA')
    triggerEvent('Camera Follow Pos', 625, 600)
    triggerEvent('Change Character', '2', 'bfYOUgf')
    setProperty('gf.alpha', tonumber(0))
    setProperty('dad.alpha', tonumber(0))
    -- this makes sure there aint an icon for dad (he's not supposed to have one)
    setProperty('iconP2.alpha', tonumber(0))
    setProperty('health', 2)
    setProperty('scoreTxt.alpha', tonumber(0))
    
    -- fuck up counter (thanks to HaxLua for the counter stuff: https://github.com/ShadowMario/FNF-PsychEngine/discussions/3670)
    -- yours
    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        makeLuaText("resist", 'Resistance: 0', 200, 940, 77);
    else
        makeLuaText("resist", 'Resistance: 0', 200, 940, 639);
    end
    
    setObjectCamera("resist", 'hud');
    setTextColor('resist', '0x36eaf7')
    setTextSize('resist', 20);
    addLuaText("resist");
    setTextFont('resist', "vcr.ttf")
    setTextAlignment('resist', 'center')
    
    -- his
    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        makeLuaText("control", 'Control: 0', 200, 155, 77);
    else
        makeLuaText("control", 'Control: 0', 200, 155, 639);
    end
    setObjectCamera("control", 'hud');
    setTextColor('control', '0xff0000')
    setTextSize('control', 20);
    addLuaText("control");
    setTextFont('control', "vcr.ttf")
    setTextAlignment('control', 'center')
    setProperty('control.alpha', tonumber(0))

    -- bad ending text
    makeLuaText("Lost", 'LOSER', 1000, screenWidth / 2 - 100, screenHeight / 2);
    setObjectCamera("Lost", 'hud');
    setTextColor('Lost', '0xff0000')
    setTextSize('Lost', 100);
    setTextFont('Lost', "vcr.ttf")
    setTextAlignment('Lost', 'center')

    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        makeLuaText("fakeScore", 'Score: 0', 300, 650, 36);
    else
        makeLuaText("fakeScore", 'Score: 0', 300, 650, 670);
    end
    setObjectCamera("fakeScore", 'hud');
    setTextColor('fakeScore', '0xffffff')
    setTextSize('fakeScore', 19);
    addLuaText("fakeScore");
    setTextFont('fakeScore', "vcr.ttf")
    setTextAlignment('fakeScore', 'center')

    doTweenY('botplytxtDownABit', 'botplayTxt', 160, 0.6, 'quartInOut')
end


function onCreatePost()
    -- part 1
    makeLuaText('warning1', "3. That's the limit.", 500, screenWidth / 2 - 250, screenHeight / 2 - 50);
    setObjectCamera("warning1", 'other');
    setTextColor('warning1', '0xff0000')
    setTextSize('warning1', 20);
    addLuaText("warning1");
    setProperty('warning1.alpha', tonumber(0))
    setTextFont('warning1', "vcr.ttf");
    setTextAlignment('warning1', 'center');

    -- part 2
    makeLuaText('warning2', "And whatever you do, DON'T FALL ASLEEP.", 500, screenWidth / 2 - 250, screenHeight / 2);
    setObjectCamera("warning2", 'other');
    setTextColor('warning2', '0xff0000')
    setTextSize('warning2', 20);
    addLuaText("warning2");
    setProperty('warning2.alpha', tonumber(0))
    setTextFont('warning2', "vcr.ttf")
    setTextAlignment('warning2', 'center')

end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if curBeat <= 223 then
        setProperty('health', getProperty('health')+ 0.0112)
    end
    if curBeat >= 224 then
        setProperty('health', getProperty('health')+ 0.0689)
    end
    -- for the fake score "zoom"
    if isSustainNote == false then
        setProperty('fakeScore.scale.x', 1.1)
        setProperty('fakeScore.scale.y', 1.1)
        runTimer('hited', 0.1, 1)
    end
end

-- this var is for notesplashes
local var undo = false
function opponentNoteHit(id, direction, noteType, isSustainNote)

    health = getProperty('health')
    if getProperty('health') > 0.04 and curBeat <= 223 then
        setProperty('health', health- 0.0312)
    end
    if getProperty('health') > 0.0825 and curBeat >= 224 then
        setProperty('health', health- 0.0824)
    end

    -- mama mia this is gonna be big for just some notesplashes
    -- regular (upscroll, middlescroll and fusion)
	if mustHitSection == false and getPropertyFromClass('ClientPrefs', 'downScroll') == false and undo == false or getPropertyFromClass('ClientPrefs', 'middleScroll') == true then
		if direction == 0 and isSustainNote == false then
			makeAnimatedLuaSprite('splashLEFT', 'noteSplashesLEFT', 340, 223)
			addAnimationByPrefix('splashLEFT', 'toTheLeft', 'noteSplashes 000', 24, false)
			addLuaSprite('splashLEFT', true)
			runTimer('splashGoneLeft', 0.2, 1)
		end
		if direction == 1 and isSustainNote == false then
			makeAnimatedLuaSprite('splashDOWN', 'noteSplashesDOWN', 465, 223)
			addAnimationByPrefix('splashDOWN', 'toTheDown', 'noteSplashes 000', 24, false)
			addLuaSprite('splashDOWN', true)
			runTimer('splashGoneDown', 0.2, 1)
		end
		if direction == 2 and isSustainNote == false then
			makeAnimatedLuaSprite('splashUP', 'noteSplashesUP', 575, 223)
			addAnimationByPrefix('splashUP', 'toTheUp', 'noteSplashes 000', 24, false)
			addLuaSprite('splashUP', true)
			runTimer('splashGoneUp', 0.2, 1)
		end
		if direction == 3 and isSustainNote == false then
			makeAnimatedLuaSprite('splashRIGHT', 'noteSplashesRIGHT', 684, 223)
			addAnimationByPrefix('splashRIGHT', 'toTheRight', 'noteSplashes 000', 24, false)
			addLuaSprite('splashRIGHT', true)
			runTimer('splashGoneRight', 0.2, 1)
		end
    end
    
    -- downscroll and fusion
    if mustHitSection == false and getPropertyFromClass('ClientPrefs', 'downScroll') == true and undo == false then
        if direction == 0 and isSustainNote == false then
            makeAnimatedLuaSprite('splashLEFT', 'noteSplashesLEFT', 340, 723)
            addAnimationByPrefix('splashLEFT', 'toTheLeft', 'noteSplashes 000', 24, false)
            addLuaSprite('splashLEFT', true)
            runTimer('splashGoneLeft', 0.2, 1)
        end
        if direction == 1 and isSustainNote == false then
            makeAnimatedLuaSprite('splashDOWN', 'noteSplashesDOWN', 465, 723)
            addAnimationByPrefix('splashDOWN', 'toTheDown', 'noteSplashes 000', 24, false)
            addLuaSprite('splashDOWN', true)
            runTimer('splashGoneDown', 0.2, 1)
        end
        if direction == 2 and isSustainNote == false then
            makeAnimatedLuaSprite('splashUP', 'noteSplashesUP', 575, 723)
            addAnimationByPrefix('splashUP', 'toTheUp', 'noteSplashes 000', 24, false)
            addLuaSprite('splashUP', true)
            runTimer('splashGoneUp', 0.2, 1)
        end
        if direction == 3 and isSustainNote == false then
            makeAnimatedLuaSprite('splashRIGHT', 'noteSplashesRIGHT', 684, 723)
            addAnimationByPrefix('splashRIGHT', 'toTheRight', 'noteSplashes 000', 24, false)
            addLuaSprite('splashRIGHT', true)
            runTimer('splashGoneRight', 0.2, 1)
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    -- regular notesplash timers
	if tag == 'splashGoneLeft' then
		removeLuaSprite('splashLEFT', false)
	end
	if tag == 'splashGoneRight' then
		removeLuaSprite('splashRIGHT', false)
	end
	if tag == 'splashGoneUp' then
		removeLuaSprite('splashUP', false)
	end
	if tag == 'splashGoneDown' then
		removeLuaSprite('splashDOWN', false)
	end


    if tag == 'come1' then
        doTweenAlpha('comeOn1', 'warning1', 1, 1.3, 'linear')
    end
    if tag == 'go1' then
        doTweenAlpha('goOff1', 'warning1', 0, 1.8, 'linear')
    end

    if tag == 'come2' then
        doTweenAlpha('comeOn2', 'warning2', 1, 1.6, 'linear')
    end
    if tag == 'go2' then
        doTweenAlpha('goOff2', 'warning2', 0, 2.3, 'linear')
    end


    if tag == 'startDialogue' then
        startDialogue('dialogue', '');
    end
    if tag == 'startDialogueBeepBop' then
        startDialogue('dialogueBeepBop', '');
    end
    if tag == 'startDialogueEnd' then
        startDialogue('dialogueEnd', '');
    end
    if tag == 'startDialogueBadEnd' then
        startDialogue('dialogueBadEnd', '');
    end
   
    -- for the fake score "zoom"
    if tag == 'hited' then
       --setTextSize('fakeScore', 19)
        setProperty('fakeScore.scale.x', 1)
        setProperty('fakeScore.scale.y', 1)
    end
end

function onTweenCompleted(tag)
    if tag == 'noPerfect:(' then
        setTextColor('resist', '0xffffff')
    end
end


function onUpdate(elapsed)

    -- you lost the undo privilages

    --if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.L') then
    --    addMisses(1)
    --end

    -- haha stuff
    if inGameOver then
        playSound('HA_HA')
        close(true)
    end

    -- part o' f up counter
    -- hard
    local var oops = 3
    local var hoops = 0
    
    --AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    if mustHitSection == true then
        setProperty('resist.scale.x', getProperty('iconP1.scale.x'))
        setProperty('resist.scale.y', getProperty('iconP1.scale.y'))
    elseif mustHitSection == false then
        setProperty('control.scale.x', getProperty('iconP1.scale.x'))
        setProperty('control.scale.y', getProperty('iconP1.scale.y'))
    end
    --AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

    if getProperty('songMisses') == 1 then
        oops = 2
        hoops = 1
        doTweenColor('noPerfect:(', 'resist', 'ffffff', 0.1, 'linear')
    end
    if getProperty('songMisses') == 2 then
        oops = 1
        hoops = 2
    end
    if getProperty('songMisses') == 3 then
        oops = 0
        hoops = 3  
        setTextColor('resist', 'ff0000');
        setPropertyFromClass("openfl.Lib","application.window.title", "Bals, Testicles")
    end
    if getProperty('songMisses') > 3 then
        oops = 0
        hoops = 3
    end

    -- resist counter
    setTextString('resist', 'Resistance: ' .. oops)
    setTextString('control', 'Control: ' .. hoops)

    -- fake score counter
    scorin = getProperty('songScore')
    ratin = getProperty('ratingFC')

    if ratin == '' then
        setTextString('fakeScore', 'Score: ' .. scorin .. ' - ?')
    else
        setTextString('fakeScore', 'Score: ' .. scorin .. ' - ' .. ratin)
    end
    
    if getProperty('ratingFC') == 'SFC' then
        doTweenColor('fakeColorSick', 'fakeScore', '36eaf7', 0.001, 'linear'); 
    elseif getProperty('ratingFC') == 'GFC' then
        doTweenColor('fakeColorGood', 'fakeScore', '90ee90', 0.2, 'linear'); 
    elseif getProperty('ratingFC') == 'FC' then
        doTweenColor('fakeScoreFC', 'fakeScore', 'fffecb', 0.2, 'linear'); 
    else
        doTweenColor('fakeScoreOops', 'fakeScore', 'ffffff', 0.2, 'linear');
    end

    -- icon fading shit
    if curBeat % 2 == 1 and getProperty('health') <= 1.7 and curBeat <= 329 then 
        doTweenAlpha('areYouFading?Tween', 'iconP1', 0.6, 0.3, 'linear')

    elseif curBeat % 2 == 0 and getProperty('health') <= 1.7 and curBeat <= 329 then
        doTweenAlpha('areYouNotFading?Tween', 'iconP1', 0.9, 0.3, 'linear')

    elseif curBeat % 2 == 1 and getProperty('health') <= 0.29 and curBeat <= 329 then
        doTweenAlpha('ohShitTween', 'iconP1', 0.1, 0.1, 'linear')

    elseif curBeat % 2 == 0 and getProperty('health') <= 0.29 and curBeat <= 329 then
        doTweenAlpha('ohShitFuckTween', 'iconP1', 0.4, 0.1, 'linear')

    elseif curBeat % 2 == 1 and getProperty('health') >= 1.8 and curBeat <= 329 then
        doTweenAlpha('nahWeGooTween', 'iconP1', 0.8, 0.3, 'linear')

    elseif curBeat % 2 == 0 and getProperty('health') >= 1.8 and curBeat <= 329 then
        doTweenAlpha('nahWeGoo2Tween', 'iconP1', 1, 0.3, 'linear')
    end

    -- makes sure icon is solid 
    if curBeat == 330 then
        setProperty('iconP1.alpha', tonumber(1))
    end

    -- flickering oops
    if oops == 2 then
        if curBeat % 2 == 0 then
            setTextColor('resist', 'ff0000');
        end
        if curBeat % 2 == 1 then
            setTextColor('resist', '0xffffff')
        end
    end 
    if oops == 1 then
        if curStep % 2 == 0 then
            setTextColor('resist', 'ff0000');
        end
        if curStep % 2 == 1 then
            setTextColor('resist', '0xffffff')
        end
    end

    
    if curStep == 912 then
        triggerEvent('Change Scroll Speed', '1.2', '0')
    end
end


function onBeatHit()

    if curBeat == 35 then
        characterPlayAnim('boyfriend', 'hurt')
        setProperty('health', 1)
        doTweenAlpha('itsHere', 'control', 1, 0.5, 'linear')
        setProperty('boyfriend.stunned', true)
    end
end


--local sleepyMeter = 0
-- (not as) long function time
function onStepHit()

    if playedThrough == false then
        if curStep == 8 then
            runTimer('come1', 1, 1);
        elseif curStep == 45 then
            runTimer('go1', 1, 1);
        end

        if curStep == 11 then
            runTimer('come2', 1, 1);
        elseif curStep == 47 then
            runTimer('go2', 1, 1);
        end
    end

  --[[  if sleepTime == true then
        if keyJustPressed('space') then
            sleepyMeter = sleepyMeter - 0.1
            if sleepyMeter ~= 0 then
                runTimer('sleepCheck', 0.3, 1)
            end
        end
    end]]

    if curStep == 12 then

        if getPropertyFromClass('ClientPrefs', 'middleScroll') == true then
            -- middle scroll on
            noteTweenX("Mdx5", 0, 410, 16, "quartInOut");
            noteTweenAngle("Mdr5", 0, 360, 16, "quartInOut");
            noteTweenAlpha("Mdo5", 0, 0.5, 0.4,"quartInOut");
            noteTweenX("Mdx6", 1, 522, 16, "quartInOut");
            noteTweenAngle("Mdr6", 1, 360, 16, "quartInOut");
            noteTweenAlpha("Mdo6", 1, 0.5, 0.4, "quartInOut");
            noteTweenX("Mdx7", 2, 633, 16, "quartInOut");
            noteTweenAngle("Mdr7", 2, -360, 16, "quartInOut");
            noteTweenAlpha("Mdo7", 2, 0.5, 0.4, "quartInOut");
            noteTweenX("Mdx8", 3, 745, 16, "quartInOut");
            noteTweenAngle("Mdr8", 3, -360, 16, "quartInOut");
            noteTweenAlpha("Mdo8", 3, 0.5, 0.4, "quartInOut");
        end
        if getPropertyFromClass('ClientPrefs', 'middleScroll') == false then
                    -- your? note 1
            noteTweenX("x5", 0, 410, 16, "quartInOut");
            noteTweenAngle("r5", 0, 360, 16, "quartInOut");
            noteTweenAlpha("o5", 0, 0.5, 0.4,"quartInOut");
                    -- your? note 2
            noteTweenX("x6", 1, 522, 16, "quartInOut");
            noteTweenAngle("r6", 1, 360, 16, "quartInOut");
            noteTweenAlpha("o6", 1, 0.5, 0.4, "quartInOut");
                    -- your? note 3
            noteTweenX("x7", 2, 633, 16, "quartInOut");
            noteTweenAngle("r7", 2, 360, 16, "quartInOut");
            noteTweenAlpha("o7", 2, 0.5, 0.4, "quartInOut");
                    -- your? note 4
            noteTweenX("x8", 3, 745, 16, "quartInOut");
            noteTweenAngle("r8", 3, 360, 16, "quartInOut");
            noteTweenAlpha("o8", 3, 0.5, 0.4, "quartInOut");
                    -- !your note 1
            noteTweenX("Mx5", 4, 410, 16, "quartInOut");
            noteTweenAngle("Mr5", 4, 360, 16, "quartInOut");
            noteTweenAlpha("Mo5", 4, 1, 16,"quartInOut");
                    -- !your note 2
            noteTweenX("Mx6", 5, 522, 16, "quartInOut");
            noteTweenAngle("Mr6", 5, 360, 16, "quartInOut");
            noteTweenAlpha("Mo6", 5, 1, 16, "quartInOut");
                    -- !your note 3
            noteTweenX("Mx7", 6, 633, 16, "quartInOut");
            noteTweenAngle("Mr7", 6, 360, 16, "quartInOut");
            noteTweenAlpha("Mo7", 6, 1, 16, "quartInOut");
                    -- !your note 4
            noteTweenX("Mx8", 7, 745, 16, "quartInOut");
            noteTweenAngle("Mr8", 7, 360, 16, "quartInOut");
            noteTweenAlpha("Mo8", 7, 1, 16, "quartInOut");
        end
    end
    
    -- trolling sections
    if playedThrough == false then
        if curStep == 144 then
            
        end
        if curStep == 176 then
            
        end
        if curStep == 208 then
            
        end
        if curStep == 260 then
            -- 272
        end
        if curStep == 272 then
            
        end
        if curStep == 388 then
            -- 400
        end

        -- duel section
        if curStep == 400 then
            
        end
        if curStep >= 400 and curStep <= 655 and mustHitSection == false then
            
        end
        -- duel section ends here

        if curStep == 656 then
          
        end
        if curStep == 720 then
            
        end
        if curStep == 784 then
           
        end
        if curStep == 848 then
            
        end
        if curStep == 912 then
            
        end
        if curStep == 944 then
            
        end
        if curStep == 976 then
           
        end
        if curStep == 1008 then
            
        end
        if curStep == 1040 then
            
        end
        if curStep == 1104 then
            
        end
        if curStep == 1168 then
            
        end
        if curStep == 1232 then
            
        end
        if curStep == 1296 then
            
        end
    end

    if playedThrough == false then
        if curStep == 144 then
            swapTurnWatch();
        end
        if curStep == 176 then
            swapTurnPlay();
        end
        if curStep == 208 then
            swapTurnWatch();
        end
        if curStep == 240 then
            swapTurnPlay();
        end
        if curStep == 272 then
            swapTurnWatch();
        end
        if curStep == 336 then
            swapTurnPlay();
        end

        -- duel section
        if curStep == 400 then
            makeLuaSprite('ballOver', 'balls_overlay', -15, 200)
            addLuaSprite('ballOver', true)
            triggerEvent('Change Character', '0', 'bfYOUGHOST')
            setProperty('gf.alpha', tonumber(1))
            triggerEvent('Change Character', '1', 'bf@NOTYOUGHOST')
            cameraFlash('game', '0xFFFFFF', 0.5, true)
            setProperty('boyfriend.alpha', tonumber(0.6))
            setProperty('dad.alpha', tonumber(0.6))
        end
        if curStep >= 400 and curStep <= 655 and mustHitSection == false then
            setProperty('health', 0.15)
        end
        -- duel section ends here

        if curStep == 656 then
            removeLuaSprite('ballOver', true)
            setProperty('health', 1)
            setProperty('gf.alpha', tonumber(0))
            swapTurnWatch();
        end
        if curStep == 720 then
            swapTurnPlay();
        end
        if curStep == 784 then
            swapTurnWatch();
        end
        if curStep == 848 then
            swapTurnPlay();
        end
        if curStep == 912 then
            swapTurnWatch();
        end
        if curStep == 944 then
            swapTurnPlay();
        end
        if curStep == 976 then
            swapTurnWatch();
        end
        if curStep == 1008 then
            swapTurnPlay();
        end
        if curStep == 1040 then
            swapTurnWatch();
        end
        if curStep == 1104 then
            swapTurnPlay();
        end
        if curStep == 1168 then
            swapTurnWatch();
        end
        if curStep == 1232 then
            swapTurnPlay();
        end
        if curStep == 1296 then
            swapTurnWatch();
        end

        -- Hard Victory anim -- yeesh
        if curStep >= 1315 and getProperty('songMisses') < 3 then
            if curStep == 1316 then
                characterPlayAnim('boyfriend', 'singRIGHT', true) -- ooh
            end
            if curStep == 1318 then
                characterPlayAnim('boyfriend', 'singUP', true) -- yeah
            end
            if curStep == 1320 then
                characterPlayAnim('boyfriend', 'pre-attack', true) -- a
            end
            if curStep == 1322 then
                characterPlayAnim('boyfriend', 'singRIGHT', true) -- ha
            end
            if curStep == 1323 then
                characterPlayAnim('boyfriend', 'singUP', true) -- a
            end
            if curStep == 1325 then
                characterPlayAnim('boyfriend', 'pre-attack', true) -- ha
            end
            if curStep == 1326 then
                characterPlayAnim('boyfriend', 'attack', true) -- a!
            end

        elseif curStep >= 1315 and getProperty('songMisses') >= 3 then
            if curStep == 1316 then
                characterPlayAnim('boyfriend', 'singRIGHTmiss', true) -- ooh
            end
            if curStep == 1318 then
                characterPlayAnim('boyfriend', 'singUPmiss', true) -- nah
            end
            if curStep == 1320 then
                characterPlayAnim('boyfriend', 'singDOWNmiss', true) -- o
            end
            if curStep == 1322 then
                characterPlayAnim('boyfriend', 'singRIGHTmiss', true) -- oh
            end
            if curStep == 1323 then
                characterPlayAnim('boyfriend', 'singUPmiss', true) -- o
            end
            if curStep == 1325 then
                characterPlayAnim('boyfriend', 'singDOWNmiss', true) -- oh
            end
            if curStep == 1326 then
                characterPlayAnim('boyfriend', 'singUPmiss', true) -- o
            end
        end

        if curStep == 1328 then
            -- Ending stuff
            if getProperty('songMisses') < 3  then
                goodEnd();
                removeLuaText('warning1', true)
                removeLuaText('warning2', true)
                -- prevent the stuff from poppin up again in the dialogue
                playedThrough = true
            elseif getProperty('songMisses') >= 3 then
                badEnd();
                addLuaText("Lost");
                removeLuaText('warning1', true)
                removeLuaText('warning2', true)
            end
        end
        if curStep == 1333 and getProperty('songMisses') >= 3 then
            characterPlayAnim('dad', 'singRIGHT', true)
            playSound('HA_HA')
            playedThrough = true
        end
    end
end

-- clean up clean up he hey
function swapTurnPlay()
    triggerEvent('Change Character', '0', 'bfYOU')
    triggerEvent('Change Character', '1', 'bf@NOTYOUGHOST')
    setProperty('boyfriend.alpha', tonumber(1))
    setProperty('dad.alpha', tonumber(0.5))
    cameraFlash('game', '0xFFFFFF', 0.5, true)
end

function swapTurnWatch()
    triggerEvent('Change Character', '0', 'bfYOUGHOST')
    triggerEvent('Change Character', '1', 'bf@NOTYOU')
    setProperty('boyfriend.alpha', tonumber(0.5))
    setProperty('dad.alpha', tonumber(1))
    cameraFlash('game', '0xFFFFFF', 0.5, true)
end

function goodEnd()
    triggerEvent('Change Character', '0', 'bf')
    triggerEvent('Change Character', '1', 'bf@NOTYOUGHOST')
    setProperty('boyfriend.alpha', tonumber(1))
    doTweenAlpha('youWon', 'dad', 0, 0.9, 'linear')
    cameraFlash('game', '0xFFFFFF', 0.5, true)
    -- these alphaTweens hide the stupid little counter and prevent it from showing in the dialogue
    doTweenAlpha('noNeedForThis', 'resist', 0, 0.9, 'linear')
    doTweenAlpha('controlNoMo', 'control', 0, 0.9, 'linear')
    characterPlayAnim('boyfriend', 'hey', true)
    setProperty('health', 2)
end

function badEnd()
    setProperty('health', 0.01)
    playSound('deathGrunt')
    doTweenAlpha('noNeedForThis', 'resist', 0, 0.9, 'linear')
    doTweenAlpha('controlNoMo', 'control', 0, 0.9, 'linear')
    characterPlayAnim('boyfriend', 'hurt', true)
    doTweenAlpha('boyfriendlostTween', 'boyfriend', 0, 0.5, 'linear')
end