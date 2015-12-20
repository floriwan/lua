--
-- Draw a warning box if the landing lights are off below FL100
-- or still on above FL100. 
-- If the gear leaver is in down position, no landing light check is done.
--

require("graphics")

DataRef( "xp_landing_lights_on", "sim/cockpit/electrical/landing_lights_on", "readonly")
DataRef( "xp_altitude_pilot", "sim/cockpit2/gauges/indicators/altitude_ft_pilot", "readonly" )
DataRef( "xp_gear_handle_status", "sim/cockpit/switches/gear_handle_status", "readonly")

local warning_box_x = 10
local warning_box_y = 100
local warning_box_width = 110
local warning_box_height = 15

show_taxi_light_warning_box = 0
warning_text = ""

function check_landing_lights()
	
	if xp_gear_handle_status == 1 then 
		show_taxi_light_warning_box = 0
	elseif xp_landing_lights_on == 1 and xp_altitude_pilot > 95000 then
		show_taxi_light_warning_box = 1
		warning_text = "landing lights ON"
	elseif xp_landing_lights_on == 0 and xp_altitude_pilot < 105000 then
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
do_sometimes("check_landing_lights()")

-- draw the warning box
do_every_draw("draw_warning_box()")
