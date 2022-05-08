-- Credit me if you're gonna make your own level with this.
-- Else there'll be a surprise in the mail tomorrow :) (For legal reasons this is a joke)

-- I won't leave any instructions, figure the level making part yourself lmao.
-- (OK k, each pixel color is a different block, check the hex codes in the file to figure out which color is which block.)

-- This is also really primitive (AND BUGGY) so feel free to make additions or improving the script.

local hspWalk = 1.95;
local vspJump = -9.65;
local accel = 0.45;
local hsp = 0;
local vsp = 0;
local camhsp = 0;
local camvsp = 0;
local grv = 0.3;
local blocks = 0;
local deathPlains = 0;
local gravityFields = 0;
local bgTiles = 0;
local objects = 0;
local objectsAnim = 0;
local camBounds = 0;
local blockSize = 64;
local timerStarted = false;
local grounded = false;
local upsideDown = false;
local onTheWall = false;
local verticalSpeedCap = 12.5;
local dead = false;
local step = 0;
local beat = 0;
local lastBeat = -1;
local paused = false;
local finalSection = 1;

local cameraStuck = {false, false, false, false}; -- Left, Right, Top, Bottom
local curRespawnPoint = {}; -- X, Y, face right?

local curSecond = 0;
local curMinute = 0;
local timeMS = 0;

local curSection = 0;
local sectionLayers = {'-background', '-tiles', '-objects', '-cambounds'}; -- Order of addition

local controlsAllowed = false;

local tick = 60;
local right = 0;
local left = 0;

local particleColors = {'FF00AA', 'FF007F', 'FF0054', 'FF002A', 'FF0000', 'FF2A00', 'FF5400', 'FF7F00', 'FFAA00'};

local tilesList = { -- Hex Color, name for -tiles (LAYERS)
	{color = 'ff6a00', tileName = 'w1stageTL'},
	{color = 'ff0000', tileName = 'w1stageTM'},
	{color = 'ffff00', tileName = 'w1stageTR'},
	{color = '00ff00', tileName = 'w1stageCL'},
	{color = '0000ff', tileName = 'w1stageCM'},
	{color = '00ffff', tileName = 'w1stageCR'},
	{color = '0094ff', tileName = 'w1stageBL'},
	{color = 'b200ff', tileName = 'w1stageBM'},
	{color = 'ff00dc', tileName = 'w1stageBR'},
	{color = 'ff7f7f', tileName = 'w1stageCRTL'},
	{color = 'ffb27f', tileName = 'w1stageCRTR'},
	{color = 'ffe97f', tileName = 'w1stageCRBR'},
	{color = 'daff7f', tileName = 'w1stageCRBL'}
};

local objectsList = { -- Hex Color, File name, X offset, Y offset, flip X, flip Y, animated
	{color = '502c5b', name = 'stage_light', x = 148, y = 150, scaleX = 0.375, scaleY = 0.375, flipX = false, flipY = false, animated = false}, -- Stage Light L
	{color = '725572', name = 'stage_light', x = 20, y = 150, scaleX = 0.375, scaleY = 0.375, flipX = true, flipY = false, animated = false}, -- Stage Light R
	{color = '6c8aa3', name = 'section_door', x = 0, y = -32, scaleX = 1, scaleY = 1, flipX = false, flipY = false, animated = false}, -- Section Door (Forward)
	{color = '293347', name = 'section_door_back', x = 0, y = -32, scaleX = 1, scaleY = 1, flipX = false, flipY = false, animated = false}, -- Section Door (Back)
	{color = '800869', name = 'ending_door', x = 0, y = -32, scaleX = 1, scaleY = 1, flipX = false, flipY = false, animated = false}, -- Level Ending Door
	{color = 'a7b0cf', name = 'speaker', x = -54, y = 30, scaleX = 1, scaleY = 1, flipX = false, flipY = false, animated = true}, -- Speaker Left (Animated)
	{color = '222c3d', name = 'speaker', x = 77, y = 30, scaleX = 1, scaleY = 1, flipX = true, flipY = false, animated = true} -- Speaker Right (Animated)
};

function onCreate()
	makeAnimationList();
	makeOffsets();
	-- luaDebugMode = true;
	setProperty('skipCountdown', true);
end

