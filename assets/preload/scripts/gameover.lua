function onCreate()
	setPropertyFromClass('GameOverSubstate', 'deathSoundName','fnf_loser_sfx');
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'overgame');
end

function onUpdate()
	if songName == 'r3m@t(h' then -- incase you somehow die
		setPropertyFromClass('GameOverSubstate', 'deathSoundName','fnf_loss_sfx');
		setPropertyFromClass('GameOverSubstate', 'loopSoundName', '');
	end
end