--Tromp Lambda Diagram Renderer designed to be used with the de Bruijn index
--uses Love2D for rendering
--feel free to swap it for some other rendering impl
--
--Lambda terms are to be of the form
--  e :== n -- where `n` is a number representing the de Bruijn index
--      | {e, e}
--      | {L, e} -- where `L` is defined below
--
--`render` takes a lambda term, x position, y position, and scale in pixels
--and renders the Tromp diagram
--Do note it will render upside-down if positive y is downwards
--
--if an expression in the lambda term has a field `color`, it and its children, up until another expression with a defined `color`, will be rendered with its value
--Do note that, if used with my interpreter, the color fields will not be preserved through beta-reduction, and must be set again afterwards

L = L or 'λ'

function computeSize(l)
	if type(l) == "table" then
		if l[1] == L then
			local w, h = computeSize(l[2])
			return w, h + 2
		end
		local w1, h1 = computeSize(l[1])
		local w2, h2 = computeSize(l[2])
		return w1 + w2, math.max(h1, h2) + 2
	else
		return 4, 1
	end
end

function math.lerp(a, b, t)
	return a + (b - a) * t
end

function render(l, x, y, scale)
	local mw, mh = computeSize(l)
	if type(l) == "table" then
		local prevColor
		if l.color then
			prevColor = {love.graphics.getColor()}
			love.graphics.setColor(l.color)
		end
		if l[1] == L then
			local w, h = computeSize(l[2])
			render(l[2], x, y + mh - h - 2, scale)
			--love.graphics.setColor(1, 0, 0)
			love.graphics.rectangle("fill", (x) * scale, (y+mh-1) * scale, (mw-1) * scale, scale)
		else
			local w1, h1 = computeSize(l[1], x + 0, y)
			local w2, h2 = computeSize(l[2], x + 4, y)
			render(l[1], x, y + mh - h1, scale)
			render(l[2], x + w1, y + mh - h2, scale)
			--love.graphics.setColor(0, 0, 1)
			love.graphics.rectangle("fill", (x+1) * scale, y * scale, scale, (mh - h1) * scale)
			love.graphics.rectangle("fill", (x+1) * scale, (y+2) * scale, (mw-w2) * scale, scale)
			love.graphics.rectangle("fill", (x+1+w1) * scale, (y+2) * scale, scale, (mh - h2 - 1) * scale)
		end
		if l.color then love.graphics.setColor(prevColor) end
	else
		--love.graphics.setColor(0, 1, 0)
		love.graphics.rectangle("fill", (x+1) * scale, y * scale, scale, 2 * (l) * scale)
	end
	--love.graphics.rectangle("line", x * scale + 1, y * scale + 1, mw * scale - 2, mh * scale - 2)

end
