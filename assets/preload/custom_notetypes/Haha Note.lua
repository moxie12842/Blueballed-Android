function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Haha Note' then -- just for those sections
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'hahaNOTE_assets'); --Change texture
			--[[setPropertyFromGroup('unspawnNotes', i, 'noteSplashHue', 0);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashSat', -65);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashBrt', 35);]]

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has penalties // you can't hit it soooo
			end
		end
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	
end

function noteMiss(id, direction, noteType, isSustainNote)
	
end