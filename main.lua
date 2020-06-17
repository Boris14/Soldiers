function love.load()
    Object = require "classic"
    require "soldier"
	require "animation"
	
	soldiers = {}

	for i = 1, 5 do
		for j = 1, 5 do
			soldiers[i*5 + j] = Soldier(100 + i*40, 100 + j*30)
		end
	end
end

function love.update(dt)
	for i = 1, 5 do
		for j = 1, 5 do
			soldiers[i*5 + j]:update(dt)
		end
	end
end

function love.draw()
	love.graphics.setBackgroundColor(1,1,1)
	for i = 0, 24 do
		for j = 0, 24 do
			if(soldiers[i+6].y < soldiers[j+6].y) then
				soldiers[i+6], soldiers[j+6] = soldiers[j+6], soldiers[i+6]
			end
		end
	end
	for i = 1, 5 do
		for j = 1, 5 do
			soldiers[i*5 + j]:draw()
		end
	end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
	end
end

