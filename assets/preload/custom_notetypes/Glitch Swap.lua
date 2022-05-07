function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == "Glitch Swap" then --Check if the note on the chart is a Bullet Note
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'GlitchSwapNote_Assets'); --Change texture

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has penalties
			end
		end
	end
end

-- I don't know why this works but it does?
local ranX = 100
local ranY = 100

function onUpdate()
	ranX = math.random(100, 1200)
	ranY = math.random(100, 700)
end

function goodNoteHit(id, direction, noteType, isSustainNote)

	if noteType == "Glitch Swap" then
		setProperty('health', 1)
		addMisses(3)
		addScore(-500)
		noteTweenX('fukkedLeft1', 4, math.random(100, 1200), 0.01, 'linear')
		noteTweenY('fukkedUp1', 4, math.random(100, 700), 0.01, 'linear')
		noteTweenX('fukkedLeft2', 5, math.random(100, 1200), 0.01, 'linear')
		noteTweenY('fukkedUp2', 5, math.random(100, 700), 0.01, 'linear')
		noteTweenX('fukkedLeft3', 6, math.random(100, 1200), 0.01, 'linear')
		noteTweenY('fukkedUp3', 6, math.random(100, 700), 0.01, 'linear')
		noteTweenX('fukkedLeft4', 7, math.random(100, 1200), 0.01, 'linear')
		noteTweenY('fukkedUp4', 7, math.random(100, 700), 0.01, 'linear')
		runTimer('whatThe', 5, 1)
	end

end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == "Glitch Swap" then
		setProperty('health', getProperty('health') +0.0475);
		addMisses(-1);
		cameraShake('camGame', 0.01, 0.2);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'whatThe' then
		noteTweenX('unfukkedLeft1', 4, defaultPlayerStrumX0, 1, 'linear')
		noteTweenY('unfukkedUp1', 4, defaultPlayerStrumY0 + 10, 1, 'linear')
		noteTweenAngle('unfukkedWee1', 4, 360, 1, 'linear')
		noteTweenX('unfukkedLeft2', 5, defaultPlayerStrumX1, 1, 'linear')
		noteTweenY('unfukkedUp2', 5, defaultPlayerStrumY1 + 10, 1, 'linear')
		noteTweenAngle('unfukkedWee2', 5, 360, 1, 'linear')
		noteTweenX('unfukkedLeft3', 6, defaultPlayerStrumX2, 1, 'linear')
		noteTweenY('unfukkedUp3', 6, defaultPlayerStrumY2 + 10, 1, 'linear')
		noteTweenAngle('unfukkedWee3', 6, 360, 1, 'linear')
		noteTweenX('unfukkedLeft4', 7, defaultPlayerStrumX3, 1, 'linear')
		noteTweenY('unfukkedUp4', 7, defaultPlayerStrumY3 + 10, 1, 'linear')
		noteTweenAngle('unfukkedWee4', 7, 360, 1, 'linear')
	end
end