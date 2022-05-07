local allowCountdown = false
function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and isStoryMode and not seenCutscene then
		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.8);
		allowCountdown = true;
		return Function_Stop;
	end

	return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue', '');
	end
    
    if tag == 'awayNow' then
        fadeOutText();
    end
end

function onCreate()
    -- icon
    setProperty('iconP1.visible', false)
    makeLuaSprite('fakeBFIcon', 'icons/icon-b..', 900, 580)
    setObjectCamera('fakeBFIcon', 'hud')
	addLuaSprite('fakeBFIcon', true)
	setProperty('fakeBFIcon.flipX', true)
    addLuaSprite('fakeBFIcon', true)

    -- cache money baby
    setProperty('scoreTxt.alpha', tonumber(0))
    triggerEvent('Camera Follow Pos', '', '')
    precacheImage('noteSplashesRIGHT')
    precacheImage('noteSplashesLEFT')
    precacheImage('noteSplashesDOWN')
    precacheImage('noteSplashesUP')
    precacheImage('balls_overlay')
    addCharacterToList('daaddy1', 'dad')
    addCharacterToList('daaddy2', 'dad')
    addCharacterToList('daaddy3', 'dad')
    addCharacterToList('ggf1', 'gf')
    addCharacterToList('ggf2', 'gf')
    addCharacterToList('ggf3', 'gf')
    addCharacterToList('bf@ITSYOU', 'dad')

    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        makeLuaText("fakeScore", 'Score: 0', 300, 650, 36);
    else
        makeLuaText("fakeScore", 'Score: 0', 300, 650, 670);
    end
    setObjectCamera("fakeScore", 'hud');
    setTextColor('fakeScore', '0xffffff')
    setTextSize('fakeScore', 19);
    addLuaText("fakeScore");
    setTextFont('fakeScore', 'vcr.ttf')
    setTextAlignment('fakeScore', 'center')

    setProperty('boyfriend.visible', false)
    makeLuaSprite('beep', 'BOYFRIEND...', 815, 455)
    setObjectOrder('beep', 100)
    addLuaSprite('beep', true)

    -- think stuff
    makeLuaText("Thinking", 'blankety blank', 600,  screenWidth / 2 - 300, screenHeight / 2);
    setObjectCamera("Thinking", 'other');
    setTextColor('Thinking', '0xffffff');
    addLuaText('Thinking');
    setTextSize('Thinking', 26);
    setTextFont('Thinking', 'vcr.ttf');
    setTextAlignment('Thinking', 'center');
    setProperty('Thinking.alpha', tonumber(0))

    makeLuaSprite('thinkOverlay', 'balls_overlay', 0, 0)
    setObjectCamera('thinkOverlay', 'camHud')
    addLuaSprite('thinkOverlay', true)
    setProperty('thinkOverlay.alpha', tonumber(0))
end

