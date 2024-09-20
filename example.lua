local ui = {
	window = nil,
	tabs = {}
}
do
	--// Example
	local window = library:New({
		Size = UDim2.new(0, 600, 0, 500)
	});

	local watermark = library:Watermark({Name = ""});

	window:Seperator({Name = "Combat"});
	ui.tabs["legit"] = window:Page({Name = "Legit", Icon = "http://www.roblox.com/asset/?id=6023426921"});
	ui.tabs["rage"] = window:Page({Name = "Rage", "http://www.roblox.com/asset/?id=6023426921"});
	window:Seperator({Name = "Visuals"});
	ui.tabs["world"] = window:Page({Name = "World", Icon = "http://www.roblox.com/asset/?id=6034684930"});
	ui.tabs["view"] = window:Page({Name = "View", Icon = "http://www.roblox.com/asset/?id=6031075931"});
	window:Seperator({Name = "Player"});
	ui.tabs["movement"] = window:Page({Name = "Movement", Icon = "http://www.roblox.com/asset/?id=6034754445"});
	ui.tabs["anti_aim"] = window:Page({Name = "Anti Aim", Icon = "http://www.roblox.com/asset/?id=14760676189"});
	window:Seperator({Name = "Settings"});
	ui.tabs["settings"] = window:Page({Name = "Settings", Icon = "http://www.roblox.com/asset/?id=6031280882"});

	--// legit
	do
		--// sections
		local legit_main_assist = ui.tabs["legit"]:Section({Name = "Assist", Side = "Left", Size = 420});
		local legit_silent_aim = ui.tabs["legit"]:Section({Name = "Silent Aim", Side = "Right", Size = 420});

		--// main assist
		do
			--// main assist section
			do
				local main_toggle = legit_main_assist:Toggle({Name = "Enabled", Flag = "legit_assist_enabled"});
				local main_toggle_option_list = main_toggle:OptionList({});
				main_toggle_option_list:List({Name = "Type", Flag = "legit_assist_type", Options = {"Camera", "Mouse"}, Default = "Camera"});
				main_toggle_option_list:List({Name = "Aim Part", Flag = "legit_assist_part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "HumanoidRootPart"});

				legit_main_assist:Keybind({Flag = "legit_assist_key", Name = "Target Bind", Default = Enum.KeyCode.E, Mode = "Toggle", Callback = function()
					local assist_enabled = flags["legit_assist_enabled"];
					local fov_enabled = flags["legit_assist_settings_use_field_of_view"];
					local fov_radius = flags["legit_assist_settings_field_of_view_radius"];
					local checks_enabled = flags["legit_assist_checks_enabled"];
					local check_values = flags["legit_assist_checks"];
					local auto_switch_enabled = flags["legit_assist_auto_switch"];

					if (not (assist_enabled)) then return end;

					local new_target = combat.get_closest_player(fov_enabled, fov_radius, checks_enabled, check_values);

					locals.assist.is_targetting = (new_target and not locals.assist.is_targetting or false);

					if (auto_switch_enabled and new_target and not locals.assist.is_targetting) then
						locals.assist.is_targetting = true;
					end;

					locals.assist.target = (locals.assist.is_targetting and new_target or nil);
				end});

				local mouse_tp_toggle = legit_main_assist:Toggle({Name = "Mouse TP", Flag = "legit_assist_mouse_tp_enabled"});


				local option_list_mouse_tp = mouse_tp_toggle:OptionList({});

				option_list_mouse_tp:Keybind({Flag = "legit_assist_mouse_tp_key", Name = "Keybind", Default = Enum.KeyCode.C, Mode = "Toggle", Callback = function()
					local assist_enabled = flags["legit_assist_enabled"];
					local mouse_tp_enabled = flags["legit_assist_mouse_tp_enabled"];
		
					if (not (assist_enabled or mouse_tp_enabled or (locals.assist.is_targetting and locals.assist.target))) then return end;

					local predicted_position = assist.get_predicted_position();
					local screen_predicted_position = utility.world_to_screen(predicted_position);
					assist.move_mouse(screen_predicted_position.position, 5);
				end});

				local smoothing_toggle = legit_main_assist:Toggle({Name = "Smoothing", Flag = "legit_assist_smoothing_enabled"});
				local smoothing_option_list = smoothing_toggle:OptionList({});
				smoothing_option_list:Slider({Name = "Smoothing Amount", Flag = "legit_assist_smoothing_amount", Default = 1, Minimum = 1, Maximum = 100, Decimals = 0.01, Ending = "%"});


				legit_main_assist:Toggle({Name = "Auto Switch", Flag = "legit_assist_auto_switch"});

				local air_aimpart_toggle = legit_main_assist:Toggle({Name = "Air Aim Part", Flag = "legit_assist_use_air_hit_part"});
				local air_aimpart_option_list = air_aimpart_toggle:OptionList({});
				air_aimpart_option_list:List({Name = "Air Aim Part", Flag = "legit_assist_air_part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "LowerTorso"});

				local resolver_toggle = legit_main_assist:Toggle({Name = "Resolver", Flag = "legit_assist_resolver"});
				local resolve_option_list = resolver_toggle:OptionList({});
				resolve_option_list:List({Name = "Method", Flag = "legit_assist_resolver_method", Options = {"Recalculate", "MoveDirection"}, Default = "Recalculate"});
				resolve_option_list:Slider({Name = "Update Time", Flag = "legit_assist_resolver_update_time", Default = 100, Minimum = 1, Maximum = 200, Decimals = 0.001, Ending = "ms"});

				local anti_ground_toggle = legit_main_assist:Toggle({Name = "Anti Ground Shots", Flag = "legit_assist_anti_ground_shots"});
				local anti_ground_option_list = anti_ground_toggle:OptionList({});
				anti_ground_option_list:Slider({Name = "To Take Off", Flag = "legit_assist_anti_ground_shots_to_take_off", Default = 2, Minimum = 0.1, Maximum = 10, Decimals = 0.01, Ending = "'"});

				local stutter_toggle = legit_main_assist:Toggle({Name = "Stutter", Flag = "legit_assist_stutter_enabled"});
				local stutter_option_list = stutter_toggle:OptionList({});
				stutter_option_list:Slider({Name = "Amount", Flag = "legit_assist_stutter_amount", Default = 1, Minimum = 1, Maximum = 10, Decimals = 0.01, Ending = "s"});

				local shake_toggle = legit_main_assist:Toggle({Name = "Shake", Flag = "legit_assist_shake_enabled"});
				local shake_option_list = shake_toggle:OptionList({});
				shake_option_list:Slider({Name = "Amount", Flag = "legit_assist_shake_amount", Default = 0.01, Minimum = 0.01, Maximum = 10, Decimals = 0.001, Ending = "'"});

				local checks_toggle = legit_main_assist:Toggle({Name = "Checks", Flag = "legit_assist_checks_enabled"});
				local checks_option_list = checks_toggle:OptionList({});
				checks_option_list:List({Name = "Checks", Flag = "legit_assist_checks", Options = {"Knocked", "Grabbed", "Friend", "Wall", "Vehicle"}, Default = {"Knocked"}, Max = 5});

				local fov_toggle = legit_main_assist:Toggle({Name = "Use Field Of View", Flag = "legit_assist_settings_use_field_of_view"});
				local fov_option_list = fov_toggle:OptionList({});

				fov_option_list:Colorpicker({Name = "Color", Flag = "legit_assist_settings_field_of_view_color", Default = default_color});
				fov_option_list:Slider({Name = "Radius", Flag = "legit_assist_settings_field_of_view_radius", Default = 1, Minimum = 1, Maximum = 200, Decimals = 0.01, Ending = "%"});
				fov_option_list:Slider({Name = "Transparency", Flag = "legit_assist_settings_field_of_view_transparency", Default = 0, Minimum = 0, Maximum = 1, Decimals = 0.01, Ending = "%"});

				legit_main_assist:Textbox({Name = "Prediction", Flag = "legit_assist_prediction", Default = "0.134", PlaceHolder = "Prediction"});
			end;

			--// silent aim section
			do
				legit_silent_aim:Toggle({Name = "Enabled", Flag = "legit_silent_enabled"});
				legit_silent_aim:Toggle({Name = "Closest Body Part", Flag = "legit_silent_closest_body_part"});
				legit_silent_aim:Toggle({Name = "Anti Aim Viewer", Flag = "legit_silent_anti_aim_viewer"});
				
				local resolver_toggle = legit_silent_aim:Toggle({Name = "Resolver", Flag = "legit_silent_resolver"});
				local resolver_option_list = resolver_toggle:OptionList({});
				resolver_option_list:List({Name = "Method", Flag = "legit_silent_resolver_method", Options = {"Recalculate", "MoveDirection"}, Default = "Recalculate"});
				resolver_option_list:Slider({Name = "Update Time", Flag = "legit_silent_resolver_update_time", Default = 100, Minimum = 1, Maximum = 200, Decimals = 0.001, Ending = "ms"});
				
				local fov_toggle = legit_silent_aim:Toggle({Name = "Field Of View", Flag = "legit_silent_use_field_of_view"});
				local fov_option_list = fov_toggle:OptionList({});
				fov_option_list:Toggle({Name = "Visualize", Flag = "legit_silent_visualize_field_of_view"});
				fov_option_list:Colorpicker({Name = "Color", Flag = "legit_silent_field_of_view_color", Default = default_color});
				fov_option_list:Slider({Name = "Transparency", Flag = "legit_silent_field_of_view_transparency", Default = 0, Minimum = 0, Maximum = 1, Decimals = 0.01, Ending = "%"});
				fov_option_list:Slider({Name = "Radius", Flag = "legit_silent_field_of_view_radius", Default = 1, Minimum = 1, Maximum = 200, Decimals = 0.01, Ending = "%"});
				
				local line_toggle = legit_silent_aim:Toggle({Name = "Line", Flag = "legit_silent_aim_tracer_enabled"});
				local line_option_list = line_toggle:OptionList({});
				line_option_list:Colorpicker({Name = "Color", Flag = "legit_silent_aim_tracer_color", Default = default_color});
				line_option_list:Slider({Name = "Line Thickness", Flag = "legit_silent_aim_tracer_thickness", Default = 2, Minimum = 1, Maximum = 5, Decimals = 0.01, Ending = "%"});
				line_option_list:Slider({Name = "Transparency", Flag = "legit_silent_aim_tracer_transparency", Default = 1, Minimum = 0, Maximum = 1, Decimals = 0.01, Ending = "%"});

				local checks_toggle = legit_silent_aim:Toggle({Name = "Checks", Flag = "legit_silent_use_checks"});
				local checks_option_list = checks_toggle:OptionList({});
				checks_option_list:List({Name = "Values", Flag = "legit_silent_checks", Options = {"Knocked", "Grabbed", "Friend", "Wall", "Vehicle"}, Default = {"Knocked"}, Max = 5});

				local airpart_toggle = legit_silent_aim:Toggle({Name = "Use Air Aim Part", Flag = "legit_silent_use_air_hit_part"});
				local airpart_option_list = airpart_toggle:OptionList({});
				airpart_option_list:List({Name = "Air Aim Part", Flag = "legit_silent_air_aim_part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "HumanoidRootPart"});

				
				local antiground_toggle = legit_silent_aim:Toggle({Name = "Anti Ground Shots", Flag = "legit_silent_anti_ground_shots"});
				local antiground_option_list = antiground_toggle:OptionList({});
				antiground_option_list:Slider({Name = "To Take Off", Flag = "legit_silent_anti_ground_shots_to_take_off", Default = 2, Minimum = 0.1, Maximum = 10, Decimals = 0.01, Ending = "'"});
				
				legit_silent_aim:List({Name = "Aim Part", Flag = "legit_silent_aim_part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "HumanoidRootPart"});
				legit_silent_aim:Textbox({Name = "Prediction", Flag = "legit_silent_prediction", Default = "0.134", PlaceHolder = "Prediction"});
			end;
		end;
	end;

	--// rage 
	do
		--// sections
		local rage_main_target_aim = ui.tabs["rage"]:Section({Name = "Target Aim", Side = "Left", Size = 427});
		local rage_target_aim_visuals = ui.tabs["rage"]:Section({Name = "Target Aim Visuals", Side = "Right", Size = 245});
		local rage_target_aim_teleport = ui.tabs["rage"]:Section({Name = "Target Aim Teleport", Side = "Right",  Size = 175});

		do
			local main_toggle = rage_main_target_aim:Toggle({Name = "Enabled", Flag = "rage_target_aim_enabled", Callback = function(state)
				if state then return end;

				screen_gui.Enabled = false;
			end});
			local main_toggle_option_list = main_toggle:OptionList({});
			main_toggle_option_list:Toggle({Name = "Notify", Flag = "rage_target_aim_notify"});
			main_toggle_option_list:Slider({Name = "Notify Duration", Flag = "rage_target_aim_notify_duration", Default = 2, Minimum = 1, Maximum = 10, Decimals = 0.01, Ending = "s"});
			main_toggle_option_list:Toggle({Name = "Auto Shoot", Flag = "rage_target_aim_auto_shoot"});
			main_toggle_option_list:Toggle({Name = "Look At", Flag = "rage_target_aim_look_at"});
			main_toggle_option_list:Toggle({Name = "Randomized BodyPart", Flag = "rage_target_aim_randomized_body_part"});
			--main_toggle_option_list:Toggle({Name = "Movement Simulation", Flag = "rage_target_aim_movement_simulation"});
			
			rage_main_target_aim:Keybind({Flag = "rage_target_aim_key", Default = Enum.KeyCode.E, Mode = "Toggle", Callback = function(key)
				local target_aim_enabled = flags["rage_target_aim_enabled"];
				local checks_enabled = flags["rage_target_aim_use_checks"];
				local check_values = flags["rage_target_aim_checks"];
				local fov_enabled = flags["rage_target_aim_use_field_of_view"];
				local fov_radius = flags["rage_target_aim_field_of_view_radius"];
				local auto_switch = flags["rage_target_aim_auto_switch"];

				if (not (target_aim_enabled)) then return end;

				local new_target = combat.get_closest_player(fov_enabled, fov_radius, checks_enabled, check_values);

				locals.target_aim.is_targetting = (new_target and not locals.target_aim.is_targetting or false);

				if (auto_switch and new_target and not locals.target_aim.is_targetting and locals.target_aim.target ~= new_target) then
					locals.target_aim.is_targetting = true;
				end;

				locals.target_aim.target = (locals.target_aim.is_targetting and new_target or nil);

				signals.target_target_changed:Fire(locals.target_aim.target, locals.target_aim.is_targetting);
			end});

			if (not table.find(dahood_ids, game.PlaceId)) then
				rage_main_target_aim:Toggle({Name = "Bullet Tp", Flag = "rage_target_aim_bullet_tp_enabled"});
			else
				rage_main_target_aim:Toggle({Name = "Rocket Tp", Flag = "rage_target_aim_rocket_tp_enabled"});
			end;
			
			rage_main_target_aim:Toggle({Name = "Spectate", Flag = "rage_target_aim_spectate"});
			rage_main_target_aim:Toggle({Name = "Auto Switch", Flag = "rage_target_aim_auto_switch"});
			rage_main_target_aim:Toggle({Name = "Closest Body Part", Flag = "rage_target_aim_closest_body_part"});

			local air_part_toggle = rage_main_target_aim:Toggle({Name = "Use Air Aim Part", Flag = "rage_target_aim_use_air_hit_part"});
			local air_part_option_list = air_part_toggle:OptionList({});
			air_part_option_list:List({Name = "Aim Part", Flag = "rage_target_aim_air_aim_part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "HumanoidRootPart"});
			local air_offset_toggle = rage_main_target_aim:Toggle({Name = "Air Offset", Flag = "rage_target_aim_use_air_offset"});
			local air_offset_option_list = air_offset_toggle:OptionList({});
			air_offset_option_list:Slider({Name = "Offset", Flag = "rage_target_aim_air_offset", Default = 4, Minimum = -10, Maximum = 10, Decimals = 0.001, Ending = "'"});
			local resolver_toggle = rage_main_target_aim:Toggle({Name = "Resolver", Flag = "rage_target_aim_resolver_enabled"});
			local resolver_option_list = resolver_toggle:OptionList({});
			resolver_option_list:List({Name = "Method", Flag = "rage_target_aim_resolver_method", Options = {"Recalculate", "MoveDirection"}, Default = "Recalculate"});
			resolver_option_list:Slider({Name = "Update Time", Flag = "rage_target_aim_update_time", Default = 100, Minimum = 1, Maximum = 200, Decimals = 0.001, Ending = "ms"});
			local checks_toggle = rage_main_target_aim:Toggle({Name = "Checks", Flag = "rage_target_aim_use_checks"});
			local checks_option_list = checks_toggle:OptionList({});
			checks_option_list:List({Name = "Checks", Flag = "rage_target_aim_checks", Options = {"Knocked", "Grabbed", "Friend", "Wall", "Vehicle"}, Default = {"Knocked"}, Max = 5});
			local anti_ground_toggle = rage_main_target_aim:Toggle({Name = "Anti Ground Shots", Flag = "rage_target_aim_anti_ground_shots"});
			local anti_ground_option_list = anti_ground_toggle:OptionList({});
			--// anti_ground_option_list:Slider({Name = "To Take Off", Flag = "rage_target_aim_anti_ground_shots_to_take_off", Default = 2, Minimum = 0.1, Maximum = 20, Decimals = 0.01, Ending = "'"});
			anti_ground_option_list:Slider({Name = "Dampening Factor", Flag = "rage_target_aim_dampening_factor", Default = 0.7, Minimum = 0, Maximum = 1, Decimals = 0.01, Ending = ""});
			local fov_toggle = rage_main_target_aim:Toggle({Name = "Field Of View", Flag = "rage_target_aim_use_field_of_view"});
			local fov_option_list = fov_toggle:OptionList({});
			fov_option_list:Toggle({Name = "Visualize", Flag = "rage_target_aim_visualize_field_of_view"});
			fov_option_list:Colorpicker({Name = "Color", Flag = "rage_target_aim_field_of_view_color", Default = default_color, Transparency = 0});
			fov_option_list:Slider({Name = "Transparency", Flag = "rage_target_aim_field_of_view_transparency", Default = 0, Minimum = 0, Maximum = 1, Decimals = 0.01, Ending = "%"});
			fov_option_list:Slider({Name = "Radius", Flag = "rage_target_aim_field_of_view_radius", Default = 1, Minimum = 1, Maximum = 200, Decimals = 0.01, Ending = "%"});

			rage_main_target_aim:Textbox({Name = "Prediction", Flag = "rage_target_aim_prediction", Default = "0.134", PlaceHolder = "Prediction"});
			rage_main_target_aim:List({Name = "Aim Part", Flag = "rage_target_aim_aim_part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "HumanoidRootPart"});
		end;

		--// target aim visuals
		do
			local main_toggle = rage_target_aim_visuals:Toggle({Name = "Enabled", Flag = "rage_target_aim_visuals_enabled"});
			local option_list_toggle = main_toggle:OptionList({});

			option_list_toggle:Toggle({Name = "UI", Flag = "rage_target_aim_visuals_ui_enabled", Callback = function(state)
				if state then return end;

				screen_gui.Enabled = false;
			end});

			option_list_toggle:List({Name = "UI Mode", Flag = "rage_target_aim_ui_mode", Options = {"Follow", "Static"}, Default = "Static"});

			rage_target_aim_visuals:Toggle({Name = "Line", Flag = "rage_target_aim_tracer_enabled"});
			local dot = rage_target_aim_visuals:Toggle({Name = "Dot", Flag = "rage_target_aim_dot_enabled"});
			local dot_option_list = dot:OptionList({});
			dot_option_list:Colorpicker({Name = "Color", Flag = "rage_target_aim_dot_color", Default = default_color, Transparency = 0});
			dot_option_list:Slider({Name = "Size", Flag = "rage_target_aim_dot_size", Default = 6, Minimum = 1, Maximum = 20, Decimals = 0.01, Ending = "%"});

			rage_target_aim_visuals:Toggle({Name = "Chams", Flag = "rage_target_aim_chams_enabled"});
			
			rage_target_aim_visuals:Colorpicker({Name = "Line Color", Info = "Target Aim Line Color", Flag = "rage_target_aim_tracer_color", Default = default_color, Transparency = 1});				

			rage_target_aim_visuals:Colorpicker({Name = "Chams Fill Color", Info = "Target Aim Chams Fill Color", Flag = "rage_target_aim_chams_fill_color", Default = default_color, Transparency = 0.5});
			rage_target_aim_visuals:Colorpicker({Name = "Chams Outline Color", Info = "Target Aim Chams Outline Color", Flag = "rage_target_aim_chams_outline_color", Default = Color3.fromRGB(0, 0, 0), Transparency = 0});


			rage_target_aim_visuals:Slider({Name = "Line Thickness", Flag = "rage_target_aim_tracer_thickness", Default = 2, Minimum = 1, Maximum = 5, Decimals = 0.01, Ending = "%"});
		end;

		--// target aim teleport
		do
			local main_toggle = rage_target_aim_teleport:Toggle({Name = "Enabled", Flag = "rage_target_aim_teleport_enabled"});
			rage_target_aim_teleport:Toggle({Name = "Bypass Destroy Cheaters", Flag = "rage_target_aim_bypass_destroy_cheaters"})	
		
			local main_toggle_optionlist = main_toggle:OptionList({});
			rage_target_aim_teleport:Keybind({Flag = "rage_target_aim_teleport_keybind", Default = Enum.KeyCode.B, KeybindName = "Target Aim Teleport", Mode = "Toggle"});
			
			rage_target_aim_teleport:List({Name = "Type", Flag = "rage_target_aim_teleport_type", Options = {"Random", "Strafe"}, Default = "Random"});
			main_toggle_optionlist:Slider({Name = "Randomization", Flag = "rage_target_aim_teleport_randomization", Default = 1, Minimum = 1, Maximum = 20, Decimals = 0.01, Ending = "%"});
			main_toggle_optionlist:Slider({Name = "Strafe Distance", Flag = "rage_target_aim_teleport_strafe_distance", Default = 1, Minimum = 1, Maximum = 20, Decimals = 0.01, Ending = "%"});
			main_toggle_optionlist:Slider({Name = "Strafe Speed", Flag = "rage_target_aim_teleport_strafe_speed", Default = 1, Minimum = 1, Maximum = 10, Decimals = 0.01, Ending = "%"});
			main_toggle_optionlist:Slider({Name = "Strafe", Flag = "rage_target_aim_teleport_strafe_height", Default = 1, Minimum = 1, Maximum = 20, Decimals = 0.01, Ending = "%"});

		end;
	end;
	
	--// movement
	do
		local cframe_speed = ui.tabs["movement"]:Section({Name = "CFrame speed", Side = "Left", Size = 125});
		local cframe_fly = ui.tabs["movement"]:Section({Name = "Fly", Side = "Left", Size = 125});
		local misc = ui.tabs["movement"]:Section({Name = "Misc", Side = "Right", Size = 100});
		
		--// speed
		do
			local main_toggle = cframe_speed:Toggle({Name = "Enabled", Flag = "rage_cframe_speed_enabled"});
			cframe_speed:Keybind({Flag = "rage_cframe_speed_keybind", Name = "Keybind", Default = Enum.KeyCode.X, Mode = "Toggle"});
			cframe_speed:Slider({Name = "Amount", Flag = "rage_cframe_speed_amount", Default = 0.3, Minimum = 0.1, Maximum = 10, Decimals = 0.01, Ending = "%"});
		end;

		--// fly
		do
			local main_toggle = cframe_fly:Toggle({Name = "Enabled", Flag = "rage_cframe_fly_enabled"});
			cframe_fly:Keybind({Flag = "rage_cframe_fly_keybind", Name = "Keybind", Default = Enum.KeyCode.C, Mode = "Toggle"});
			cframe_fly:Slider({Name = "Speed", Flag = "rage_cframe_fly_amount", Default = 1, Minimum = 1, Maximum = 30, Decimals = 0.01, Ending = "%"});
		end;

		--// misc
		do
			misc:Toggle({Name = "No Jump Cooldown", Flag = "rage_misc_movement_no_jump_cooldown", Callback = function(state)
				if (not (utility.has_character(local_player))) then return end;

                local_player.Character.Humanoid.UseJumpPower = true;
			end});

			misc:Toggle({Name = "No Seats", Callback = function(state)
				local descendants = game:GetDescendants();

				for i = 1, #descendants do
					local object = descendants[i];

					if (object.ClassName ~= "Seat") then continue end;

					object.CanTouch = not state and true or false;
				end;
			end});
		end;
	end;

	--// visuals
	do
		--// world
		do
			local visuals_bullet_tracers = ui.tabs["world"]:Section({Name = "Bullet Tracers", Side = "Left", Size = 210});
			local visuals_bullet_impacts = ui.tabs["world"]:Section({Name = "Bullet Impacts", Side = "Right", Size = 210});
			local visuals_hit_detection = ui.tabs["world"]:Section({Name = "Hit Detection", Side = "Left"});
			local visuals_clone_chams = ui.tabs["world"]:Section({Name = "Clone Chams", Side = "Right"});

			--// bullet tracers
			do
				local main_toggle = visuals_bullet_tracers:Toggle({Name = "Enabled", Flag = "visuals_bullet_tracers_enabled"});
				visuals_bullet_tracers:Toggle({Name = "Fade", Flag = "visuals_bullet_tracers_fade_enabled"});

				visuals_bullet_tracers:Colorpicker({Name = "Bullet Tracers Gradient Start", Flag = "visuals_bullet_tracers_color_gradient_1", Default = default_color, Transparency = 0});
				visuals_bullet_tracers:Colorpicker({Name = "Bullet Tracers Gradient End", Flag = "visuals_bullet_tracers_color_gradient_2", Default = default_color, Transparency = 0});

				visuals_bullet_tracers:Slider({Name = "Fade Duration", Flag = "visuals_bullet_tracers_fade_duration", Default = 2, Minimum = 0.5, Maximum = 5, Decimals = 0.001, Ending = "s"});
				visuals_bullet_tracers:Slider({Name = "Duration", Flag = "visuals_bullet_tracers_duration", Default = 2, Minimum = 0.5, Maximum = 5, Decimals = 0.001, Ending = "s"});
			end;

			--// bullet impact
			do
				local main_toggle = visuals_bullet_impacts:Toggle({Name = "Enabled", Flag = "visuals_bullet_impacts_enabled"});

				local main_toggle_option_list = main_toggle:OptionList({});
				main_toggle_option_list:Colorpicker({Name = "Bullet Impacts Color", Flag = "visuals_bullet_impacts_color", Default = default_color, Transparency = 0});	


				visuals_bullet_impacts:Toggle({Name = "Fade", Flag = "visuals_bullet_impacts_fade_enabled"});
				visuals_bullet_impacts:Slider({Name = "Size", Flag = "visuals_bullet_impacts_size", Default = 0.5, Minimum = 0.1, Maximum = 10, Decimals = 0.001, Ending = "'"});
				visuals_bullet_impacts:Slider({Name = "Fade Duration", Flag = "visuals_bullet_impacts_fade_duration", Default = 2, Minimum = 0.5, Maximum = 5, Decimals = 0.001, Ending = "s"});
				visuals_bullet_impacts:Slider({Name = "Duration", Flag = "visuals_bullet_impacts_duration", Default = 2, Minimum = 0.5, Maximum = 5, Decimals = 0.001, Ending = "s"});
			end;

			--// hit detection
			do
				local sounds = {};

				for i,v in hitsounds do
					table.insert(sounds, i);
				end;

				visuals_hit_detection:Toggle({Name = "Enabled", Flag = "visuals_hit_detection_enabled"});
				local sounds_toggle = visuals_hit_detection:Toggle({Name = "Sounds", Flag = "visuals_hit_detection_sounds_enabled"});
	
				local sounds_toggle_option_list = sounds_toggle:OptionList({});
				sounds_toggle_option_list:List({Name = "Sound", Flag = "visuals_hit_detection_sounds_which_sound", Options = sounds, Default = sounds[1]});
				sounds_toggle_option_list:Slider({Name = "Volume", Flag = "visuals_hit_detection_sounds_volume", Default = 5, Minimum = 0.1, Maximum = 10, Decimals = 0.01, Ending = "%"});

				local chams_toggle = visuals_hit_detection:Toggle({Name = "Chams", Flag = "visuals_hit_detection_chams_enabled"});
				
				local chams_option_list = chams_toggle:OptionList({});
				chams_option_list:Colorpicker({Name = "Color", Flag = "visuals_hit_detection_chams_color", Default = default_color});
				chams_option_list:Slider({Name = "Transparency", Flag = "visuals_hit_detection_chams_transparency", Default = 0.7, Minimum = 0, Maximum = 1, Decimals = 0.001, Ending = "%"});
				chams_option_list:Slider({Name = "Duration", Flag = "visuals_hit_detection_chams_duration", Default = 2, Minimum = 0, Maximum = 10, Decimals = 0.001, Ending = "s"});
				
				local effect = visuals_hit_detection:Toggle({Name = "Effects", Flag = "visuals_hit_detection_effects_enabled"});
				
				local effect_option_list = effect:OptionList({});
				effect_option_list:Colorpicker({Name = "Color", Flag = "visuals_hit_detection_effects_color", Default = default_color});
				effect_option_list:List({Name = "Which Effect", Flag = "visuals_hit_detection_effects_which_effect", Options = {"Bubble", "Confetti"}, Default = "Bubble"});

				visuals_hit_detection:Toggle({Name = "Notification", Flag = "visuals_hit_detection_notification"});
				visuals_hit_detection:Slider({Name = "Notification Duration", Flag = "visuals_hit_detection_notification_duration", Default = 2, Minimum = 0, Maximum = 10, Decimals = 0.001, Ending = "s"});
			end;
			
			--// clons chams
			do
				visuals_clone_chams:Toggle({Name = "Enabled", Flag = "visuals_clone_chams_enabled"});
				visuals_clone_chams:Colorpicker({Name = "Color", Flag = "visuals_clone_chams_color", Default = default_color});
				visuals_clone_chams:Slider({Name = "Duration", Flag = "visuals_clone_chams_duration", Default = 0.1, Minimum = 0.1, Maximum = 10, Decimals = 0.001, Ending = "s"});
				visuals_clone_chams:List({Name = "To Apply", Flag = "visuals_clone_chams_to_apply", Options = {"Local Player", "Target Aim Target"}, Default = {"Local Player"}, Max = 2});
			end;
		end;

		--// misc
		do
			local world_section = ui.tabs["view"]:Section({Name = "World", Side = "Left", Size = 210});
			local lplr_section = ui.tabs["view"]:Section({Name = "Local Player", Side = "Left", Size = 210});
			local cursor_text = ui.tabs["view"]:Section({Name = "Text", Side = "Right", Size = 210});

			--// world
			do
				local fog = world_section:Toggle({Name = "Fog", Flag = "visuals_world_fog", Callback = function(state)
					if state then
						lighting.FogColor = flags["visuals_world_fog_color"];
						lighting.FogStart = flags["visuals_world_fog_start"];
						lighting.FogEnd = flags["visuals_world_fog_end"];
					else
						lighting.FogColor = world.FogColor;
						lighting.FogStart = world.FogStart;
						lighting.FogEnd = world.FogEnd;
					end;
				end});
				
				local fog_option_list = fog:OptionList({});
				fog_option_list:Colorpicker({Name = "Color", Flag = "visuals_world_fog_color", Default = default_color, Callback = function(color)
					if flags["visuals_world_fog"] then
						lighting.FogColor = color;
					end;
				end});
				fog_option_list:Slider({Name = "Start", Flag = "visuals_world_fog_start", Default = 150, Minimum = 100, Maximum = 10000, Decimals = 1, Ending = "%", Callback = function(number)
					if flags["visuals_world_fog"] then
						lighting.FogStart = number;
					end;
				end});
				fog_option_list:Slider({Name = "End", Flag = "visuals_world_fog_end", Default = 550, Minimum = 100, Maximum = 10000, Decimals = 1, Ending = "%", Callback = function(number)
					if flags["visuals_world_fog"] then
						lighting.FogEnd = number;
					end;
				end});

				local ambient = world_section:Toggle({Name = "Ambient", Flag = "visuals_world_ambient", Callback = function(state)
					if state then
						lighting.Ambient = flags["visuals_world_ambient_color"];
					else
						lighting.Ambient = world.Ambient;
					end;
				end});
				
				local ambient_option_list = ambient:OptionList({});
				ambient_option_list:Colorpicker({Name = "Color", Flag = "visuals_world_ambient_color", Default = default_color, Callback = function(color)
					if flags["visuals_world_ambient"] then
						lighting.Ambient = color;
					end;
				end});

				local clock_time_toggle = world_section:Toggle({Name = "Clock Time", Flag = "visuals_world_clock_time", Callback = function(state)
					if state then
						lighting.ClockTime = flags["visuals_world_clock_time_time"];
					else
						lighting.ClockTime = world.ClockTime;
					end;
				end});
				local clock_time_option_list = clock_time_toggle:OptionList({});
				clock_time_option_list:Slider({Name = "Time", Flag = "visuals_world_clock_time_time", Default = 14, Minimum = 0, Maximum = 24, Decimals = 1, Callback = function(number)
					if flags["visuals_world_clock_time"] then
						lighting.ClockTime = number;
					end;
				end});

				local brightness_toggle = world_section:Toggle({Name = "Brightness", Flag = "visuals_world_brightness", Callback = function(state)
					if state then
						lighting.Brightness = flags["visuals_world_brightness_level"];
					else
						lighting.Brightness = world.Brightness;
					end;
				end});
				local brightness_option_list = brightness_toggle:OptionList({});
				brightness_option_list:Slider({Name = "Level", Flag = "visuals_world_brightness_level", Default = 0.1, Minimum = 0, Maximum = 10, Decimals = 1, Callback = function(number)
					if flags["visuals_world_brightness"] then
						lighting.Brightness = number;
					end;
				end});

				local exposure = world_section:Toggle({Name = "Exposure", Flag = "visuals_world_exposure", Callback = function(state)
					if state then
						lighting.ExposureCompensation = flags["visuals_world_exposure_compensation"];
					else
						lighting.ExposureCompensation = world.ExposureCompensation;
					end;
				end});
				local exposure_option_list = exposure:OptionList({});
				exposure_option_list:Slider({Name = "Compensation", Flag = "visuals_world_exposure_compensation", Default = 0, Minimum = -10, Maximum = 10, Decimals = 1, Callback = function(number)
					if flags["visuals_world_exposure"] then
						lighting.ExposureCompensation = number;
					end;
				end});

				local color_shift_top = world_section:Toggle({Name = "Color Shift Top", Flag = "visuals_world_color_shift_top", Callback = function(state)
					if state then
						lighting.ColorShift_Top = flags["visuals_world_color_shift_top_color"];
					else
						lighting.ColorShift_Top = world.ColorShift_Top;
					end;
				end});
				local color_shift_top_option_list = color_shift_top:OptionList({});
				color_shift_top_option_list:Colorpicker({Name = "Color", Flag = "visuals_world_color_shift_top_color", Default = default_color, Callback = function(color)
					if flags["visuals_world_color_shift_top"] then
						lighting.ColorShift_Top = color;
					end;
				end});

				local collor_shift_bottom = world_section:Toggle({Name = "Color Shift Bottom", Flag = "visuals_world_color_shift_bottom", Callback = function(state)
					if state then
						lighting.ColorShift_Bottom = flags["visuals_world_color_shift_bottom_color"];
					else
						lighting.ColorShift_Bottom = world.ColorShift_Bottom;
					end;
				end});
				local color_shift_bottom_option_list = collor_shift_bottom:OptionList({});
				color_shift_bottom_option_list:Colorpicker({Name = "Color", Flag = "visuals_world_color_shift_bottom_color", Default = default_color, Callback = function(color)
					if flags["visuals_world_color_shift_bottom"] then
						lighting.ColorShift_Bottom = color;
					end;
				end});
			end;

			--// local player section
			do
				lplr_section:Toggle({Name = "Chams", Flag = "visuals_player_chams_enabled"});
				lplr_section:Toggle({Name = "Material", Flag = "visuals_player_material_enabled", Callback = function(state)
					local material = flags["visuals_player_material_type"];
					features.local_material(state, material);
				end});
				lplr_section:Colorpicker({Name = "Outline Color", Flag = "visuals_player_chams_outline_color", Default = Color3.new(0, 0, 0)});
				lplr_section:Colorpicker({Name = "Fill Color", Flag = "visuals_player_chams_fill_color", Default = default_color});
				lplr_section:List({Name = "Material", Flag = "visuals_player_material_type", Options = {"ForceField", "Neon"}, Default = "ForceField", Callback = function(material)
					local state = flags["visuals_player_material_enabled"];
					features.local_material(state, material);
				end});
			end;

			if (ESP) then
				local esp_section = ui.tabs["view"]:Section({Name = "ESP", Side = "Right", Size = 210});
				--// esp section
				do
					esp_section:Toggle({Name = "Enabled", Flag = "visuals_esp_enabled"});
					local boxes_toggle = esp_section:Toggle({Name = "Boxes", Flag = "visuals_esp_boxes_enabled"});
					local boxes_option_list = boxes_toggle:OptionList({});
					boxes_option_list:Colorpicker({Name = "Color", Flag = "visuals_esp_boxes_color", Default = Color3.new(1, 1, 1)});
					boxes_option_list:Toggle({Name = "Target Color", Flag = "visuals_esp_boxes_target_color_enabled"});
					boxes_option_list:Colorpicker({Name = "Target Color", Flag = "visuals_esp_boxes_target_color", Default = Color3.new(1, 0, 0)});
		
					local names_toggle = esp_section:Toggle({Name = "Names", Flag = "visuals_esp_names_enabled"});
					local names_option_list = names_toggle:OptionList({});
					names_option_list:Colorpicker({Name = "Color", Flag = "visuals_esp_names_color", Default = Color3.new(1, 1, 1)});
		
					local head_dots_toggle = esp_section:Toggle({Name = "Head Dots", Flag = "visuals_esp_head_dots_enabled"});
					local head_dots_option_list = head_dots_toggle:OptionList({});
					head_dots_option_list:Colorpicker({Name = "Color", Flag = "visuals_esp_head_dots_color", Default = Color3.new(1, 1, 1)});
					head_dots_option_list:Slider({Name = "Sides", Flag = "visuals_esp_head_dots_sides", Default = 6, Minimum = 1, Maximum = 100, Decimals = 1, Ending = "'"});
					head_dots_option_list:Slider({Name = "Size", Flag = "visuals_esp_head_dots_size", Default = 10, Minimum = 1, Maximum = 20, Decimals = 0.0001, Ending = "'"});
					local health_bar_toggle = esp_section:Toggle({Name = "Health Bar", Flag = "visuals_esp_health_bar_enabled"});
					local health_bar_option_list = health_bar_toggle:OptionList({});
					health_bar_option_list:Toggle({Name = "Health Based Color", Flag = "visuals_esp_health_bar_health_based_color"});
					health_bar_option_list:Colorpicker({Name = "Health Color", Flag = "visuals_esp_health_bar_color", Default = Color3.new(1, 1, 1)});
					local health_text_toggle = esp_section:Toggle({Name = "Health Text", Flag = "visuals_esp_health_text_enabled"});
					local health_text_option_list = health_text_toggle:OptionList({});
					health_text_option_list:Toggle({Name = "Health Based Color", Flag = "visuals_esp_health_text_health_based_color"});
					health_text_option_list:Colorpicker({Name = "Color", Flag = "visuals_esp_health_text_color", Default = Color3.new(1, 1, 1)});
					local armor_bar_toggle = esp_section:Toggle({Name = "Armor Bar", Flag = "visuals_esp_armor_bar_enabled"});
					local armor_bar_option_list = armor_bar_toggle:OptionList({});
					armor_bar_option_list:Colorpicker({Name = "Armor Color", Flag = "visuals_esp_armor_bar_color", Default = Color3.new(1, 1, 1)});
				end;
			end;
	
			--// cursor text
			do
				cursor_text:Toggle({Name = "Enabled", Flag = "visuals_text_enabled"});
				cursor_text:Toggle({Name = "Custom Text", Flag = "visuals_text_custom_text"});
				cursor_text:Colorpicker({Name = "Text Color", Flag = "visuals_text_color", Default = default_color});
				cursor_text:Slider({Name = "Cursor Offset", Flag = "visuals_text_cursor_offset", Default = 49, Minimum = 1, Maximum = 100, Decimals = 0.0001, Ending = "%"});
				cursor_text:Textbox({Flag = "visuals_cursor_custom_text_text", Placeholder = "[${target_name}]"});
			end;
		end;
	end;

	--// anti aim
	do
		local velocity_spoofer = ui.tabs["anti_aim"]:Section({Name = "Velocity Spoofer", Side = "Left", Size = 160});
		local network_desync = ui.tabs["anti_aim"]:Section({Name = "Network Desync", Side = "Right", Size = 110});
		local c_sync = ui.tabs["anti_aim"]:Section({Name = "C-Sync", Side = "Right", Size = 300});
		local fflag = ui.tabs["anti_aim"]:Section({Name = "FFlag Desync", Side = "Left", Size = 95});
		local starhook_classics = ui.tabs["anti_aim"]:Section({Name = "Starhook Classics", Side = "Left", Size = 150});

		--// velocity spoofer
		do
			local nest = velocity_spoofer:Nest({Size = 120});
			nest:Toggle({Name = "Enabled", Flag = "anti_aim_velocity_spoofer_enabled"});
			nest:Keybind({Flag = "anti_aim_velocity_spoofer_keybind", Name = "Keybind", Default = Enum.KeyCode.C, Mode = "Toggle"});
			nest:List({Name = "Type", Flag = "anti_aim_velocity_spoofer_type", Options = {"Local Strafe", "Random", "Static"}, Default = {"Local Strafe"}});
			nest:Slider({Name = "Strafe Distance", Flag = "anti_aim_velocity_spoofer_strafe_distance", Default = 1, Minimum = 1, Maximum = 20, Decimals = 0.01, Ending = "%"});
			nest:Slider({Name = "Strafe Speed", Flag = "anti_aim_velocity_spoofer_strafe_speed", Default = 1, Minimum = 1, Maximum = 10, Decimals = 0.01, Ending = "%"});
			nest:Slider({Name = "Static X", Flag = "anti_aim_velocity_spoofer_static_x", Default = 1, Minimum = 1, Maximum = 100, Decimals = 0.01, Ending = "'"});
			nest:Slider({Name = "Static Y", Flag = "anti_aim_velocity_spoofer_static_y", Default = 1, Minimum = 1, Maximum = 100, Decimals = 0.01, Ending = "'"});
			nest:Slider({Name = "Static Z", Flag = "anti_aim_velocity_spoofer_static_z", Default = 1, Minimum = 1, Maximum = 100, Decimals = 0.01, Ending = "'"});
			nest:Slider({Name = "Randomization", Flag = "anti_aim_velocity_spoofer_randomization", Default = 1, Minimum = 1, Maximum = 100, Decimals = 0.01, Ending = "%"});
		end;

		--// network desync
		do
			network_desync:Toggle({Name = "Enabled", Flag = "anti_aim_network_desync_enabled"});
			network_desync:Slider({Name = "Amount", Flag = "anti_aim_network_desync_amount", Default = 7.5, Minimum = 0, Maximum = 10, Decimals = 0.01, Ending = "%"});
		end;

		--// c sync
		do
			local main_toggle = c_sync:Toggle({Name = "Enabled", Flag = "anti_aim_c_sync_enabled"});
			local main_toggle_option_list = main_toggle:OptionList({});

			main_toggle_option_list:Toggle({Name = "Visualize", Flag = "anti_aim_c_sync_visualize_enabled"});
			main_toggle_option_list:List({Name = "Visualize Types", Flag = "anti_aim_c_sync_visualize_types", Options = {"Tracer", "Dot", "Character"}, Default = {"Tracer"}, Max = 3});
			main_toggle_option_list:Colorpicker({Name = "Visualize Color", Flag = "anti_aim_c_sync_visualize_color", Default = default_color});
			main_toggle_option_list:Slider({Name = "Visualize Dot Size", Flag = "anti_aim_c_sync_dot_size", Default = 16, Minimum = 1, Maximum = 20, Decimals = 0.01, Ending = "%"});

			c_sync:Keybind({Flag = "anti_aim_c_sync_keybind", Name = "Keybind", Default = Enum.KeyCode.N, Mode = "Toggle"});
			c_sync:List({Name = "Type", Flag = "anti_aim_c_sync_type", Options = {"Static Local", "Static Target", "Local Random", "Target Random"}, Default = "Local Offset"});
			c_sync:Slider({Name = "Randomization", Flag = "anti_aim_c_sync_randomization", Default = 1, Minimum = 1, Maximum = 100, Decimals = 0.01, Ending = "%"});
			c_sync:Slider({Name = "Static X", Flag = "anti_aim_c_sync_static_x", Default = 1, Minimum = 0, Maximum = 100, Decimals = 0.01, Ending = "'"});
			c_sync:Slider({Name = "Static Y", Flag = "anti_aim_c_sync_static_y", Default = 1, Minimum = 0, Maximum = 100, Decimals = 0.01, Ending = "'"});
			c_sync:Slider({Name = "Static Z", Flag = "anti_aim_c_sync_static_z", Default = 1, Minimum = 0, Maximum = 100, Decimals = 0.01, Ending = "'"});
		end;

		--// fflags desync
		do
			fflag:Toggle({Name = "Enabled", Flag = "anti_aim_fflag_desync_enabled", Callback = function(state)
				if (state) then
					setfflag("S2PhysicsSenderRate", tostring(flags["anti_aim_fflag_amount"]));
				else
					setfflag("S2PhysicsSenderRate", tostring(old_psr));
				end;
			end});
			fflag:Slider({Name = "Amount", Flag = "anti_aim_fflag_amount", Default = 2, Minimum = 0, Maximum = 15, Decimals = 0.01, Ending = "%", Callback = function(value)
				if (flags["anti_aim_fflag_desync_enabled"]) then
					setfflag("S2PhysicsSenderRate", tostring(value));
				end;
			end});
		end;

		--// destroy cheaters
		do
			starhook_classics:Toggle({Name = "Enabled", Flag = "anti_aim_starhook_classics_enabled"});
			starhook_classics:Keybind({Flag = "anti_aim_starhook_classics_keybind", Name = "Keybind", Default = Enum.KeyCode.Y, Mode = "Toggle"});
			starhook_classics:List({Name = "Classics", Flag = "anti_aim_starhook_classics", Options = {"Destroy Cheaters", "supercoolboi34 Destroyer"}, Default = "Destroy Cheaters"});
		end;
	end;

	--// settings
	do --// credits to finobe wtv im way too lazy
		local cfgs = ui.tabs["settings"]:Section({Name = "Config", Side = "Left", Size = 427});
		local window = ui.tabs["settings"]:Section({Name = "Window", Side = "Right", Size = 427});

		local cfg_list = cfgs:List({Name = "Config List", Flag = "setting_configuration_list", Options = {}});
		cfgs:Textbox({Flag = "settings_configuration_name", Placeholder = "Config name"});

		local current_list = {};

		if not isfolder("starhook") then 
		    makefolder("starhook");
		end;

		if not isfolder("starhook/configs") then 
		    makefolder("starhook/configs");
		end;

		local function update_config_list()
		    local list = {};
		
		    for idx, file in listfiles("starhook/configs") do
		        local file_name = file:gsub("starhook/configs\\", ""):gsub(".cfg", ""):gsub("starhook/configs/", "");
		        list[#list + 1] = file_name;
		    end;
		
		    local is_new = #list ~= #current_list;
		
		    if not is_new then
		        for idx = 1, #list do
		            if list[idx] ~= current_list[idx] then
		                is_new = true;
		                break;
		            end;
		        end;
		    end;
		
		    if is_new then
		        current_list = list;
		        cfg_list:Refresh(current_list);
		    end;
		end;

		cfgs:Button({Name = "Create", Callback = function()
		    local config_name = flags.settings_configuration_name;
		    if config_name == "" or isfile("starhook/configs/" .. config_name .. ".cfg") then
		        return;
		    end;
		    writefile("starhook/configs/" .. config_name .. ".cfg", Library:GetConfig());
		    update_config_list();
		end});

		cfgs:Button({Name = "Save", Callback = function()
		    local selected_config = flags.setting_configuration_list;
		    if selected_config then
		        writefile("starhook/configs/" .. selected_config .. ".cfg", Library:GetConfig());
		    end;
		end});

		cfgs:Button({Name = "Load", Callback = function()
		    local selected_config = flags.setting_configuration_list;
		    if selected_config then
		        Library:LoadConfig(readfile("starhook/configs/" .. selected_config .. ".cfg"));
		    end;
		end});

		cfgs:Button({Name = "Delete", Callback = function()
		    local selected_config = flags.setting_configuration_list;
		    if selected_config then
		        delfile("starhook/configs/" .. selected_config .. ".cfg");
		    end;
		    update_config_list();
		end});

		cfgs:Button({Name = "Refresh", Callback = function()
		    update_config_list();
		end});

		update_config_list();

		--// ui settings
		window:Keybind({Name = "UI Toggle", Flag = "ui_toggle", Default = Enum.KeyCode.Insert, UseKey = true, Callback = function(key)
			Library.UIKey = key;
		end});

		window:Toggle({Name = "Watermark", Flag = "ui_watermark", Callback = function(state)
			watermark:SetVisible(state);
		end});

		window:Colorpicker({Name = "Menu Accent", Flag = "MenuAccent", Default = default_color, Callback = function(state)
			library:ChangeAccent(state);
		end});
	end;
end;
