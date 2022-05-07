function onCreatePost() 
	-- thanks to this mf https://gamebanana.com/tools/8553

	makeLuaSprite('icon', 'icons/icon-ghpico', getProperty('iconP1.x') + 70, getProperty('iconP1.y') - 40)
	setObjectCamera('icon', 'hud')
	--addLuaSprite('icon', true)
	setObjectOrder('icon', getObjectOrder('iconP1') + 1)
	setProperty('icon.flipX', true)
	setProperty('icon.visible', false)
	setProperty('icon.alpha', tonumber(0))
	
	makeLuaSprite('iconDed', 'icons/icon-ghpicoDed', getProperty('iconP1.x') + 70, getProperty('iconP1.y') - 40)
	setObjectCamera('iconDed', 'hud')
	--addLuaSprite('iconDed', true)
	setObjectOrder('iconDed', getObjectOrder('iconP1') + 1)
	setProperty('iconDed.flipX', true)
	setProperty('iconDed.visible', false)
	setProperty('iconDed.alpha', tonumber(0))
	
end

function onUpdatePost(elapsed)

	if curBeat == 32 then
		doTweenAlpha('iconCome', 'icon', 0.8, 0.6, 'linear')
		doTweenAlpha('iconDedCome', 'iconDed', 0.8, 0.6, 'linear')
	end

	setProperty('icon.x', getProperty('iconP1.x') + 70)
	setProperty('icon.angle', getProperty('iconP1.angle'))
	setProperty('icon.y', getProperty('iconP1.y') - 30)
	setProperty('icon.scale.x', getProperty('iconP1.scale.x'))
	setProperty('icon.scale.y', getProperty('iconP1.scale.y'))
	
	if getProperty('health') > 0.4 then
		setProperty('icon.visible', true)
	else
		setProperty('icon.visible', false)
	end

	setProperty('iconDed.x', getProperty('iconP1.x') + 70)
	setProperty('iconDed.angle', getProperty('iconP1.angle'))
	setProperty('iconDed.y', getProperty('iconP1.y') - 30)
	setProperty('iconDed.scale.x', getProperty('iconP1.scale.x'))
	setProperty('iconDed.scale.y', getProperty('iconP1.scale.y'))
		
	if getProperty('boyfriend.curCharacter') ~= 'bfngf-pixel' then 
		if getProperty('health') <= 0.4 then
			setProperty('iconDed.visible', true)
		else
			setProperty('iconDed.visible', false)
		end
	end
end