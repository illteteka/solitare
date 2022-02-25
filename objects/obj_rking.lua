local obj_rking = {}

function obj_rking.init()
	obj_rking.data = {}
	obj_rking.name = "obj_rking"
	editor.importObject("FACES", obj_rking.name, "obj_rking.new", mdl_rking)
end

function obj_rking.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(obj_rking.data, tbl)
end

function obj_rking.draw()
	local i = 1
	while i <= #obj_rking.data do

		local this_ent = obj_rking.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_rking)
		lg.pop()

		i = i + 1
	end
end

return obj_rking