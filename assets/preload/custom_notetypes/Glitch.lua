function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Glitch' then --Check if the note on the chart is a Bullet Note
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'GlitchNotes'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashHue', 0);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashSat', -20);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashBrt', 1);

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has penalties
			end
		end
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Glitch' and songName == 'bad end' then
		setProperty('health', getProperty('health')-3);
		playSound('glitchhit', 0.8);
		addMisses(999);
	end

	if noteType == 'Glitch' and mustHitSection == false then
		--insta death
		setProperty('health', getProperty('health')-3);
		playSound('glitchhit', 0.8);
		addMisses(999);
		characterPlayAnim('boyfriend', 'hurt', true);
	elseif noteType == 'Glitch' and mustHitSection == true then
		-- punishment levels // This was just intended for Blueballed, but I suppose it's also good for bad end
		if difficulty == 2 then
			setProperty('health', getProperty('health')-0.7);
		elseif difficulty == 1 then
			setProperty('health', getProperty('health')-0.55);
		else
			setProperty('health', getProperty('health')-0.3);
		end

		playSound('glitchhit', 0.8);
		addMisses(1);
		characterPlayAnim('boyfriend', 'hurt', true);
    end

end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'Glitch' then
	    setProperty('health', getProperty('health') +0.0475);
		addMisses(-1);
		cameraShake('camGame', 0.01, 0.2);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	-- A loop from a timer you called has been completed, value "tag" is it's tag
	-- loops = how many loops it will have done when it ends completely
	-- loopsLeft = how many are remaining
	if loopsLeft >= 1 then
		setProperty('health', getProperty('health')-0.001);
	end
end
-- notesplashes are now tied to script