function onCreatePost()
	runTimer('hideAllStuff', 0.01);

	for i = 0, 6 do
		makeLuaSprite('challenge06'..i, 'challenge/challenge06', 0, -400);
		setScrollFactor('challenge06'..i, 0.2, 0.1);
		addLuaSprite('challenge06'..i);

		makeLuaSprite('challenge05'..i, 'challenge/challenge05', 0, 0);
		setScrollFactor('challenge05'..i, 0.3, 0.15);
		addLuaSprite('challenge05'..i);

		makeLuaSprite('challenge04'..i, 'challenge/challenge04', 0, 300);
		setScrollFactor('challenge04'..i, 0.4, 0.2);
		addLuaSprite('challenge04'..i);

		makeLuaSprite('challenge03'..i, 'challenge/challenge03', 0, 400);
		setScrollFactor('challenge03'..i, 0.5, 0.25);
		addLuaSprite('challenge03'..i);

		makeLuaSprite('challenge02'..i, 'challenge/challenge02', 0, 700);
		setScrollFactor('challenge02'..i, 0.7, 0.25);
		addLuaSprite('challenge02'..i);

		makeLuaSprite('challenge01'..i, 'challenge/challenge01', 0, 1000);
		setScrollFactor('challenge01'..i, 0.8, 0.25);
		addLuaSprite('challenge01'..i);
	end

	for i = 1, 6 do
		setProperty('challenge01'.. i ..'.x', getProperty('challenge01'.. i - 1 ..'.x') + getProperty('challenge01'.. i - 1 ..'.width'))
		setProperty('challenge02'.. i ..'.x', getProperty('challenge02'.. i - 1 ..'.x') + getProperty('challenge02'.. i - 1 ..'.width'))
		setProperty('challenge03'.. i ..'.x', getProperty('challenge03'.. i - 1 ..'.x') + getProperty('challenge03'.. i - 1 ..'.width'))
		setProperty('challenge04'.. i ..'.x', getProperty('challenge04'.. i - 1 ..'.x') + getProperty('challenge04'.. i - 1 ..'.width'))
		setProperty('challenge05'.. i ..'.x', getProperty('challenge05'.. i - 1 ..'.x') + getProperty('challenge05'.. i - 1 ..'.width'))
		setProperty('challenge06'.. i ..'.x', getProperty('challenge06'.. i - 1 ..'.x') + getProperty('challenge06'.. i - 1 ..'.width'))
	end
	
    makeLuaSprite('player', '', 256, -64);
    makeGraphic('player', 48, 56, 'FFFFFF');
    addLuaSprite('player', false);

    -- Load first section of level.
    loadLevelSection(curSection);

    makeLuaSprite('songClock', 'songTimer', 0, 0);
    setObjectCamera('songClock', 'hud');
    scaleObject('songClock', 0.35, 0.35);
    updateHitbox('songClock');
    addLuaSprite('songClock', true);
    screenCenter('songClock', 'x');

    makeLuaSprite('clockHandM', 'songTimerMinute', 0, 0);
    setObjectCamera('clockHandM', 'hud');
    addLuaSprite('clockHandM', true);
    scaleObject('clockHandM', 0.35, 0.35);

    makeLuaSprite('clockHandS', 'songTimerSecond', 0, 0);
    setObjectCamera('clockHandS', 'hud');
    addLuaSprite('clockHandS', true);
    scaleObject('clockHandS', 0.35, 0.35);

    makeLuaText('timeText', '', screenWidth, 0, 20);
    setTextSize('timeText', 28);
    setTextBorder('timeText', 2, '000000');
    setTextAlignment('timeText', 'center');
    addLuaText('timeText');

	makeLuaSprite('box01', '', 0, 0);
	makeGraphic('box01', screenWidth, screenHeight / 2, '000000');
	addLuaSprite('box01', true);
	setObjectCamera('box01', 'hud');
	setProperty('box01.origin.y', 0);

	makeLuaSprite('box02', '', 0, screenHeight / 2);
	makeGraphic('box02', screenWidth, screenHeight / 2, '000000');
	addLuaSprite('box02', true);
	setObjectCamera('box02', 'hud');
	setProperty('box02.origin.y', getProperty('box02.height'));

	makeLuaSprite('debugGrid', 'challenge/debug_grid', 0, 0);
	scaleObject('debugGrid', 2, 2);
	addLuaSprite('debugGrid', false);
	setProperty('debugGrid.visible', false)

	makeLuaSprite('cameraScreen', '', 0, 0);
	makeGraphic('cameraScreen', screenWidth, screenHeight, '000000');
	setProperty('cameraScreen.alpha', 0);
	addLuaSprite('cameraScreen', true);

	makeAnimatedLuaSprite('c_bf', 'challenge/challenge_boyfriend', -128, 0);
	addAnimationByPrefix('c_bf', 'idle', 'challenge_bf', 24, false);
	addAnimationByPrefix('c_bf', 'run', 'run challenge_bf', 24, false);
	addAnimationByPrefix('c_bf', 'jump', 'jump challenge_bf', 24, false);
	addAnimationByPrefix('c_bf', 'fall', 'fall challenge_bf', 24, false);
	addAnimationByPrefix('c_bf', 'wall', 'onWall challenge_bf', 24, false);
    setScrollFactor('c_bf', 1, 1);
    addLuaSprite('c_bf', false);
    scaleObject('c_bf', 0.75, 0.75);
	setProperty('c_bf.flipX', true);
    setObjectCamera('c_bf', 'hud');
	setObjectOrder('c_bf', getObjectOrder('box02') + 1);

	makeLuaText('levelName', 'FNF-C\nChallenge: Friday Night Funkin\'', screenWidth, 0, 90);
	setTextSize('levelName', 36);
	addLuaText('levelName');
	setTextColor('levelName', '000000');
	setProperty('levelName.scale.y', 0);

	setProperty('player.visible', false);

	setProperty('player.x', curRespawnPoint[1][1]);
	setProperty('player.y', curRespawnPoint[1][2]);
	setProperty('cameraScreen.x', curRespawnPoint[1][1] - 615);
	setProperty('cameraScreen.y', curRespawnPoint[1][2] - 395);

    setProperty('songClock.y', getProperty('strumLine.y') + 15);

	-- local tickRate = 1 / tick;
	-- runTimer('Tick', tickRate, 0);

    if not lowQuality then
        spawnParticles();
    end
end

