function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Whoops' then --Check if the note on the chart is a Shootems Note
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'dodgeGloopNOTE_assets'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashHue', 0);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashSat', 0);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashBrt', -80);
			--[[  	old note splash color
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashHue', 0);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashSat', -65); 
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashBrt', 35);
			]]--	uncomment to change back
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has penalties
			end
		end
	end
end

local gloopedAmount = 0
function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Whoops' and getProperty('boyfriend.curCharacter') ~= 'bf@NOWYOU' then
		makeLuaSprite('onebadgloop', 'gloop_asset', 340, 500)
		addLuaSprite('onebadgloop', true)
		doTweenX('watchOut', 'onebadgloop', 4000, 0.5, 'linear')
		runTimer('thrown', 1, 4)
		characterPlayAnim('boyfriend', 'dodge', true)
		playSound('hitshit_clap 2', 0.75)
		setProperty('health', getProperty('health')+ 0.03)
		if getProperty('cpuControlled') == true then
			
		else
			addScore(250)
		end
		-- this looks weird
		--setProperty('boyfriend.specialAnim', true);
	end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'Whoops' and getProperty('boyfriend.curCharacter') ~= 'bf@NOWYOU' then
		gloopedAmount = gloopedAmount + 0.12 -- gets more powerful the more you miss
		characterPlayAnim('boyfriend', 'hurt', true);
		cameraFlash('game', '0xFFFFFF', 0.2, true)
		playSound('splat')
		setProperty('health', getProperty('health')- gloopedAmount)
		--setProperty('health', -99)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'thrown' then
		removeLuaSprite('onebadgloop', false)
	end
end