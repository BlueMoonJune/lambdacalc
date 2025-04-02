---@diagnostic disable: unicode-name

L = L or 'λ'

local function _num(n)
	if n == 0 then
		return 1
	end
	return {2, _num(n-1)}
end

--Combinators
I = {L, 1}
Y = {L,{{L,{2,{1,1}}},{L,{2,{1,1}}}}}
Θ = {{L,{L,{1,{L,{{{3,3},2},1}}}}},{L,{L,{1,{L,{{{3,3},2},1}}}}}}

Ω = {{L,{1,1}},{L,{1,1}}}
Ω3 = {{L,{{1,1},1}},{L,{{1,1},1}}}

--Booleans
TRUE = {L,{L,2}}
FALSE = {L,{L,1}}

--Math
SUCC = {L,{L,{L,{2, {{3, 2}, 1}}}}}
ADD = {L,{L,{L,{L,{{4, 2}, {{3, 2}, 1}}}}}}
MUL = {L,{L,{L,{2,{3,1}}}}}
EXP = {L,{L,{1,2}}}

--Lists
PAIR = {L,{L,{L,{{1,3},2}}}}
FIRST = TRUE
SECOND = FALSE
INDEX = {{1, FALSE}, TRUE}

function N(n)
	return {L,{L,_num(n)}}
end

function List(l, ...)
	if not l then return I end
	return {L,{{1,l}, List(...)}}
end
