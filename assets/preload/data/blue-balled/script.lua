local allowCountdown = false
local startedEndDialogue = false
-- this var is to prevent the shit from happening again in the dialogue
local playedThrough = false

function onEndSong()
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
    if difficulty >= 1 then
        if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
            makeLuaText("resist", 'Resistance: 0', 200, 940, 77);
        else
            makeLuaText("resist", 'Resistance: 0', 200, 940, 639);
        end
    else 
        if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
            makeLuaText("resist", 'Resistance? : 0', 200, 940, 77);
        else
            makeLuaText("resist", 'Resistance? : 0', 200, 940, 639);
        end
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

    -- this is the bad ending text
    if difficulty == 0 then
        makeLuaText("Lost", 'LOSER', 1000, screenWidth / 2 - 500, screenHeight / 2 - 50);
    else
        makeLuaText("Lost", 'LOSER', 1000, screenWidth / 2 - 100, screenHeight / 2);
    end
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

    if difficulty == 2 then
        -- part 1
        makeLuaText('warning1', "5 Misses.", 500, screenWidth / 2 - 250, screenHeight / 2 - 50);
        setObjectCamera("warning1", 'other');
        setTextColor('warning1', '0xff0000')
        setTextSize('warning1', 20);
        addLuaText("warning1");
        setProperty('warning1.alpha', tonumber(0))
        setTextFont('warning1', "vcr.ttf");
        setTextAlignment('warning1', 'center');

        -- part 2
        makeLuaText('warning2', "That's the limit. Don't mess up.", 500, screenWidth / 2 - 250, screenHeight / 2);
        setObjectCamera("warning2", 'other');
        setTextColor('warning2', '0xffffff')
        setTextSize('warning2', 20);
        addLuaText("warning2");
        setProperty('warning2.alpha', tonumber(0))
        setTextFont('warning2', "vcr.ttf")
        setTextAlignment('warning2', 'center')
    end

    if difficulty == 1 then 
        -- part 1
        makeLuaText('warning1', "2 Misses.", 500, screenWidth / 2 - 250, screenHeight / 2 - 50);
        setObjectCamera("warning1", 'other');
        setTextColor('warning1', '0xff0000')
        setTextSize('warning1', 20);
        addLuaText("warning1");
        setProperty('warning1.alpha', tonumber(0))
        setTextFont('warning1', "vcr.ttf");
        setTextAlignment('warning1', 'center');

        -- part 2
        makeLuaText('warning2', "That's the limit. Don't mess up.", 500, screenWidth / 2 - 250, screenHeight / 2);
        setObjectCamera("warning2", 'other');
        setTextColor('warning2', '0xffffff')
        setTextSize('warning2', 20);
        addLuaText("warning2");
        setProperty('warning2.alpha', tonumber(0))
        setTextFont('warning2', "vcr.ttf")
        setTextAlignment('warning2', 'center')
    end

    if difficulty == 0 then
       -- part 1
       makeLuaText('warning1', "5 Misses. That's the --", 500, screenWidth / 2 - 250, screenHeight / 2 - 50);
       setObjectCamera("warning1", 'other');
       setTextColor('warning1', '0xff0000')
       setTextSize('warning1', 20);
       addLuaText("warning1");
       setProperty('warning1.alpha', tonumber(0))
       setTextFont('warning1', "vcr.ttf");
       setTextAlignment('warning1', 'center');

       -- part 2
       makeLuaText('warning2', "Actually, no point. You lost anyways.", 500, screenWidth / 2 - 250, screenHeight / 2);
       setObjectCamera("warning2", 'other');
       setTextColor('warning2', '0xffffff')
       setTextSize('warning2', 20);
       addLuaText("warning2");
       setProperty('warning2.alpha', tonumber(0))
       setTextFont('warning2', "vcr.ttf")
       setTextAlignment('warning2', 'center')
    end
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
    if tag == 'startDialogueEnd' then
        startDialogue('dialogueEnd', '');
    end
    if tag == 'startDialogueBadEnd' then
        startDialogue('dialogueBadEnd', '');
    end
    if tag == 'failfail' then
        playSound('HAHA')
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

    -- eww middlescroll change it back please
    if curStep >= 128 then
        if keyJustPressed("space") then
            noteTweenX("UMx5", 4, defaultPlayerStrumX0, 1, "quartInOut");
            noteTweenX("UMx6", 5, defaultPlayerStrumX1, 1, "quartInOut");
            noteTweenX("UMx7", 6, defaultPlayerStrumX2, 1, "quartInOut");
            noteTweenX("UMx8", 7, defaultPlayerStrumX3, 1, "quartInOut"); 
            noteTweenX("UOMx0", 0, defaultOpponentStrumX0, 1, "quartInOut");
            noteTweenX("UOMx1", 1, defaultOpponentStrumX1, 1, "quartInOut");
            noteTweenX("UOMx2", 2, defaultOpponentStrumX2, 1, "quartInOut");
            noteTweenX("UOMx3", 3, defaultOpponentStrumX3, 1, "quartInOut");
            undo = true
        end 
    end

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
    local var oopsH = 5
    local var hoopsH = 0
    
    --AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA Beat Shit
    if mustHitSection == true then
        setProperty('resist.scale.x', getProperty('iconP1.scale.x'))
        setProperty('resist.scale.y', getProperty('iconP1.scale.y'))
    elseif mustHitSection == false then
        setProperty('control.scale.x', getProperty('iconP1.scale.x'))
        setProperty('control.scale.y', getProperty('iconP1.scale.y'))
    end
    --AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA Beat Shit

    if getProperty('songMisses') == 1 and difficulty == 2 then
        oopsH = 4
        hoopsH = 1
        doTweenColor('noPerfect:(', 'resist', 'ffffff', 0.1, 'linear')
    end
    if getProperty('songMisses') == 2 and difficulty == 2 then
        oopsH = 3
        hoopsH = 2
    end
    if getProperty('songMisses') == 3 and difficulty == 2 then
        oopsH = 2
        hoopsH = 3
    end
    if getProperty('songMisses') == 4 and difficulty == 2 then
        oopsH = 1
        hoopsH = 4
    end
    if getProperty('songMisses') == 5 and difficulty == 2 then
        oopsH = 0
        hoopsH = 5
        setTextColor('resist', 'ff0000');
        setPropertyFromClass("openfl.Lib","application.window.title", "HAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHA")
    end
    if getProperty('songMisses') > 5 and difficulty == 2 then
        oopsH = 0
        hoopsH = 5
    end

    -- normal
    local var hoopsN = 3
    local var oopsN = 2
    if getProperty('songMisses') == 1 and difficulty == 1 then
        oopsN = 1
        hoopsN = 4
        doTweenColor('noPerfect:(', 'resist', 'ffffff', 0.2, 'linear')
        --setTextColor('resist', '0xffffff')
    end
    if getProperty('songMisses') == 2 and difficulty == 1 then
        oopsN = 0
        hoopsN = 5
        setTextColor('resist', 'ff0000');
        setPropertyFromClass("openfl.Lib","application.window.title", "HAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHA")
    end
    if getProperty('songMisses') > 2 and difficulty == 1 then
        oopsN = 0
        hoopsN = 5
        setTextColor('resist', 'ff0000');
    end

    -- resist counters
    if difficulty == 2 then
        setTextString('resist', 'Resistance: ' .. oopsH)
        setTextString('control', 'Control: ' .. hoopsH)
    end
    if difficulty == 1 then
        setTextString('resist', 'Resistance: ' .. oopsN)
        setTextString('control', 'Control: ' .. hoopsN)
    end

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

    -- I think this makes the thing happen
    --[[if mustHitSection == true and curStep >= 128 and curStep < 329 then
        setObjectCamera("resist", 'other')
        setObjectCamera("control", 'hud')
    elseif mustHitSection == false and curStep >= 128 and curStep < 329 then
        setObjectCamera("resist", 'hud')
        setObjectCamera("control", 'other')
    end]]

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
    if oopsH == 2 then
        if curBeat % 2 == 0 then
            setTextColor('resist', 'ff0000');
        end
        if curBeat % 2 == 1 then
            setTextColor('resist', '0xffffff')
        end
    end 
    if oopsH == 1 or oopsN == 1 then
        if curStep % 2 == 0 then
            setTextColor('resist', 'ff0000');
        end
        if curStep % 2 == 1 then
            setTextColor('resist', '0xffffff')
        end
    end
    
    -- still unsure if this does anything to difficulties
    if curStep == 896 and difficulty == 2 then
        triggerEvent('Change Scroll Speed', '1.2', '0')
    end
    if curStep == 896 and difficulty == 1 then
        triggerEvent('Change Scroll Speed', '1.1', '0')
    end
    if curStep == 896 and difficulty == 0 then
        triggerEvent('Change Scroll Speed', '1', '0')
    end
