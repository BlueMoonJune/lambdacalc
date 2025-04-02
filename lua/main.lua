require "eval"
require "render"
require "defs"
require "fmt"

local expr = {Θ, {L,{{L,{{1, 2}, {SUCC, 1}}},N(0)}}}

local hist = {}

print(lambdaToString(expr))

local playing = false

local t = 0

love.audio.setEffect("reverb", {type="reverb"})
local sound = love.audio.newSource("pling.mp3", "static")
sound:setEffect("reverb")
local step = 0.5

function love.update(dt)
	if not playing then return end
	t = t + dt
	while t > step and step > 0.00001 do
		step = step * 0.99
		table.insert(hist,expr)
		expr, s = reduce(expr)
		if not s then table.remove(hist) end
		t = t - step
		if s then
			sound:setPitch(math.lerp(0.25, 4, 1/count(expr)))
			sound:stop()
			sound:play()
		end
	end
end

function love.keypressed(key)
	if key == "space" then
		playing = not playing
		t = 0.1
		step = 0.5
	end
end

function love.draw()
	local lw, lh = computeSize(expr)
	local ww, wh = love.graphics.getDimensions()
	ww, wh = ww-20, wh-60
	local s = math.min(ww/lw, wh/lh)
	love.graphics.print(lambdaToString(expr), 10, 10)
	love.graphics.scale(1, -1)
	render(expr, 10/s, -50/s - lh, s)
end

function love.mousepressed(_, _, button)
	if button == 1 then
		table.insert(hist,expr)
		expr, s = reduce(expr)
		if not s then table.remove(hist) end
		if s then
			sound:setPitch(math.lerp(0.25, 4, 1/count(expr)))
			sound:stop()
			sound:play()
		end
	elseif button == 2 then
		expr = table.remove(hist) or expr
	end
end
