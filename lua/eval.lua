--Lambda Calculus Interpreter designed to be used with the de Bruijn index
--
--Lambda terms are to be of the form
--  e :== n -- where `n` is a number representing the de Bruijn index
--      | {e, e}
--      | {L, e} -- where `L` is defined below
--
--`reduce` takes a lambda term and will return
--  the lambda term with a beta reduction applied, true
--		if a beta reduction was applied
--or
--  the passed lambda term unaltered, false
--		if no beta reduction occurred

L = L or 'λ'

local function overload(fAbs, fApp, fVar, fAll)
	return function (l, ...)
		if fAll then fAll(l, ...) end
		if type(l) == "table" then
			if l[1] == L then
				return fAbs(l, ...)
			end
			return fApp(l, ...)
		end
		if type(l) == "number" then
			return fVar(l, ...)
		end
	end
end

local incFree
incFree = overload(
function (l, v, d)
	d = d or 0
	return {L, incFree(l[2], v, d + 1), props = l.props}
end, function (l, v, d)
	return {incFree(l[1], v, d), incFree(l[2], v, d), props = l.props}
end, function (l, v, d)
	if l > (d or 0) then
		return l + v - 1
	end
	return l
end
)

local subst
subst = overload(
function (l, v, d)
	if d then
		return {L, subst(l[2], v, d + 1), props = l.props}
	else
		return subst(l[2], v, 1)
	end
end, function (l, v, d)
	return {subst(l[1], v, d) ,subst(l[2], v, d), props = l.props}
end, function (l, v, d)
	if l == d then
		return incFree(v, d)
	end
	if l > d then
		return l - 1
	end
	return l
end
)

reduce = overload(
function (l)
	local res, s = reduce(l[2])
	return {L, res}, s
end, function (l)
	if type(l[1]) == "table" and l[1][1] == L then
		return subst(l[1], l[2]), true
	end
	local v, s = reduce(l[1])
	if s then return {v, l[2], props = l.props}, true end
	v, s = reduce(l[2])
	if s then return {l[1], v, props = l.props}, true end
	return l, false
end, function (l)
	return l, false
end
)

count = overload(
function (l)
	return count(l[2]) + 1
end, function (l)
	return count(l[1]) + count(l[2]) + 0
end, function (l)
	return 0
end
)

