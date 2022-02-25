local obj_rqueen = {}

function obj_rqueen.init()
	obj_rqueen.data = {}
	obj_rqueen.name = "obj_rqueen"
	editor.importObject("FACES", obj_rqueen.name, "obj_rqueen.new", mdl_rqueen)
end

function obj_rqueen.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(obj_rqueen.data, tbl)
end

function obj_rqueen.draw()
	local i = 1
	while i <= #obj_rqueen.data do

		local this_ent = obj_rqueen.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_rqueen)
		lg.pop()

		i = i + 1
	end
end

return obj_rqueen