function loadLevelSection(section)
	for q = 0, blocks - 1 do
		removeLuaSprite('block'..q, false);
	end
	for w = 0, deathPlains - 1 do
		removeLuaSprite('deathPlain'..w, false);
	end
	for e = 0, gravityFields - 1 do
		removeLuaSprite('gravityField'..e, false);
	end
	for r = 0, bgTiles - 1 do
		removeLuaSprite('bgTile'..r, false);
	end
	for t = 0, objects - 1 do
		removeLuaSprite('object'..t, false);
	end
	for y = 0, objectsAnim - 1 do
		removeLuaSprite('objectAnimated'..y, false);
	end
	for u = 0, camBounds - 1 do
		removeLuaSprite('camBound'..u, false);
	end
	removeLuaSprite('doorForwards', false);

	blocks = 0;
	deathPlains = 0;
	gravityFields = 0;
	bgTiles = 0;
	objects = 0;
	camBounds = 0;

	for a = 1, #sectionLayers do
		removeLuaSprite('part'..section..sectionLayers[a], false);

		makeLuaSprite('part' .. section .. sectionLayers[a], 'challenge/section' .. section .. sectionLayers[a], 0, 0 - (100 * (a - 1)));
		setProperty('part' .. section .. sectionLayers[a] .. '.antialiasing', false);
		addLuaSprite('part' .. section .. sectionLayers[a]);
		sectionWidth = getProperty('part' .. section .. sectionLayers[a] .. '.width');
		sectionHeight = getProperty('part' .. section .. sectionLayers[a] .. '.height');
	
		-- Very poor system I know.
		for i = 0, sectionHeight - 1 do
			for j = 0, sectionWidth - 1 do
				color = getPixelColor('part' .. section .. sectionLayers[a], j, i);
				newColor = string.format("%x", color);
				if string.len(newColor) == 16 then -- Sorry, only pixels with alpha at 100% work.
					newColor = string.sub(newColor, 11, 16); -- Cut the first 10 F's out lol.
	
					if newColor == 'ffffff' then -- Spawn point
						table.insert(curRespawnPoint, {j * blockSize + 8, i * blockSize + 4, true});
					elseif newColor == '000000' then -- Death areas
						makeLuaSprite('deathPlain' .. deathPlains, '', j * blockSize, i * blockSize);
						makeGraphic('deathPlain' .. deathPlains, blockSize, blockSize, '000000');
						addLuaSprite('deathPlain' .. deathPlains, false);
						setProperty('deathPlain' .. deathPlains .. '.visible', false);
						deathPlains = deathPlains + 1;
					elseif newColor == 'd67fff' then -- Anti-gravity
						makeLuaSprite('gravityField' .. gravityFields, '', j * blockSize, i * blockSize);
						makeGraphic('gravityField' .. gravityFields, blockSize, blockSize, 'd67fff');
						addLuaSprite('gravityField' .. gravityFields, false);
						setProperty('gravityField' .. gravityFields .. '.alpha', 0.35);
						gravityFields = gravityFields + 1;
					else -- Regular blocks
						if a == 3 then -- Objects
							for b = 1, #objectsList do
								if newColor == objectsList[b].color then
									if objectsList[b].animated then
										makeAnimatedLuaSprite('objectAnimated' .. objectsAnim, 'challenge/objects/' .. objectsList[b].name, j * blockSize, i * blockSize);
										addAnimationByPrefix('objectAnimated' .. objectsAnim, 'dance', 'idle', 24, false);
										addLuaSprite('objectAnimated' .. objectsAnim, false);
										setProperty('objectAnimated' .. objectsAnim .. '.offset.x', objectsList[b].x);
										setProperty('objectAnimated' .. objectsAnim .. '.offset.y', objectsList[b].y);
										setProperty('objectAnimated' .. objectsAnim .. '.scale.x', objectsList[b].scaleX);
										setProperty('objectAnimated' .. objectsAnim .. '.scale.y', objectsList[b].scaleY);
										setProperty('objectAnimated' .. objectsAnim .. '.flipX', objectsList[b].flipX);
										setProperty('objectAnimated' .. objectsAnim .. '.flipY', objectsList[b].flipY);
										objectsAnim = objectsAnim + 1;
									elseif newColor == '800869' then
										makeLuaSprite('doorEnding', 'challenge/objects/' .. objectsList[b].name, j * blockSize, i * blockSize);
										addLuaSprite('doorEnding', false);
										setProperty('doorEnding.offset.x', objectsList[b].x);
										setProperty('doorEnding.offset.y', objectsList[b].y);
										setProperty('doorEnding.scale.x', objectsList[b].scaleX);
										setProperty('doorEnding.scale.y', objectsList[b].scaleY);
										setProperty('doorEnding.flipX', objectsList[b].flipX);
										setProperty('doorEnding.flipY', objectsList[b].flipY);
									elseif newColor == '6c8aa3' then
										makeLuaSprite('doorForwards', 'challenge/objects/' .. objectsList[b].name, j * blockSize, i * blockSize);
										addLuaSprite('doorForwards', false);
										setProperty('doorForwards.offset.x', objectsList[b].x);
										setProperty('doorForwards.offset.y', objectsList[b].y);
										setProperty('doorForwards.scale.x', objectsList[b].scaleX);
										setProperty('doorForwards.scale.y', objectsList[b].scaleY);
										setProperty('doorForwards.flipX', objectsList[b].flipX);
										setProperty('doorForwards.flipY', objectsList[b].flipY);
									elseif newColor == '293347' then
										makeLuaSprite('doorBackwards', 'challenge/objects/' .. objectsList[b].name, j * blockSize, i * blockSize);
										addLuaSprite('doorBackwards', false);
										setProperty('doorBackwards.offset.x', objectsList[b].x);
										setProperty('doorBackwards.offset.y', objectsList[b].y);
										setProperty('doorBackwards.scale.x', objectsList[b].scaleX);
										setProperty('doorBackwards.scale.y', objectsList[b].scaleY);
										setProperty('doorBackwards.flipX', objectsList[b].flipX);
										setProperty('doorBackwards.flipY', objectsList[b].flipY);
										table.remove(curRespawnPoint);
										table.insert(curRespawnPoint, {j * blockSize + 8 + 96, i * blockSize + 4 + 188, true});
									else
										makeLuaSprite('object' .. objects, 'challenge/objects/' .. objectsList[b].name, j * blockSize, i * blockSize);
										addLuaSprite('object' .. objects, false);
										setProperty('object' .. objects .. '.offset.x', objectsList[b].x);
										setProperty('object' .. objects .. '.offset.y', objectsList[b].y);
										setProperty('object' .. objects .. '.scale.x', objectsList[b].scaleX);
										setProperty('object' .. objects .. '.scale.y', objectsList[b].scaleY);
										setProperty('object' .. objects .. '.flipX', objectsList[b].flipX);
										setProperty('object' .. objects .. '.flipY', objectsList[b].flipY);
										objects = objects + 1;
									end
								end
							end
						elseif a == 2 then -- Tiles
    						for k = 1, #tilesList do
    							if newColor == tilesList[k].color then
    								makeAnimatedLuaSprite('block' .. blocks, 'challenge/week1stage', j * blockSize, i * blockSize);
    								addAnimationByPrefix('block'..blocks, 'tile'..k, tilesList[k].tileName, 0, false);
    								objectPlayAnimation('tile'..k);
    								addLuaSprite('block' .. blocks, false);
    								scaleObject('block' .. blocks, 1.01, 1.01);
									blocks = blocks + 1;
    							end
    						end
						elseif a == 1 then -- Background
    						for k = 1, #tilesList do
    							if newColor == tilesList[k].color then
    								makeAnimatedLuaSprite('bgTile' .. bgTiles, 'challenge/week1stage', j * blockSize, i * blockSize);
    								addAnimationByPrefix('bgTile'..bgTiles, 'tile'..k, tilesList[k].tileName..'_BG', 0, false);
    								objectPlayAnimation('tile'..k);
    								addLuaSprite('bgTile' .. bgTiles, false);
    								scaleObject('bgTile' .. bgTiles, 1.01, 1.01);
									bgTiles = bgTiles + 1;
    							end
    						end
    					elseif a == 4 then -- Camera Bounds
    						if newColor == '808080' then
								makeLuaSprite('camBound' .. camBounds, '', j * blockSize, i * blockSize);
								makeGraphic('camBound' .. camBounds, blockSize, blockSize, '808080');
								addLuaSprite('camBound' .. camBounds, false);
								setProperty('camBound' .. camBounds .. '.alpha', 0.1);
								camBounds = camBounds + 1;
    						end
						end
					end
				end
			end
		end
	end

	-- debugPrint('Tiles: '..blocks);
	-- debugPrint('BG Tiles: '..bgTiles);
	-- debugPrint('Gravity Fields: '..gravityFields);
	-- debugPrint('Objects: '..objects);
	-- debugPrint('Animated Objects: '..objectsAnim);
	-- debugPrint('Camera Bounds: '..camBounds);
	-- debugPrint('Respawn X: '..curRespawnPoint[1][1]);
	-- debugPrint('Respawn Y: '..curRespawnPoint[1][2]);

	setObjectOrder('debugGrid', getObjectOrder('c_bf') - 1);
