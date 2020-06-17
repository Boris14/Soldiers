function love.load()
	Object = require "classic"
end

Animation = Object:extend()

function Animation:new(params)
	self.texture = params.texture
	self.frames = params.frames
	self.currentFrame = 1
	self.timer = 0
	if(params.interval) then
		self.interval = params.interval
	else
		self.interval = 1/9
	end
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end

function Animation:restart()
    self.timer = 0
    self.currentFrame = 1
end

function Animation:update(dt)
    self.timer = self.timer + dt

    while self.timer > self.interval do
        self.timer = self.timer - self.interval
        self.currentFrame = (self.currentFrame + 1) % (#self.frames + 1)
        if self.currentFrame == 0 then self.currentFrame = 1 end
    end
end