end


function onBeatHit()

    if curBeat == 31 then
        characterPlayAnim('boyfriend', 'hurt')
        setProperty('health', 1)
        doTweenAlpha('itsHere', 'control', 1, 0.5, 'linear')
    end
end


-- (not as) long function time
function onStepHit()

    local didIt = false
    if curStep == 3 and didIt == false then
        runTimer('come1', 1, 1);
    elseif curStep == 40 then
        runTimer('go1', 1, 1);
    end
    if curStep == 6 and didIt == false then
        runTimer('come2', 1, 1);
    elseif curStep == 42 then
        runTimer('go2', 1, 1);
        didIt = true
    end

    if difficulty == 0 and curStep >= 20 then
        -- this might be taxing to do, not sure (It's better than onUpdate though, shit chugged like a train)
        local ran1 = math.random(1,9)
        local ran2 = math.random(1,9)
        local ran3 = math.random(1,9)
        setTextString('resist', '*%&Y^@@$: '.. ran1 .. ran2 .. ran3)
        setTextString('control', 'Control: HAHA')
    end

    if curStep == 1 then
        
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
    
    if playedThrough == false then
        if curStep == 128 then
            swapTurnWatch();
        end
        if curStep == 160 then
            swapTurnPlay();
        end
        if curStep == 192 then
            swapTurnWatch();
        end
        if curStep == 224 then
            swapTurnPlay();
        end
        if curStep == 256 then
            swapTurnWatch();
        end
        if curStep == 320 then
            swapTurnPlay();
        end

        -- duel section a step after here
        if curStep == 383 then
            makeLuaSprite('ballOver', 'balls_overlay', -15, 200)
            addLuaSprite('ballOver', true)
            triggerEvent('Change Character', '0', 'bfYOUGHOST')
            setProperty('gf.alpha', tonumber(1))
            triggerEvent('Change Character', '1', 'bf@NOTYOUGHOST')
            cameraFlash('game', '0xFFFFFF', 0.5, true)
            setProperty('boyfriend.alpha', tonumber(0.6))
            setProperty('dad.alpha', tonumber(0.6))
        end
        if curStep >= 383 and curStep <= 639 and mustHitSection == false then
            setProperty('health', 0.15)
        end
        -- duel section ends here

        if curStep == 640 then
            removeLuaSprite('ballOver', true)
            setProperty('health', 1)
            setProperty('gf.alpha', tonumber(0))
            swapTurnWatch();
        end
        if curStep == 704 then
            swapTurnPlay();
        end
        if curStep == 768 then
            swapTurnWatch();
        end
        if curStep == 832 then
            swapTurnPlay();
        end
        if curStep == 896 then
            swapTurnWatch();
        end
        if curStep == 928 then
            swapTurnPlay();
        end
        if curStep == 960 then
            swapTurnWatch();
        end
        if curStep == 992 then
            swapTurnPlay();
        end
        if curStep == 1024 then
            swapTurnWatch();
        end
        if curStep == 1088 then
            swapTurnPlay();
        end
        if curStep == 1152 then
            swapTurnWatch();
        end
        if curStep == 1216 then
            swapTurnPlay();
        end
        if curStep == 1280 then
            swapTurnWatch();
        end

        -- Hard Victory anim
        if curStep == 1304 and getProperty('songMisses') < 5 and difficulty == 2 then
            characterPlayAnim('boyfriend', 'singRIGHT', true) -- ooh
        end
        if curStep == 1306 and getProperty('songMisses') < 5 and difficulty == 2 then
            characterPlayAnim('boyfriend', 'singUP', true) -- yeah
        end
        if curStep == 1308 and getProperty('songMisses') < 5 and difficulty == 2 then
            characterPlayAnim('boyfriend', 'pre-attack', true) -- ha
        end
        if curStep == 1310 and getProperty('songMisses') < 5 and difficulty == 2 then
            characterPlayAnim('boyfriend', 'attack', true) -- ha!
        elseif curStep == 1304 and getProperty('songMisses') >= 5 and difficulty == 2 then
            characterPlayAnim('boyfriend', 'singRIGHTmiss', true) -- ooh
        end
        if curStep == 1306 and getProperty('songMisses') >= 5 and difficulty == 2 then
            characterPlayAnim('boyfriend', 'singUPmiss', true) -- nah
        end
        if curStep == 1308 and getProperty('songMisses') >= 5 and difficulty == 2 then
            characterPlayAnim('boyfriend', 'singLEFTmiss', true) --uh
        end
        if curStep == 1310 and getProperty('songMisses') >= 5 and difficulty == 2 then
            characterPlayAnim('boyfriend', 'singDOWNmiss', true) -- oh
        end

        if curStep == 1304 and getProperty('songMisses') <= 2 and difficulty == 1 then
            characterPlayAnim('boyfriend', 'singRIGHT', true) -- ooh
        end
        if curStep == 1306 and getProperty('songMisses') <= 2 and difficulty == 1 then
            characterPlayAnim('boyfriend', 'singUP', true) -- yeah
        end
        if curStep == 1308 and getProperty('songMisses') <= 2 and difficulty == 1 then
            characterPlayAnim('boyfriend', 'pre-attack', true) -- ha
        end
        if curStep == 1310 and getProperty('songMisses') <= 2 and difficulty == 1 then
            characterPlayAnim('boyfriend', 'attack', true) -- ha!
        end

        if curStep == 1313 then
            -- Ending stuff (Hard and easy)
            if getProperty('songMisses') < 5 and difficulty == 2 then
                goodEnd();
                removeLuaText('warning1', true)
                removeLuaText('warning2', true)
                -- prevent the stuff from poppin up again in the dialogue
                playedThrough = true
            elseif getProperty('songMisses') >= 5 or difficulty == 0 then
                badEnd();
                addLuaText("Lost");
                removeLuaText('warning1', true)
                removeLuaText('warning2', true)
                if difficulty == 0 then
                    setTextString('Lost', "YOU DIDN'T EVEN TRY")
                end
            end
            -- Ending stuff (Normal)
            if getProperty('songMisses') <= 2 and difficulty == 1 then
                goodEnd();
                removeLuaText('warning1', true)
                removeLuaText('warning2', true)
                playedThrough = true
            elseif getProperty('songMisses') > 2 and difficulty == 1 then
                badEnd();
                removeLuaText('warning1', true)
                removeLuaText('warning2', true)
            end
        end
        if curStep == 1319 and getProperty('songMisses') >= 5 or curStep == 1319 and difficulty == 0 then
            characterPlayAnim('dad', 'singRIGHT', true)
            playSound('HA_HA')
            playedThrough = true
        end
        if curStep == 1319 and getProperty('songMisses') > 2 and difficulty == 1 then
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