end

animationsList = {};
function makeAnimationList()
	animationsList[0] = 'idle';
	animationsList[1] = 'run';
	animationsList[2] = 'jump';
	animationsList[3] = 'fall';
	animationsList[4] = 'wall';
end

offsetsBF = {};
function makeOffsets()
	offsetsBF[0] = {x = 0, y = 0};
	offsetsBF[1] = {x = 0, y = 4};
	offsetsBF[2] = {x = 0, y = 8};
	offsetsBF[3] = {x = 10, y = 4};
	offsetsBF[4] = {x = 10, y = 0};
end

function playAnimation(animId, forced)
	animName = animationsList[animId];
	objectPlayAnimation('c_bf', animName, forced);
	setProperty('c_bf.offset.x', offsetsBF[animId].x);
	setProperty('c_bf.offset.y', offsetsBF[animId].y);
end

function onSongStart()
	-- idk if any of this even does anything to help this script but i dont care lol.

	-- Stolen from that cookie clicker script
	setProperty('preventLuaRemove', true);
	-- setPropertyFromClass('flixel.FlxG', 'sound.music.playing', false);
	setProperty('endingSong', false);
	setProperty('generatedMusic', false);
	setSoundVolume('', 0);
	setPropertyFromClass('flixel.FlxG', 'sound.music.onComplete', nil);
    runTimer('startLevel', 0.55);
