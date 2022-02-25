local obj_diamond = {}

function obj_diamond.init()
	obj_diamond.data = {}
	obj_diamond.name = "obj_diamond"
	editor.importObject("SUITS", obj_diamond.name, "obj_diamond.new", mdl_diamond)
end

function obj_diamond.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(obj_diamond.data, tbl)
end

function obj_diamond.draw()
	local i = 1
	while i <= #obj_diamond.data do

		local this_ent = obj_diamond.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_diamond)
		lg.pop()

		i = i + 1
	end
end

return obj_diamond