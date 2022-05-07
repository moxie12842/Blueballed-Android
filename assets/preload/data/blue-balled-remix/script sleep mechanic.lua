function onCreate()
    -- Bg that fades in during sleep event
    -- you know... I could have just had the background fade out, but nooooo
    makeLuaSprite('sleepBack', 'sleep', -20, 230)
    scaleObject('sleepBack', 1.1, 1.1)
    addLuaSprite('sleepBack', true)
    setObjectOrder('sleepBack', getObjectOrder('dadGroup')+ 1) -- ONLY in front of dad and gf but not bf
    setProperty('sleepBack.alpha', tonumber(0))
 
end
-- this is my first time doin something like this so I had some trouble alright

local sleepTime = false -- event trigger
local sleepyMeter = 0
local death = false -- for sleepyMeter reaching 3
local noNotes = false

function onUpdate()


    setTextString('slpCounter', "".. sleepyMeter)

    -- fadin stuff
    if sleepTime == true then
        if keyJustPressed('space') then
            if sleepyMeter < 3 then -- can't decrease once reached
                sleepyMeter = sleepyMeter - 0.3
            end


            if sleepyMeter < 0 then
                sleepyMeter = 0
            end

        end
      
        if sleepyMeter == 0 then
            -- efficient? nah, but it works
            removeLuaText('hey', true)
            removeLuaText('wakeUp', true)
            removeLuaText('slpCounter', true)
            setProperty('sleepBack.alpha', tonumber(0))
            setProperty('canPause', true)
            --setProperty('boyfriend.stunned', false)
           sleepTime = false
        end

        if sleepyMeter > 3 then
            sleepyMeter = 3
            sleepTime = false
        end
    end

    if sleepyMeter >= 2 then
        setProperty('iconP1.alpha', tonumber(0)) -- the fades in the main script require this, kinda stops wonky icon alphas
    end

    if sleepyMeter == 3 and death == false then -- loss
        -- get rid of everything // '.visible', false) would work as well, but wouldn't be smooth
        death = true
        noNotes = true
        for i = 0, 7, 1 do
            noteTweenAlpha('sleepTight'.. i, i, 0, 0.8, 'linear') -- doing this tween in the note fusion section kinda breaks it
        end
        doTweenAlpha('gone1', 'dad', 0, 0.8, 'linear')
        doTweenAlpha('gone2', 'gf', 0, 0.8, 'linear')
        doTweenAlpha('gone3', 'healthBar', 0, 0.8, 'linear')
        doTweenAlpha('gone4', 'healthBarBG', 0, 0.8, 'linear')
        doTweenAlpha('goodNight', 'sleepBack', 1, 0.8, 'linear')
        --doTweenAlpha('gone5', 'fakeScore', 0, 0.8, 'linear') -- doesnt work ;(
        doTweenAlpha('gone6', 'resist', 0, 0.8, 'linear')
        doTweenAlpha('gone7', 'control', 0, 0.8, 'linear')
        setProperty('defaultCamZoom', 1.3)
        soundFadeOut('', 0.2, 0)
        runTimer('sleep', 3, 1)
    end

    if noNotes == true then
        for i=0, getProperty('notes.length') do
            if getSongPosition() > getPropertyFromGroup('notes',i,'strumTime') - 500 then -- no more 19 dollar notes *vine boom*
                removeFromGroup('notes', i);
            end
        end
    end
    
end

function onTimerCompleted(tag, loops, loopsLeft)

    if tag == 'sleep' then
        restartSong(false) -- I had too much trouble with this stupid timer
    end
end

function onStepHit()
    if sleepTime == true and sleepyMeter > 0 and sleepyMeter < 3 then -- onUpdate's too fast and onBeatHit is too slow
        sleepyMeter = sleepyMeter + 0.1
    end


    -- Don't set them too close together, overrides the amounts, fucks with input sometimes, could use more work in some places
    if not botPlay then 
        if curStep == 145 then
            gettnSleepy()
        end
        if curStep == 224 then
            gettnSleepy()
        end
        if curStep == 272 then
            gettnSleepy()
        end
        if curStep == 400 then
            gettnSleepy()
        end
        if curStep == 432 then
            gettnSleepy()
        end
        if curStep == 529 then
            gettnSleepy()
        end
        if curStep == 560 then
            gettnSleepy()
        end
        if curStep == 688 then
            gettnSleepy()
        end
        if curStep == 705 then
            gettnSleepy()
        end
        if curStep == 792 then
            gettnSleepy()
        end
        if curStep == 824 then
            gettnSleepy()
        end
         -- no more, cuz I don't wanna overwhelm on the fast part    
    end
   
end

function onBeatHit()
end  


function gettnSleepy()
    sleepTime = true
    makeLuaText('hey', "WAKE UP", 500, screenWidth / 2 - 250, screenHeight / 2 - 50);
    setObjectCamera("hey", 'hud');
    setTextColor('hey', '0xffff00')
    setTextSize('hey', 50);
    addLuaText("hey");
    setTextFont('hey', "vcr.ttf")
    setTextAlignment('hey', 'center')

    makeLuaText('wakeUp', "MASH SPACE", 500, screenWidth / 2 - 250, screenHeight / 2);
    setObjectCamera("wakeUp", 'hud');
    setTextColor('wakeUp', '0xff0000')
    setTextSize('wakeUp', 45);
    addLuaText("wakeUp");
    setTextFont('wakeUp', "vcr.ttf")
    setTextAlignment('wakeUp', 'center')

    makeLuaText('slpCounter', "", 500, screenWidth / 2 - 250, screenHeight / 2 + 50);
    setObjectCamera("slpCounter", 'hud');
    setTextColor('slpCounter', '0xff0000')
    setTextSize('slpCounter', 40);
    addLuaText("slpCounter");
    setTextFont('slpCounter', "vcr.ttf")
    setTextAlignment('slpCounter', 'center')


    --setProperty('boyfriend.stunned', true)
    setProperty('canPause', false)  -- can't pause your way out of this, not like it matters
    

    sleepyMeter = 1.5
end

--[[function randAmount()
-- was considering doing randomish amounts but it would be better for it to be uniform every time for fairness
    got = math.random(0.2, 1.1)
    return got
end]]