end

function onUpdatePost(elapsed)
	step = math.floor(getSoundTime('song') / (((60 / bpm) * 1000) / 4));
	beat = math.floor(step / 4);
	beatHit(beat);

	if getProperty('c_bf.animation.curAnim.finished') and getProperty('c_bf.animation.curAnim.name') ~= 'idle' and controlsAllowed then
		playAnimation(0, false);
	end

    setProperty('clockHandM.x', getProperty('songClock.x') + getProperty('songClock.width') / 2 - getProperty('clockHandM.width') / 2);
    setProperty('clockHandM.y', getProperty('songClock.y') + getProperty('songClock.height') / 2 - getProperty('clockHandM.height') / 2);
    setProperty('clockHandS.x', getProperty('songClock.x') + getProperty('songClock.width') / 2 - getProperty('clockHandS.width') / 2);
    setProperty('clockHandS.y', getProperty('songClock.y') + getProperty('songClock.height') / 2 - getProperty('clockHandS.height') / 2);

    setSongTime();

	local z = curSecond / 60 * 360;
	local z2 = curMinute / 4 * 360;
	setProperty('clockHandS.angle', z);
	setProperty('clockHandM.angle', z2);

	setProperty('botplayTxt.visible', false);

	-- setProperty('debugGrid.x', math.floor((getProperty('player.x') / blockSize)) * blockSize - 3 * blockSize);
	-- setProperty('debugGrid.y', math.floor((getProperty('player.y') / blockSize)) * blockSize - 3 * blockSize);

	-- if keyJustPressed('down') then
		-- debugPrint(timeMS / 1000 .. "/120 seconds");
		-- debugPrint('Current Score to get:' .. 20000 - (2/3) * (timeMS / 1000) * 100);
	-- end

	if controlsAllowed then
		if not timerStarted and (keyPressed('right') or keyPressed('left') or keyPressed('up')) then
			timerStarted = true;
			runTimer('startTimer', 0);
		end

		if keyPressed('right') then
			right = 1;
		else
			right = 0;
		end
	
		if keyPressed('left') then
			left = 1;
		else
			left = 0;
		end
	
		-- Spriting
    	if getPropertyFromClass('flixel.FlxG', 'keys.pressed.SHIFT') then
    	    hspWalk = 7.25;
    	else
    		hspWalk = 6.25;
    	end
	
		if keyJustPressed('up') and grounded then
			vsp = vspJump * (upsideDown and -1 or 1);
			canJump = 0;
			grounded = false;
		end

		if onTheWall then
			playAnimation(4, false);
		elseif vsp > 0 then
			playAnimation((upsideDown and 2 or 3), false);
		elseif vsp < 0 then
			playAnimation((upsideDown and 3 or 2), false);
		elseif hsp < 0 or hsp > 0 then
			playAnimation(1, false);
		end
	else
		hsp = 0;
	end

	if onTheWall then
		verticalSpeedCap = 1.5;
		if keyJustPressed('up') then
			hsp = (hspWalk * 1.75) * (right - left) * -1;
			vsp = vspJump * (upsideDown and -1 or 1);
		end
	else
		verticalSpeedCap = 12.5;
	end

	-- Fuck setting the speed, acceleration hooray
	hsp = Approach(hsp, hspWalk * (right - left), accel);
	vsp = Approach(vsp, verticalSpeedCap * (upsideDown and -1 or 1), grv);

    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.Q') then
    	upsideDown = not upsideDown;
    end

	if hsp > 0 then
		setProperty('c_bf.flipX', true);
	elseif hsp < 0 then
		setProperty('c_bf.flipX', false);
	end

	if upsideDown then
		setProperty('c_bf.flipY', true);
	else
		setProperty('c_bf.flipY', false);
	end

	if controlsAllowed then
		setProperty('c_bf.x', getProperty('player.x') - 39);
		setProperty('c_bf.y', getProperty('player.y') - (upsideDown and 24 or 69));
	else
		if getProperty('c_bf.velocity.y') > 0 then
			playAnimation(3, false);
		elseif getProperty('c_bf.velocity.y') < 0 then
			playAnimation(2, false);
		end
	end

	onTheWall = false;
	if blocks > 0 then
		for i = 0, blocks - 1 do
			-- x col
			if CheckCollision(getProperty('player.x') + hsp, getProperty('player.y'), getProperty('player.width'), getProperty('player.height'),
			getProperty('block'..i..'.x'), getProperty('block'..i..'.y'), getProperty('block'..i..'.width'), getProperty('block'..i..'.height')) then
				while math.abs(hsp) > 0.1 do
					hsp = hsp * 0.5;
					if not CheckCollision(getProperty('player.x') + hsp, getProperty('player.y'), getProperty('player.width'), getProperty('player.height'),
					getProperty('block'..i..'.x'), getProperty('block'..i..'.y'), getProperty('block'..i..'.width'), getProperty('block'..i..'.height')) then
						setProperty('player.x', getProperty('player.x') + hsp);
					end
					if not grounded then
						onTheWall = true;
					end
				end
				hsp = 0;
			end
	
			-- y col
			if CheckCollision(getProperty('player.x'), getProperty('player.y') + vsp, getProperty('player.width'), getProperty('player.height'),
			getProperty('block'..i..'.x'), getProperty('block'..i..'.y'), getProperty('block'..i..'.width'), getProperty('block'..i..'.height')) then
				while math.abs(vsp) > 0.1 do
					vsp = vsp * 0.5;
					if not CheckCollision(getProperty('player.x'), getProperty('player.y') + vsp, getProperty('player.width'), getProperty('player.height'),
					getProperty('block'..i..'.x'), getProperty('block'..i..'.y'), getProperty('block'..i..'.width'), getProperty('block'..i..'.height')) then
						setProperty('player.y', getProperty('player.y') + vsp);
					end
				end
				vsp = 0;
				grounded = true;
			end
		end
	end

	-- Why the hell
	upsideDown = false;
	if gravityFields > 0 then
		for i = 0, gravityFields - 1 do
			if CheckCollision(getProperty('player.x'), getProperty('player.y'), getProperty('player.width'), getProperty('player.height'),
			getProperty('gravityField'..i..'.x'), getProperty('gravityField'..i..'.y'), getProperty('gravityField'..i..'.width'), getProperty('gravityField'..i..'.height')) then
				upsideDown = true;
			-- else
				-- upsideDown = false;
			end
		end
	end

	if deathPlains > 0 then
		for i = 0, deathPlains - 1 do
			if CheckCollision(getProperty('player.x'), getProperty('player.y'), getProperty('player.width'), getProperty('player.height'),
			getProperty('deathPlain'..i..'.x'), getProperty('deathPlain'..i..'.y'), getProperty('deathPlain'..i..'.width'), getProperty('deathPlain'..i..'.height')) then
				if not dead then
					respawnPlayer();
					dead = true;
				end
			end
		end
	end

	if CheckCollision(getProperty('player.x'), getProperty('player.y'), getProperty('player.width'), getProperty('player.height'),
	getProperty('doorForwards.x'), getProperty('doorForwards.y'), getProperty('doorForwards.width'), getProperty('doorForwards.height'))
	and keyJustPressed('down') and grounded and controlsAllowed then
		doorTransition();
	end

	if curSection == finalSection then
		if CheckCollision(getProperty('player.x'), getProperty('player.y'), getProperty('player.width'), getProperty('player.height'),
		getProperty('doorEnding.x'), getProperty('doorEnding.y'), getProperty('doorEnding.width'), getProperty('doorEnding.height'))
		and keyJustPressed('down') and grounded and controlsAllowed then
			setScore(20000 - (2/3) * (timeMS / 1000) * 100);
			endSong();
		end
	end

	if dead then
		hsp = 0;
		vsp = 0;
	end

	setProperty('player.x', getProperty('player.x') + hsp);
	setProperty('player.y', getProperty('player.y') + vsp);

	setCameraPosition();

	-- Discord RPC
	if not paused then
		changePresence('Playing: FNF-C', 'Time: ' .. getTextString('timeText'));
	else
		changePresence('Playing: FNF-C', 'Paused');
	end
