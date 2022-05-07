if curBeat % 2 == 0 then
    if mustHitSection == false then
        health = getProperty('health')
        if getProperty('health') > 0.3 and getProperty('boyfriend.curCharacter') ~= 'bf@NOWYOU' then
            setProperty('health', health- 0.025);
        end
    end
elseif curBeat % 2 == 1 then
    if mustHitSection == false then
        health = getProperty('health')
        if getProperty('health') > 0.4 and getProperty('boyfriend.curCharacter') ~= 'bf@NOWYOU' then
            setProperty('health', health- 0.032);
        end
    end
end