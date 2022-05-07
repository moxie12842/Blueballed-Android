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

function onCreate()
    -- gameover thing
    setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-spook');

    setProperty('scoreTxt.alpha', tonumber(0))

    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        makeLuaText("limit", 'Limit: 0', 200, 920, 77);
    else
        makeLuaText("limit", 'Limit: 0', 200, 920, 639);
    end
    setObjectCamera("limit", 'hud');
    setTextColor('limit', '0x36eaf7')
    setTextSize('limit', 20);
    addLuaText("limit");
    setTextFont('limit', "vcr.ttf")
    setTextAlignment('limit', 'center')

    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        makeLuaText("fakeScore", 'Score: 0', 300, 650, 36);
    else
        makeLuaText("fakeScore", 'Score: 0 - ?', 300, 650, 670);
    end
    setObjectCamera("fakeScore", 'hud');
    setTextColor('fakeScore', '0xffffff')
    setTextSize('fakeScore', 18);
    addLuaText("fakeScore");
    setTextFont('fakeScore', "vcr.ttf")
    setTextAlignment('fakeScore', 'center')
end

function onCreatePost()
    makeLuaText('dodgeIt', "They want to share their newfound joy with you.", 600, screenWidth / 2 + 50, screenHeight / 2 - 50);
    setObjectCamera("dodgeIt", 'other');
    setTextColor('dodgeIt', '0xff0000')
    setTextSize('dodgeIt', 20);
    addLuaText("dodgeIt");
    setProperty('dodgeIt.alpha', tonumber(0))
    setTextFont('dodgeIt', "vcr.ttf");
    setTextAlignment('dodgeIt', 'center');

    makeLuaText('youFool', "Hit the arrows to avoid their attempts.", 500, screenWidth / 2 + 100, screenHeight / 2);
    setObjectCamera("youFool", 'other');
    setTextColor('youFool', '0xff0000')
    setTextSize('youFool', 20);
    addLuaText("youFool");
    setProperty('youFool.alpha', tonumber(0))
    setTextFont('youFool', "vcr.ttf")
    setTextAlignment('youFool', 'center')

end    

function onBeatHit()

    if curBeat < 416 and getProperty('boyfriend.curCharacter') ~= 'bf@NOWYOU' then
        local health = getProperty('health')
        if health > 0.32 and health < 1.5 then
            setProperty('health', health- 0.04)
        end
        if health >= 1.5 then
            setProperty('health', health- 0.08)
        end
    end
end

function onUpdate(elapsed)
    
    -- transformation
    if getProperty('songMisses') >= 5 and getProperty('boyfriend.curCharacter') ~= 'bf@NOWYOU' then
        cameraFlash('game', '0xffffff', 0.2)
        triggerEvent('Change Character', 'bf', 'bf@NOWYOU')
    end

    if curBeat >= 425 and getProperty('boyfriend.curCharacter') == 'bf@NOWYOU' then
        playSound('HA_HA')
        setProperty('health', -100)
    end

    if keyJustPressed('space') then
        -- literally useless
        characterPlayAnim('boyfriend', 'hey', true)
        setProperty('boyfriend.specialAnim', true)
    end

    -- hint
    if curStep == 1 then
        runTimer('fadelin1', 1, 1);
    elseif curStep == 30 then
        runTimer('getOut1', 1, 1);
    end
    if curStep == 1 then
        runTimer('fadelin2', 1, 1);
    elseif curStep == 30 then
        runTimer('getOut2', 1, 1);
    end

    --cool
    if curStep == 38 then
        runTimer('cool1', 1, 1);
    elseif curStep == 50 then
        runTimer('coolOut1', 1, 1);
    end
    if curStep == 38 then
        runTimer('cool2', 1, 1);
    elseif curStep == 50 then
        runTimer('coolOut2', 1, 1);
    end

    local var oops = 5
    -- limit counter
    if getProperty('songMisses') == 1 then
        oops = 4
        doTweenColor('noPerfect:(', 'limit', 'ffffff', 0.1, 'linear')
    end
    if getProperty('songMisses') == 2 then
        oops = 3
    end
    if getProperty('songMisses') == 3 then
        oops = 2
    end
    if getProperty('songMisses') == 4 then
        oops = 1
    end
    if getProperty('songMisses') == 5 then
        oops = 0
        setTextColor('limit', 'ff0000');
    end
    if getProperty('songMisses') > 5 then
        oops = 0
    end

    setProperty('limit.scale.x', getProperty('iconP1.scale.x'))
    setProperty('limit.scale.y', getProperty('iconP1.scale.y'))

    setTextString('limit', 'Limit: ' .. oops)

    if oops == 2 then
        if curBeat % 2 == 0 then
            setTextColor('limit', 'ff0000');
        end
        if curBeat % 2 == 1 then
            setTextColor('limit', 'ffffff')
        end
    end
    if oops == 1 then
        if curStep % 2 == 0 then
            setTextColor('limit', 'ff0000');
        end
        if curStep % 2 == 1 then
            setTextColor('limit', '0xffffff')
        end
    end 

    -- score shit
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

    --if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.L') then
    --    addMisses(1)
    --end 
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    -- for the fake score "zoom"
    if isSustainNote == false then
        setProperty('fakeScore.scale.x', 1.1)
        setProperty('fakeScore.scale.y', 1.1)
        runTimer('hited', 0.1, 1)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then
		startDialogue('dialogue', '');
	end

    if tag == 'fadelin1' then
        doTweenAlpha('comeChild1', 'dodgeIt', 1, 0.5, 'linear')
    end
    if tag == 'getOut1' then
        doTweenAlpha('leavenow1', 'dodgeIt', 0, 1, 'linear')
    end

    if tag == 'fadelin2' then
        doTweenAlpha('comeChild2', 'youFool', 1, 0.5, 'linear')
    end
    if tag == 'getOut1' then
        doTweenAlpha('leavenow2', 'youFool', 0, 1, 'linear')
    end

    -- for the fake score "zoom"
    if tag == 'hited' then
        setProperty('fakeScore.scale.x', 1)
        setProperty('fakeScore.scale.y', 1)
    end
end