end

function onPause()
	pauseSound('song');
	paused = true;
end

function onResume()
	resumeSound('song');
	paused = false;
end

function onEndSong()
	return Function_Continue;
end

function beatHit(curbeat)
	if lastBeat >= curbeat then
		return;
	end

	if hsp == 0 and grounded then
		if curbeat % 2 == 0 and controlsAllowed then
			playAnimation(0, false);
			-- debugPrint('Beat Hit');
		end
	end

	if curbeat % 2 == 0 then
		for b = 0, objectsAnim - 1 do
			objectPlayAnimation('objectAnimated' .. b, 'dance', true);
		end
	end

	lastBeat = curbeat;
end

function doorTransition()
	if grounded then
		doTweenY('doorTransitionblackBoxIn1', 'box01.scale', 1, 0.85, 'backOut');
		doTweenY('doorTransitionblackBoxIn2', 'box02.scale', 1, 0.85, 'backOut');
		curSection = curSection + 1;
		controlsAllowed = false;
		-- debugPrint('Fuck!')
	end
end

function respawnPlayer()
	upsideDown = false;
	controlsAllowed = false;
	setProperty('c_bf.visible', false);
	doTweenY('blackBoxIn1', 'box01.scale', 1, 0.85, 'backOut');
	doTweenY('blackBoxIn2', 'box02.scale', 1, 0.85, 'backOut');
end

