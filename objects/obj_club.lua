local obj_club = {}

function obj_club.init()
	obj_club.data = {}
	obj_club.name = "obj_club"
	editor.importObject("SUITS", obj_club.name, "obj_club.new", mdl_club)
end

function obj_club.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(obj_club.data, tbl)
end

function obj_club.draw()
	local i = 1
	while i <= #obj_club.data do

		local this_ent = obj_club.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_club)
		lg.pop()

		i = i + 1
	end
end

return obj_club