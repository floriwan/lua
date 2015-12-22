--
-- Draw a warning box if the landing lights are off below FL100
-- or still on above FL100. 
-- If the gear leaver is in down position, no landing light check is done.
--

require("graphics")

DataRef( "xp_landing_lights_on", "sim/cockpit/electrical/landing_lights_on", "readonly")
DataRef( "xp_altitude_pilot", "sim/cockpit2/gauges/indicators/altitude_ft_pilot", "readonly" )
DataRef( "xp_gear_handle_status", "sim/cockpit/switches/gear_handle_status", "readonly")

local landing_lights_on_ft = 11000		-- below this altitude, get a warning message to turn the landing lights on
local landing_lights_off_ft = 9000		-- warning altitude to turn landing lights off during climb

local warning_box_height = 21
local warning_box_width = 140
local warning_box_offset_x = 20			-- warning box mouse pointer offset x
local warning_box_offset_y = -40		-- warning box mouse pointer offset y

local flight_state = ""
local show_taxi_light_warning_box = 0
local warning_text = ""
local old_alt = 0
local alt_threshold = 100

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function check_landing_lights()

	-- determine the flight state, cruising, decent or climb
	if ((old_alt+alt_threshold) > xp_altitude_pilot) and
		((old_alt-alt_threshold) < xp_altitude_pilot) then
		flight_state = "cr"
	elseif old_alt < xp_altitude_pilot then
		flight_state = "cl"
	elseif old_alt > xp_altitude_pilot then
		flight_state = "de"
	else
		fligh_state = "un"
	end
	
	old_alt = xp_altitude_pilot
	
	if xp_gear_handle_status == 1 then 
		show_taxi_light_warning_box = 0
	elseif flight_state == "cl" and xp_altitude_pilot > landing_lights_off_ft and xp_landing_lights_on == 1 then
		show_taxi_light_warning_box = 1
		warning_text = "turn landing lights OFF"
	elseif flight_state ~= "cl" and xp_altitude_pilot < landing_lights_on_ft and xp_landing_lights_on == 0 then
		show_taxi_light_warning_box = 1
		warning_text = "turn landing lights ON"
	else
		show_taxi_light_warning_box = 0
	end
	
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function draw_warning_box()

		
	if show_taxi_light_warning_box == 1 then	

		warning_box_x = MOUSE_X + warning_box_offset_x
		warning_box_y = MOUSE_Y + warning_box_offset_y
	
		XPLMSetGraphicsState(0,0,0,1,1,0,0)	
		
		-- red box
		graphics.set_color(1.0, 0.0, 0.0, 0.5)
		graphics.draw_rectangle(warning_box_x, warning_box_y, warning_box_x + warning_box_width, warning_box_y + warning_box_height)
	
		-- white frame
		graphics.set_color(1.0, 1.0, 1.0, 1.0)
		graphics.draw_line(warning_box_x, warning_box_y, warning_box_x, warning_box_y+warning_box_height)       
		graphics.draw_line(warning_box_x+warning_box_width, warning_box_y+warning_box_height, warning_box_x+warning_box_width, warning_box_y) 
		graphics.draw_line(warning_box_x, warning_box_y, warning_box_x+warning_box_width, warning_box_y)
		graphics.draw_line(warning_box_x, warning_box_y+warning_box_height, warning_box_x+warning_box_width, warning_box_y+warning_box_height)
	
		-- warning text
		draw_string_Helvetica_12(warning_box_x + 3 , warning_box_y + 6, warning_text)
	
	end
	
end

-- check it every 10 sec
do_sometimes("check_landing_lights()")

-- draw the warning box
do_every_draw("draw_warning_box()")
