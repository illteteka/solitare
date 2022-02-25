c_black = {0,0,0,1}
c_white = {1,1,1,1}

--[[
	Returns true if the two rects are colliding
]]
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return	x1 < x2+w2 and
			x2 < x1+w1 and
			y1 < y2+h2 and
			y2 < y1+h1
end

function setMask(r, g, b)
    shader_mask:send("_r", r)
    shader_mask:send("_g", g)
    shader_mask:send("_b", b)
end

function getSquare(n)
	local p = 1
	while p < n do
		p = p * 2
	end
	return p
end

function hsl(h, s, l, a)
	local tbl = {}
	if s<=0 then return l/255,l/255,l/255,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end
	table.insert(tbl, (r+m))
	table.insert(tbl, (g+m))
	table.insert(tbl, (b+m))
	table.insert(tbl, a)
	return tbl
end

function print_r ( t )
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
						print(indent..string.rep(" ",string.len(pos)+6).."}")
					elseif (type(val)=="string") then
						print(indent.."["..pos..'] => "'..val..'"')
					else
						print(indent.."["..pos.."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end
		end
	end
	if (type(t)=="table") then
		print(tostring(t).." {")
		sub_print_r(t,"  ")
		print("}")
	else
		sub_print_r(t,"  ")
	end
	print()
end