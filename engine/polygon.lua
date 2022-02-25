import = require "engine.import"

local polygon = {}

function polygon.init()
	polygon.data = {}
	polygon.cache = {}
end

function polygon.new(fname, cache)
	
	return import.open(fname, cache)

end

function polygon.toggleLayer(tbl, layer, visible)

	local this_model = polygon.data[tbl]
	if this_model[layer] ~= nil then
		this_model[layer].visible = visible
	else
		print("Error: vector does not contain a shape at layer " .. layer)
	end

end

function polygon.draw(mname, force)

	local tbl = polygon.data[mname]
	local skip_draw = false
	
	if not force then force = false end
	
	if tbl.canvas ~= nil and force == false then
		local scale_factor = tbl.canvas_scale_factor
		lg.draw(tbl.canvas, 0, 0, 0, 1/scale_factor, 1/scale_factor)
		skip_draw = true
	end

	if not skip_draw then
		local i = 1
		
		while i <= #tbl do
			
			if tbl[i].visible then
				
				lg.push()

				local clone = tbl[i]
				
				lg.setColor(clone.color)
				
				-- Draw the shape
				if clone.kind == "polygon" then
				
					local j = 1
					while j <= #clone.raw do
					
						-- Draw triangle if the vertex[i] contains references to two other vertices (va and vb)
						if clone.raw[j].vb ~= nil then
							
							local a_loc, b_loc = clone.raw[j].va, clone.raw[j].vb
							local aa, bb, cc = clone.raw[j], clone.raw[a_loc], clone.raw[b_loc]
							lg.polygon("fill", aa.x, aa.y, bb.x, bb.y, cc.x, cc.y)
							dev.tri_count = dev.tri_count + 1
							
						end
						
						j = j + 1
					
					end
				
				elseif clone.kind == "ellipse" then
				
					if #clone.raw > 1 then
					
						-- Load points from raw
						local aa, bb = clone.raw[1], clone.raw[2]
						local cx, cy, cw, ch
						
						-- Calculate w/h
						cw = math.abs(aa.x - bb.x) / 2
						ch = math.abs(aa.y - bb.y) / 2
						
						-- Make x/y the points closest to the north west
						if bb.x < aa.x then cx = bb.x else cx = aa.x end
						if bb.y < aa.y then cy = bb.y else cy = aa.y end
						
						cx = cx + cw
						cy = cy + ch
						
						local cseg, cang = clone.segments, clone._angle
						
						-- Ellipse vars
						local v, k = 0, 0
						local cinc = (360 / cseg)
						local _rad, _cos, _sin = math.rad, math.cos, math.sin
						
						while k < cseg do
			
							local cx2, cy2, cx3, cy3, cxx2, cyy2, cxx3, cyy3
							cx2 = polygon.lengthdir_x(cw, _rad(v))
							cy2 = polygon.lengthdir_y(ch, _rad(v))
							cx3 = polygon.lengthdir_x(cw, _rad(v + cinc))
							cy3 = polygon.lengthdir_y(ch, _rad(v + cinc))
							
							if (cang % 360 ~= 0) then
								local cang2 = _rad(-cang)
								local cc, ss = _cos(cang2), _sin(cang2)
								cxx2 = polygon.rotateX(cx2, cy2, 0, 0, cc, ss)
								cyy2 = polygon.rotateY(cx2, cy2, 0, 0, cc, ss)
								cxx3 = polygon.rotateX(cx3, cy3, 0, 0, cc, ss)
								cyy3 = polygon.rotateY(cx3, cy3, 0, 0, cc, ss)
							else -- Do less math if not rotating
								cxx2, cyy2, cxx3, cyy3 = cx2, cy2, cx3, cy3
							end
							
							lg.polygon("fill", cx, cy, (cx + cxx2), (cy + cyy2), (cx + cxx3), (cy + cyy3))
							dev.tri_count = dev.tri_count + 1
							
							v = v + cinc
							k = k + 1
						
						end
					
					end
				
				end
				
				lg.pop()
			end
			-- End of drawing the shape
			
			i = i + 1
		end
	end -- end skip_draw

end

function polygon.width(model)
	return polygon.data[model].width
end

function polygon.height(model)
	return polygon.data[model].height
end

function polygon.lengthdir_x(length, dir)
	return length * math.cos(dir)
end

function polygon.lengthdir_y(length, dir)
	return -length * math.sin(dir)
end

function polygon.addCache(model)
	table.insert(polygon.cache, model)
end

function polygon.rebuildCache()
	local i = 1
	while i <= #polygon.cache do
		local this_model = polygon.cache[i]
		local zooms = MAX_GUI_SCALE * DPI_SCALE * EXPECTED_MAX_ZOOM
		local ow, oh = polygon.width(this_model), polygon.height(this_model)
		local ww, hh = getSquare(ow * zooms), getSquare(oh * zooms)
		
		if polygon.data[this_model].canvas ~= nil then
			polygon.data[this_model].canvas:release()
		end
		
		polygon.data[this_model].canvas = lg.newCanvas(ww, hh)
		
		local start_factor = math.min(ow, oh)
		local end_factor = math.min(ww, hh)
		local scale_factor = end_factor/start_factor
		
		polygon.data[this_model].canvas_scale_factor = scale_factor
		
		lg.setCanvas(polygon.data[this_model].canvas)
			lg.push()
			lg.scale(scale_factor)
			polygon.draw(this_model, true)
			lg.pop()
		lg.setCanvas()
		
		i = i + 1
	end
end

function polygon.clearCache()
	local i = 1
	while i <= #polygon.cache do
		polygon.data[polygon.cache[i]].canvas:release()
		i = i + 1
	end
	polygon.cache = {}
end

function polygon.rotateX(x, y, px, py, c, s)
	return (c * (x - px) + s * (y - py) + px)
end

function polygon.rotateY(x, y, px, py, c, s)
	return (s * (x - px) - c * (y - py) + py)
end

return polygon