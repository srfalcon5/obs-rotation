obs = obslua
group = ""
end_h = 0
end_m = 0
interval = 0
last_i = 0

function shuffle()
	local g = obs.obs_group_or_scene_from_source(obs.obs_get_source_by_name(group))
	local srcs = obs.obs_scene_enum_items(g)
	if not srcs then error("Provided group does not have any children. L10") end
	local n = 1
	repeat -- we repeat until a different number than the last number is found.
		math.randomseed(os.time())
		n = math.random(1,len(srcs))
	until n ~= last_i
	print(string.format("Making item %s in group visible.", n))
	for i, res in ipairs(srcs) do
		if i == n then
			obs.obs_sceneitem_set_visible(res, true)
			obs.obs_sceneitem_release(src)
		else
			obs.obs_sceneitem_set_visible(res, false)
		end
	end
	last_i = i
end

function t_callback()
	t = mktime(end_h, end_m, 0)
	if t.ts <= 0 then
		obs.remove_current_callback()
	end
	shuffle()
end

function len(T)
	local i = 0
	for _ in pairs(T) do i = i+1 end
	return i
end

-- Derived from https://github.com/srfalcon5/obs-countdown/blob/main/countdown.lua#L37-L46
function mktime(h,m,s)
	now = os.time()
	start = os.time{hour=h,min=m,sec=s,day=os.date('%d'),month=os.date('%m'),year=os.date('%Y')}
	ts = start-now
	hrs=math.floor(ts/60/60)
	min=math.floor(ts/60%60)
	sec=math.floor(ts%60%60)
	return {h=hrs,m=min,ts=ts}
end
--------------------------------------------------------
function script_description()
	return "https://github.com/srfalcon5/obs-rotation"
end
function script_properties()
	local props = obs.obs_properties_create()
	obs.obs_properties_add_int(props, "interval", "Interval (in seconds)", 0, 3600, 1)
	obs.obs_properties_add_int(props, "end_h", "Ending hour", 0, 23, 1)
	obs.obs_properties_add_int(props, "end_m", "Ending minute", 0, 59, 1)
	local p = obs.obs_properties_add_list(props, "group", "Group for rotation", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
	local srcs = obs.obs_enum_sources()
	if srcs ~= nil then
		for _, src in ipairs(srcs) do
			src_id = obs.obs_source_get_unversioned_id(src)
			if src_id == "group" then
				local name = obs.obs_source_get_name(src)
				obs.obs_property_list_add_string(p, name, name)
			end
		end
	end
	print("Rotated images")
	obs.source_list_release(srcs)
	return props
end
function script_update(settings)
	obs.timer_remove(t_callback)

	end_h = obs.obs_data_get_int(settings, "end_h")
	end_m = obs.obs_data_get_int(settings, "end_m")
	interval = obs.obs_data_get_int(settings, "interval")
	group = obs.obs_data_get_string(settings, "group")

	local src = obs.obs_get_source_by_name(group)
	if src ~= nil then
		local active = obs.obs_source_active(src)
		obs.obs_source_release(src)
		i = interval*1000
		obs.timer_add(t_callback, i)
		print("Updated settings successfully.")
	else
		error("src_name in use is nil. LXX")
	end
end
function script_defaults(settings)
	obs.obs_data_set_default_int(settings, "interval", 300)
	obs.obs_data_set_default_int(settings, "end_h", 10)
	obs.obs_data_set_default_int(settings, "end_m", 40)
	print("Defaults set from LXXX:XXX")
end
function script_laod(settings)
	print("Script has loaded *relatively* safely.")
end