function setCameraPosition()
	camhsp = hsp;
	camvsp = vsp;

	if camBounds > 0 then
		for i = 0, camBounds - 1 do
			-- x col
			if CheckCollision(getProperty('cameraScreen.x') + camhsp, getProperty('cameraScreen.y'), getProperty('cameraScreen.width'), getProperty('cameraScreen.height'),
			getProperty('camBound'..i..'.x'), getProperty('camBound'..i..'.y'), getProperty('camBound'..i..'.width'), getProperty('camBound'..i..'.height')) then
				while math.abs(camhsp) > 0.1 do
					camhsp = camhsp * 0.5;
					if not CheckCollision(getProperty('cameraScreen.x') + camhsp, getProperty('cameraScreen.y'), getProperty('cameraScreen.width'), getProperty('cameraScreen.height'),
					getProperty('camBound'..i..'.x'), getProperty('camBound'..i..'.y'), getProperty('camBound'..i..'.width'), getProperty('camBound'..i..'.height')) then
						setProperty('cameraScreen.x', getProperty('cameraScreen.x') + camhsp);
					end
				end
				camhsp = 0;
				if cameraStuck[1] == false and getMidpointX('player') < getMidpointX('cameraScreen') - 4 then
					cameraStuck[1] = true;
				elseif cameraStuck[2] == false and getMidpointX('player') > getMidpointX('cameraScreen') + 4 then
					cameraStuck[2] = true;
				end
			end
	
			-- y col
			if CheckCollision(getProperty('cameraScreen.x'), getProperty('cameraScreen.y') + camvsp, getProperty('cameraScreen.width'), getProperty('cameraScreen.height'),
			getProperty('camBound'..i..'.x'), getProperty('camBound'..i..'.y'), getProperty('camBound'..i..'.width'), getProperty('camBound'..i..'.height')) then
				while math.abs(camvsp) > 0.1 do
					camvsp = camvsp * 0.5;
					if not CheckCollision(getProperty('cameraScreen.x'), getProperty('cameraScreen.y') + camvsp, getProperty('cameraScreen.width'), getProperty('cameraScreen.height'),
					getProperty('camBound'..i..'.x'), getProperty('camBound'..i..'.y'), getProperty('camBound'..i..'.width'), getProperty('camBound'..i..'.height')) then
						setProperty('cameraScreen.y', getProperty('cameraScreen.y') + camvsp);
					end
				end
				camvsp = 0;
			end
		end
	end

	if cameraStuck[1] == true then
		camhsp = 0;
		if getMidpointX('player') > getMidpointX('cameraScreen') then
			cameraStuck[1] = false;
		end
	elseif cameraStuck[2] == true then
		camhsp = 0;
		if getMidpointX('player') < getMidpointX('cameraScreen') then
			cameraStuck[2] = false;
		end
	end

	if vsp == 0 then
		camvsp = 0;
	end

	setProperty('cameraScreen.x', getProperty('cameraScreen.x') + camhsp);
	setProperty('cameraScreen.y', getProperty('cameraScreen.y') + camvsp);
	setProperty('camFollow.x', getProperty('cameraScreen.x') + getProperty('cameraScreen.width') / 2);
	setProperty('camFollow.y', getProperty('cameraScreen.y') + getProperty('cameraScreen.height') / 2);
end

function resetLoopTimer()
    cancelTimer('addSecond');
    runTimer('addSecond', 1);
    timeMS = timeMS + 1000;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'hideAllStuff' then -- :skull: Mostly UI stuff
		setProperty('iconP1.alpha', 0);
		setProperty('iconP2.alpha', 0);
		setProperty('scoreTxt.alpha', 0);
		setProperty('healthBar.alpha', 0);
		setProperty('healthBarBG.alpha', 0);
		for i = 0, getProperty('strumLineNotes.length') - 1 do
			setPropertyFromGroup('strumLineNotes', i, 'alpha', 0);
		end

		setProperty('boyfriend.alpha', 0);
		setProperty('dad.alpha', 0);
		setProperty('gf.alpha', 0);
		setProperty('timeTxt.visible', false);
		setProperty('timeBarBG.visible', false);
		setProperty('timeBar.visible', false);
	end

	if tag == 'startLevel' then
    	playSound('Challenge', 1, 'song');
    	runTimer('fadeBlackout', 1.6);
    	setProperty('c_bf.x', screenWidth / 4);
    	setProperty('c_bf.y', screenHeight + 93);
    	doTweenX('bfMoveXIntro', 'c_bf', screenWidth / 2 - getProperty('c_bf.width') / 2 - 16, 1.6, 'linear');
    	-- doTweenY('bfMoveYIntroUP', 'c_bf', screenHeight / 2 - 156, 0.825, 'quadOut');
        doTweenY('levelNameScaleY', 'levelName.scale', 1, 0.5, 'backOut');
        doTweenColor('levelNameFadeIn', 'levelName', 'FFFFFF', 1, 'linear');
		setProperty('c_bf.velocity.y', -1200);
		setProperty('c_bf.acceleration.y', 1115.25);
	end

	if tag == 'fadeBlackout' then
		doTweenY('goaway1', 'box01.scale', 0, 1, 'backInOut');
		doTweenY('goaway2', 'box02.scale', 0, 1, 'backInOut');
        doTweenY('levelNameScaleYaway', 'levelName.scale', 0, 1, 'backInOut');
        doTweenY('levelNameMoveY', 'levelName', -48, 1, 'backInOut');
		playAnimation(0, false);
		setProperty('c_bf.velocity.y', 0);
		setProperty('c_bf.acceleration.y', 0);
	end

	-- if tag == 'Tick' then
		-- onTick();
	-- end

    if tag == 'particleSpawn' then
        particleTimer();
    end

    if tag == 'resetCamSpeed' then
		setProperty('cameraSpeed', 1.5);
    end

    if tag == 'startTimer' then
        timerStarted = true;
        runTimer('addSecond', 1);
    end

    if tag == 'addSecond' then
        resetLoopTimer();
    end
end