local scorin = 0
function onUpdate(elapsed)
    -- step 249 is around the weird point //note to self

    -- should prevent you from dying (if you don't try, that is)
    if getProperty('health') <= 0.1 then
        setProperty('health', 2) 
    end

    if scorin == 0 then
        setTextString('fakeScore', 'Score: ' .. scorin .. ' - ?')
    else
        -- that's right bitch it's always a SFC
        setTextString('fakeScore', 'Score: ' .. scorin .. ' - ' .. 'SFC')
    end

    if curStep == 523 then
        scorin = 0
    end
    
    if mustHitSection == true and curBeat > 64 and curBeat < 135 then
        setProperty('defaultCamZoom', tonumber(1.2))
    elseif  mustHitSection == false and curBeat < 135 then
        setProperty('defaultCamZoom', tonumber(0.9))
    end
    if curBeat == 135 then
        triggerEvent('Camera Follow Pos', '700', '500')
        setProperty('defaultCamZoom', tonumber(0.8))
    end
end

function onStepHit()
    --character change times
    --[[== 256
        == 298
        == 352
        == 392
        == 448
        == 523 -- original]]

    if curStep == 256 then
        triggerEvent('Change Character', '1', 'daadd1')
        triggerEvent('Change Character', '2', 'ggf1')
    end
    if curStep == 298 then
        triggerEvent('Change Character', '1', 'daadd2')
        triggerEvent('Change Character', '2', 'ggf2')
    end
    if curStep == 352 then
        triggerEvent('Change Character', '1', 'daadd1')
        triggerEvent('Change Character', '2', 'ggf1')
    end
    if curStep == 392 then
        triggerEvent('Change Character', '1', 'daadd2')
        triggerEvent('Change Character', '2', 'ggf2')
    end
    if curStep == 448 then
        triggerEvent('Change Character', '1', 'daadd3')
        triggerEvent('Change Character', '2', 'ggf3')
    end
    if curStep == 523 then
        setProperty('health', 1)
        triggerEvent('Change Character', '1', 'daadd')
        triggerEvent('Change Character', '2', 'ggf')
    end

end

function onBeatHit()
    if mustHitSection == true then
        setProperty('health', getProperty('health')+ 0.020)
        scorin = scorin + addTaScore()
    else
        setProperty('health', getProperty('health')+ 0.005)
    end

    -- text times
    if curBeat == 4 then
        setTextString('Thinking', "Another round.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 12 then
        setTextString('Thinking', "It gets a bit tiring after the...")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 15 then
        setTextString('Thinking', "How ever many times you've done this.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 19 then
        setTextString('Thinking', "Stopped keeping track after... the 50th round or so.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 24 then
        setTextString('Thinking', "It seemed relatively fun at first.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 31 then
        setTextString('Thinking', "An endless amount of rap battles, all alongside her again.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 36 then
        setTextString('Thinking', "Just like it used to be. Before all this.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 41 then
        setTextString('Thinking', "Until you eventually realized it would be...")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 46 then
        setTextString('Thinking', "The same one. Over and over and... you can't even lose.") -- minus the reset button dumdum
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 51 then
        setTextString('Thinking', "Well, there's no one to blame for this but yourself.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 58 then
        setTextString('Thinking', "Had you WON that fight that day-")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 68 then
        setTextString('Thinking', "Maybe you could have prevented this.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 75 then
        setTextString('Thinking', "You have all but forgotten the feeling of the sun on your skin.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 79 then
        setTextString('Thinking', "The warm embrace of... anyone, really.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 84 then
        setTextString('Thinking', "Stuck rotting away, in this pitiful prison.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 90 then
        setTextString('Thinking', "No way out, while THEY wreak havoc using YOUR body.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 96 then
        setTextString('Thinking', "If only you could get a...")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 110 then
        setTextString('Thinking', "Alright, what the fuck is going on?")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 120 then
        setTextString('Thinking', "None of this is like normal.")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 137 then
        setTextString('Thinking', "Wait, then is it? Could it finally be...")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 141 then
        setTextString('Thinking', "Something...")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end
    if curBeat == 146 then
        setTextString('Thinking', "New?")
        fadeInText();
        runTimer('awayNow', 2, 1)
    end

    if curBeat == 139 then
        doTweenAlpha('byeDad', 'dad', 0, 1.2, 'linear')
        doTweenAlpha('byeDadIcon', 'iconP2', 0, 1.2, 'linear')
        doTweenAlpha('byeFakeBfIcon', 'fakeBFIcon', 0, 1.2, 'linear')
        doTweenAlpha('byeHp', 'healthBar', 0, 1.2, 'linear')
        doTweenAlpha('byeGf', 'gf', 0, 1.2, 'linear')
        doTweenAlpha('byeScore', 'fakeScore', 0, 1.2, 'linear')

        for i = 0, 3, 1 do
            noteTweenAlpha('fakeFkaes'.. i, i, 0, 1.2, 'linear')
        end
    end
    if curBeat == 145 then
        doTweenAlpha('byeF', 'beep', 0, 0.6, 'linear')
        triggerEvent('Change Character', '1', 'bf@ITSYOU')
        for i = 4, 7, 1 do
            noteTweenAlpha('yourNotes'.. i, i, 0, 1.2, 'linear')
        end
    end
    if curBeat == 147 then
        doTweenAlpha('oneLastRap', 'dad', 0.6, 0.5, 'linear')
    end
    if curBeat == 148 then
        doTweenAlpha('forFun', 'dad', 0, 0.7, 'linear')
    end

end

function addTaScore()
    which = math.random(1, 6)
    if which == 1 then
        return 50
    elseif which == 2 then
        return 200
    elseif which == 3 then
        return 100
    else
        return 350
    end
end

function fadeInText()
    doTweenAlpha('overlayIn', 'thinkOverlay', 1, 0.7, 'circInOut')
    doTweenAlpha('textIn', 'Thinking', 1, 0.9, 'circInOut')
end

function fadeOutText()
    doTweenAlpha('overlayOut', 'thinkOverlay', 0, 0.7, 'circInOut')
    doTweenAlpha('textOut', 'Thinking', 0, 0.6, 'circInOut')
end