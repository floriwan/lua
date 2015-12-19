--
-- Draw a warning box if the landing lights are off below FL100
-- or still on above FL100. 
-- If the gear leaver is in down position, no landing light check is done.
--
-- The datarefs are from the FF B757-200.
--

require("graphics")

DataRef( "b757_landing_light_left", "1-sim/lights/landingL/switch", "writable" )
DataRef( "b757_landing_light_right", "1-sim/lights/landingR/switch", "writable" )
DataRef( "b757_landing_light_center", "1-sim/lights/landingN/switch", "writable" )

DataRef( "b757_altitude_pilot", "sim/cockpit2/gauges/indicators/altitude_ft_pilot", "readonly" )
DataRef( "b757_gear_handle", "1-sim/cockpit/switches/gear_handle", "readonly" )

local warning_box_x = 10
local warning_box_y = 100
local warning_box_width = 110
local warning_box_height = 15

show_taxi_light_warning_box = 0
warning_text = ""

function switch_b757_landing_lights()

	landing_lights = 1
	
	-- check all three landing lights switches
	if b757_landing_light_left == 0 or b757_landing_light_right == 0 or b757_landing_light_center == 0 then
		landing_lights = 0
	end
	
	if b757_gear_handle == 1 then 
		show_taxi_light_warning_box = 0
	elseif landing_lights == 1 and b757_altitude_pilot > 95000 then
		show_taxi_light_warning_box = 1
		warning_text = "landing lights ON"
	elseif landing_lights == 0 and b757_altitude_pilot < 105000 then
		show_taxi_light_warning_box = 1
		warning_text = "landing lights OFF"
	else
		show_taxi_light_warning_box = 0
	end

end

function draw_warning_box()

	if show_taxi_light_warning_box == 1 then	

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
		draw_string_Helvetica_12(warning_box_x + 3 , warning_box_y + 2, warning_text)
	
	end
	
end

-- check it every 10 sec
do_sometimes("switch_b757_landing_lights()")

-- draw the warning box
do_every_draw("draw_warning_box()")