function onTweenCompleted(tag)
	if tag == 'goaway2' then
		setObjectCamera('c_bf', 'game');
		controlsAllowed = true;
	end

	if tag == 'bfMoveYIntroUP' then
    	-- doTweenY('bfMoveYIntroDOWN', 'c_bf', screenHeight / 2 - 73.5, 0.8, 'quartIn');
		playAnimation(3, false);
	end

	if tag == 'levelNameMoveY' then
		-- removeLuaSprite('box01');
		-- removeLuaSprite('box02');
		removeLuaText('levelName');
	end

	if tag == 'blackBoxIn2' then
		setProperty('cameraSpeed', 100);
		setProperty('player.x', curRespawnPoint[1][1]);
		setProperty('player.y', curRespawnPoint[1][2]);
		setProperty('c_bf.flipX', curRespawnPoint[1][3]);
		setProperty('cameraScreen.x', curRespawnPoint[1][1] - 615);
		setProperty('cameraScreen.y', curRespawnPoint[1][2] - 395);
		playAnimation(0, false);
		doTweenY('blackBoxOut1', 'box01.scale', 0, 0.85, 'backOut');
		doTweenY('blackBoxOut2', 'box02.scale', 0, 0.85, 'backOut');
		setProperty('c_bf.visible', true);
		controlsAllowed = true;
		dead = false;
		runTimer('resetCamSpeed', 0.075);
	end

	if tag == 'doorTransitionblackBoxIn2' then
		loadLevelSection(curSection);
		setProperty('cameraSpeed', 100);
		setProperty('player.x', curRespawnPoint[1][1]);
		setProperty('player.y', curRespawnPoint[1][2]);
		setProperty('c_bf.flipX', curRespawnPoint[1][3]);
		setProperty('cameraScreen.x', curRespawnPoint[1][1] - 615);
		setProperty('cameraScreen.y', curRespawnPoint[1][2] - 395);
		doTweenY('doorTransitionblackBoxOut1', 'box01.scale', 0, 0.85, 'backOut');
		doTweenY('doorTransitionblackBoxOut2', 'box02.scale', 0, 0.85, 'backOut');
		runTimer('resetCamSpeed', 0.075);
	end

	if tag == 'doorTransitionblackBoxOut2' then
		controlsAllowed = true;
	end
end	

function onSoundFinished(tag)
	if tag == 'song' then
		lastBeat = 0;
		playSound('Challenge', 1, 'song');
	end
end

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function Approach(from, to, byamount)
	if from < to then
		from = from + byamount;
		if from > to then
			return to;
		end
	else
		from = from - byamount;
		if from < to then
			return to
		end
	end
	return from;
end

-- Credit: Mind Games (Uproar specifically)
-- particle logic
particleCount = 0;
particleLimit = 100;
particleTime = 4.5;
function spawnParticles()
    for i = 1, particleLimit do
        tag = ('challengeParticle'..i);
        makeLuaSprite(tag, 'challenge/challenge_particle', -10000, -10000);
        addLuaSprite(tag, true);
        setBlendMode(tag, 'add');
    end
    runTimer('particleSpawn', 0.35, 0);
end

function particleTimer()
    particleCount = particleCount + 1;
    if particleCount > particleLimit then
        particleCount = 1;
    end

    tag = ('challengeParticle'..particleCount);
    math.randomseed(getRandomInt(0) * 100 + getSoundTime('song'));
    setProperty(tag..'.scale.x', math.random(500, 1000) / 1000);
    setProperty(tag..'.scale.y', getProperty(tag..'.scale.x'));
   	setProperty(tag..'.x', math.random(getProperty('c_bf.x') - 750, getProperty('c_bf.x') + 750));
    velX = 0;
    setProperty(tag..'.velocity.x', velX);
    math.randomseed(getRandomInt(0) * 92.4 - getSoundTime('song'));
    setProperty(tag..'.y', math.random(getProperty('c_bf.y') + 360, getProperty('c_bf.y') + 720));
    setProperty(tag..'.velocity.y', math.random(-80, -240));
    setProperty(tag..'.angularVelocity', math.random(-80, 80)); -- Spin :)
    -- setProperty(tag..'.color', particleColors[getRandomInt(1, 9)]);
    doTweenColor(tag..'color', tag, particleColors[getRandomInt(1, #particleColors)], 0.001, 'linear');
    
    setProperty(tag..'.alpha', 1);
    order = getObjectOrder('c_bf') + 1;
    setObjectOrder(tag, order);

    doTweenAlpha(tag..'AlphaTween', tag, 0, particleTime, 'expoIn');
    doTweenX(tag..'ScaleX', tag..'.scale', 0, particleTime, 'expoIn');
    doTweenY(tag..'ScaleY', tag..'.scale', 0, particleTime, 'expoIn');
    --doTweenX(tag..'SpeedX', tag..'.velocity', velX * -0.75, particleTime/2, 'linear');
end

function setSongTime()
    local songCalc = timeMS;
    local secondsTotal = math.floor(songCalc / 1000);

    if secondsTotal < 0 then
        secondsTotal = 0;
    end

    setTextString('timeText', formatTime(secondsTotal));

    curSecond = getSecond(secondsTotal);
    curMinute = getMinute(secondsTotal);
end

function formatTime(seconds)
    local timeString = math.floor(seconds / 60) .. ":";
    local timeStringHelper = math.floor(seconds) % 60;

    if timeStringHelper < 10 then
        timeString = timeString .. '0';
    end

    timeString = timeString .. timeStringHelper;

    return timeString;
end

function getSecond(seconds)
    return math.floor(seconds) % 60;
end

function getMinute(seconds)
    return math.floor(seconds / 60) + ((100 / 60) * curSecond) / 100;
end