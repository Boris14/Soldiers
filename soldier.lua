math.randomseed( os.time() )
math.random(); math.random(); math.random()

function love.load()
    Object = require "classic"
end

SOLDIER_SPEED = 150

Soldier = Object:extend()

function Soldier:new(x, y)
    self.x = x
	self.y = y
	self.orders = {x = x, y = y}
	self.dx = 0
	self.dy = 0
	self.attackTimer = 1
	self.rollTimer = 1
	self.sleepTimer = 0
	self.sleepDuration = math.random(1, 400) / 1000
	self.direction = {horizontal = 'right', vertical = 'down'}
	self.animations = {
		['idledownnone'] = Animation({texture = love.graphics.newImage('ww1Game/idleSoldierHalfDown.png'),
								frames = {
									love.graphics.newQuad(0, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*2, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*3, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*4, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*5, 0, 130, 130, 130*6, 130)			
								}	
							}),
		['idleupnone'] = Animation({texture = love.graphics.newImage('ww1Game/idleSoldierHalfUp.png'),
								frames = {
									love.graphics.newQuad(0, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*2, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*3, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*4, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*5, 0, 130, 130, 130*6, 130)			
								}	
							}),
		['runningdownnone'] = Animation({texture = love.graphics.newImage('ww1Game/runningSoldierHalfDown.png'),
								frames = {
									love.graphics.newQuad(0, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*2, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*3, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*4, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*5, 0, 130, 130, 130*6, 130)			
								}	
							}),
		['runningupnone'] = Animation({texture = love.graphics.newImage('ww1Game/runningSoldierHalfUp.png'),
								frames = {
									love.graphics.newQuad(0, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*2, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*3, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*4, 0, 130, 130, 130*6, 130),
									love.graphics.newQuad(130*5, 0, 130, 130, 130*6, 130)			
								}	
							}),
		['firingnoneright'] = Animation({texture = love.graphics.newImage('ww1Game/firingSoldierSide.png'),
								frames = {
									love.graphics.newQuad(0, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*2, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*3, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*4, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*5, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*6, 0, 130, 130, 130*7, 130)			
								},
								interval = 0.08	
							}),
		['firingdownright'] = Animation({texture = love.graphics.newImage('ww1Game/firingSoldierHalfDown.png'),
								frames = {
									love.graphics.newQuad(0, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*2, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*3, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*4, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*5, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*6, 0, 130, 130, 130*7, 130)			
								},
								interval = 0.08	
							}),
		['firingupright'] = Animation({texture = love.graphics.newImage('ww1Game/firingSoldierHalfUp.png'),
								frames = {
									love.graphics.newQuad(0, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*2, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*3, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*4, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*5, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*6, 0, 130, 130, 130*7, 130)			
								},
								interval = 0.08
							}),
		['firingupnone'] = Animation({texture = love.graphics.newImage('ww1Game/firingSoldierUp.png'),
								frames = {
									love.graphics.newQuad(0, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*2, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*3, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*4, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*5, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*6, 0, 130, 130, 130*7, 130)			
								},
								interval = 0.08	
							}),
		['firingdownnone'] = Animation({texture = love.graphics.newImage('ww1Game/firingSoldierDown.png'),
								frames = {
									love.graphics.newQuad(0, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*2, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*3, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*4, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*5, 0, 130, 130, 130*7, 130),
									love.graphics.newQuad(130*6, 0, 130, 130, 130*7, 130)			
								},
								interval = 0.08	
							}),
		['rollingdownnone'] = Animation({texture = love.graphics.newImage('ww1Game/rollingSoldierHalfDown.png'),
								frames = {
									love.graphics.newQuad(0, 0, 130, 130, 130*10, 130),
									love.graphics.newQuad(130, 0, 130, 130, 130*10, 130),
									love.graphics.newQuad(130*2, 0, 130, 130, 130*10, 130),
									love.graphics.newQuad(130*3, 0, 130, 130, 130*10, 130),
									love.graphics.newQuad(130*4, 0, 130, 130, 130*10, 130),
									love.graphics.newQuad(130*5, 0, 130, 130, 130*10, 130),
									love.graphics.newQuad(130*6, 0, 130, 130, 130*10, 130),
									love.graphics.newQuad(130*7, 0, 130, 130, 130*10, 130),
									love.graphics.newQuad(130*8, 0, 130, 130, 130*10, 130),
									love.graphics.newQuad(130*9, 0, 130, 130, 130*10, 130)			
								},
								interval = 0.08	
							})
	}
	self.animations['runningupleft'] = self.animations['runningupnone']
	self.animations['runningupright'] = self.animations['runningupnone']
	self.animations['runningdownleft'] = self.animations['runningdownnone']
	self.animations['runningdownright'] = self.animations['runningdownnone']
	self.animations['runningnoneleft'] = self.animations['runningdownleft']
	self.animations['runningnoneright'] = self.animations['runningdownright']
	self.animations['idleupleft'] = self.animations['idleupnone']
	self.animations['idleupright'] = self.animations['idleupnone']
	self.animations['idledownleft'] = self.animations['idledownnone']
	self.animations['idledownright'] = self.animations['idledownnone']
	self.animations['idlenoneleft'] = self.animations['idledownleft']
	self.animations['idlenoneright'] = self.animations['idledownright']
	self.animations['firingnoneleft'] = self.animations['firingnoneright']
	self.animations['firingupleft'] = self.animations['firingupright']
	self.animations['firingdownleft'] = self.animations['firingdownright']
	self.animations['rollingdownleft'] = self.animations['rollingdownnone']
	self.animations['rollingdownright'] = self.animations['rollingdownleft']
	self.animations['rollingupnone'] = self.animations['rollingdownleft']
	self.animations['rollingupleft'] = self.animations['rollingdownleft']
	self.animations['rollingupright'] = self.animations['rollingdownleft']
	self.animations['rollingnoneright'] = self.animations['rollingdownleft']
	self.animations['rollingnoneleft'] = self.animations['rollingdownleft']
	self.behaviors = {
		['idle'] = function(dt)
			self.attackTimer = self.attackTimer + dt
			if love.keyboard.isDown('j') and self.attackTimer > 0.8 then
				self.sleepTimer = 0
				self.state = 'firing'
				self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]:restart()
				self.animation = self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]
				self.attackTimer = 0
				self.dx = 0		
				self.dy = 0	
				return
			end
			self.rollTimer = self.rollTimer + dt
			if love.keyboard.isDown('lshift') and self.rollTimer > 0.7 then
				self.sleepTimer = 0
				self.state = 'rolling'
				self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]:restart()
				self.animation = self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]
				self.rollTimer = 0
				if(self.direction.vertical == 'up') then
					self.dy = -SOLDIER_SPEED * 2
				elseif(self.direction.vertical == 'down') then
					self.dy = SOLDIER_SPEED * 2
				else
					self.dy = 0
				end
				if(self.direction.horizontal == 'left') then
					self.dx = -SOLDIER_SPEED * 2
				elseif(self.direction.horizontal == 'right') then
					self.dx = SOLDIER_SPEED * 2
				else
					self.dx = 0	
				end		
				return
			end
			if love.keyboard.isDown('w') then
				if (self.direction.vertical == 'down') then
					self.sleepTimer = 0
				end
				self.state = 'running' 
				self.sleepTimer = 0
				self.direction.vertical = 'up'
				self.dy = -SOLDIER_SPEED
				if love.keyboard.isDown('a') then
					self.direction.horizontal = 'left'
					self.dx = -SOLDIER_SPEED
				elseif love.keyboard.isDown('d') then
					self.direction.horizontal = 'right'
					self.dx = SOLDIER_SPEED
				else
					self.direction.horizontal = 'none'
					self.dx = 0
				end
			elseif love.keyboard.isDown('s') then
				if (self.direction.vertical == 'up') then
					self.sleepTimer = 0
				end
				self.state = 'running'
				self.direction.vertical = 'down'
				self.dy = SOLDIER_SPEED
				if love.keyboard.isDown('a') then
					self.direction.horizontal = 'left'
					self.dx = -SOLDIER_SPEED
				elseif love.keyboard.isDown('d') then
					self.direction.horizontal = 'right'
					self.dx = SOLDIER_SPEED
				else
					self.direction.horizontal = 'none'
					self.dx = 0
				end
			elseif love.keyboard.isDown('a') then
				if (self.direction.horizontal == 'right') then
					self.sleepTimer = 0
				end
				self.state = 'running' 
				self.sleepTimer = 0
				self.direction.horizontal = 'left'
				self.dx = -SOLDIER_SPEED
				self.direction.vertical = 'none'
				self.dy = 0
			elseif love.keyboard.isDown('d') then
				if (self.direction.horizontal == 'left') then
					self.sleepTimer = 0
				end
				self.state = 'running' 
				self.sleepTimer = 0
				self.direction.horizontal = 'right'
				self.dx = SOLDIER_SPEED
				self.direction.vertical = 'none'
				self.dy = 0
			end
			if self.direction.vertical ~= 'none' then
				self.animation = self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]
			else
				self.animation = self.animations[self.state .. 'down' .. self.direction.horizontal]
			end
		end,
		
		['running'] = function(dt)
			self.attackTimer = self.attackTimer + dt
			if love.keyboard.isDown('j') and self.attackTimer > 0.8 then
				self.sleepTimer = 0
				self.state = 'firing'
				self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]:restart()
				self.animation = self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]
				self.attackTimer = 0
				self.dx = 0		
				self.dy = 0	
				return
			end
			self.rollTimer = self.rollTimer + dt
			if love.keyboard.isDown('lshift') and self.rollTimer > 0.7 then
				self.sleepTimer = 0
				self.state = 'rolling'
				self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]:restart()
				self.animation = self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]
				self.rollTimer = 0
				if(self.direction.vertical == 'up') then
					self.dy = -SOLDIER_SPEED * 2
				elseif(self.direction.vertical == 'down') then
					self.dy = SOLDIER_SPEED * 2
				else
					self.dy = 0
				end
				if(self.direction.horizontal == 'left') then
					self.dx = -SOLDIER_SPEED * 2
				elseif(self.direction.horizontal == 'right') then
					self.dx = SOLDIER_SPEED * 2
				else
					self.dx = 0	
				end
				return
			end
			if love.keyboard.isDown('w') then
				if (self.direction.vertical == 'down') then
					self.sleepTimer = 0
				end
				self.direction.vertical = 'up'
				self.dy = -SOLDIER_SPEED
				if love.keyboard.isDown('a') then
					self.direction.horizontal = 'left'
					self.dx = -SOLDIER_SPEED
				elseif love.keyboard.isDown('d') then
					self.direction.horizontal = 'right'
					self.dx = SOLDIER_SPEED
				else
					self.direction.horizontal = 'none'
					self.dx = 0
				end
			elseif love.keyboard.isDown('s') then
				if (self.direction.vertical == 'up') then
					self.sleepTimer = 0
				end
				self.direction.vertical = 'down'
				self.dy = SOLDIER_SPEED
				if love.keyboard.isDown('a') then
					self.direction.horizontal = 'left'
					self.dx = -SOLDIER_SPEED
				elseif love.keyboard.isDown('d') then
					self.direction.horizontal = 'right'
					self.dx = SOLDIER_SPEED
				else
					self.direction.horizontal = 'none'
					self.dx = 0
				end
			elseif love.keyboard.isDown('a') then
				if (self.direction.horizontal == 'right') then
					self.sleepTimer = 0
				end
				self.direction.horizontal = 'left'
				self.dx = -SOLDIER_SPEED
				self.direction.vertical = 'none'
				self.dy = 0
			elseif love.keyboard.isDown('d') then
				if (self.direction.horizontal == 'left') then
					self.sleepTimer = 0
				end
				self.direction.horizontal = 'right'
				self.dx = SOLDIER_SPEED
				self.direction.vertical = 'none'
				self.dy = 0
			else
				self.sleepTimer = 0
				self.state = 'idle'
				self.dx = 0		
				self.dy = 0	
			end
			if self.direction.vertical ~= 'none' then
				self.animation = self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]
			else
				self.animation = self.animations[self.state .. 'down' .. self.direction.horizontal]
			end
		end,
		['firing'] = function(dt)
			self.attackTimer = self.attackTimer + dt
			if self.attackTimer < self.animation.interval * 7 then
				return
			else
				self.attackTimer = 0
			end
			if love.keyboard.isDown('w') then
				self.dy = -SOLDIER_SPEED
				self.state = 'running'
				self.direction.vertical = 'up'
				self.animations['running' .. self.direction.vertical .. self.direction.horizontal]:restart()
			elseif love.keyboard.isDown('s') then
				self.dy = SOLDIER_SPEED
				self.state = 'running'
				self.direction.vertical = 'down'
				self.animations['running' .. self.direction.vertical .. self.direction.horizontal]:restart()
			elseif love.keyboard.isDown('a') then
				self.direction.horizontal = 'left'
				self.state = 'running'
				self.animations['running' .. self.direction.vertical .. self.direction.horizontal]:restart()
				self.dx = -SOLDIER_SPEED
				self.dy = 0
			elseif love.keyboard.isDown('d') then
				self.direction.horizontal = 'right'
				self.state = 'running'
				self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]:restart()
				self.dx = SOLDIER_SPEED
				self.dy = 0
			else
				self.state = 'idle'
				self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]:restart()
				self.dy = 0
				self.dx = 0						
			end
			self.animation = self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]
		end,
		['rolling'] = function(dt)
			self.rollTimer = self.rollTimer + dt
			if self.rollTimer < self.animation.interval * 10 then
				return
			else
				self.rollTimer = 0
			end
			if love.keyboard.isDown('w') then
				self.dy = -SOLDIER_SPEED
				self.state = 'running'
				self.direction.vertical = 'up'
				self.animations['running' .. self.direction.vertical .. self.direction.horizontal]:restart()
			elseif love.keyboard.isDown('s') then
				self.dy = SOLDIER_SPEED
				self.state = 'running'
				self.direction.vertical = 'down'
				self.animations['running' .. self.direction.vertical .. self.direction.horizontal]:restart()
			elseif love.keyboard.isDown('a') then
				self.direction.horizontal = 'left'
				self.state = 'running'
				self.animations['running' .. self.direction.vertical .. self.direction.horizontal]:restart()
				self.dx = -SOLDIER_SPEED
				self.dy = 0
			elseif love.keyboard.isDown('d') then
				self.direction.horizontal = 'right'
				self.state = 'running'
				self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]:restart()
				self.dx = SOLDIER_SPEED
				self.dy = 0
			else
				self.state = 'idle'
				self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]:restart()
				self.dy = 0
				self.dx = 0						
			end
			self.animation = self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]

		end
	}
	self.state = 'idle' 
	self.animation = self.animations[self.state .. self.direction.vertical .. self.direction.horizontal]
end

function Soldier:update(dt)
	self.behaviors[self.state](dt)
	if self.sleepTimer < self.sleepDuration or self.sleepTimer == 0 then
		self:sleep(dt)
		if(self.sleepTimer >= self.sleepDuration) then
			self.sleepDuration = math.random(-100, 200) / 1000
		end
	elseif self.sleepDuration < 0 then
		self.sleepDuration = 0	
	else	
		self.animation:update(dt)
		self.x = self.x + self.dx * dt
		self.y = self.y + self.dy * dt
	end
	self.currentFrame = self.animation:getCurrentFrame()
end

function Soldier:draw()
    local scaleX
	local addX = 0

    if self.direction.horizontal == 'left' then
        scaleX = -1
		addX = 130
    else
        scaleX = 1
    end


    love.graphics.draw(self.animation.texture, 
						self.currentFrame, 
						math.floor(self.x + addX),
    					math.floor(self.y), 
						0, 
						scaleX, 1)
end

function Soldier:sleep(dt)
	self.sleepTimer = self.sleepTimer + dt
	if self.state ~= 'rolling' then
		self.dx = self.dx * 0.2
		self.dy = self.dy * 0.2
	end
end

