
OUTPUT_DIR = 'C:\\Users\\Florian\\Desktop\\twitch\\'
FL_FILE = 'flightlevel.txt'

dataref("altitude_ft_pilot", "sim/cockpit2/gauges/indicators/altitude_ft_pilot")
dataref("vvi_fpm_pilot", "sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
dataref("groundspeed", "sim/flightmodel/position/groundspeed")

old_altitude = 0;
old_speed = 0;

-- nothing todo with the export, set some shadow values
--set("sim/private/controls/skyc/max_shadow_angle",-89) 
--set("sim/private/controls/skyc/min_shadow_angle",-90)

function dump_data()

	altitude = string.format("%05d", altitude_ft_pilot)
	vertical_speed = string.format("%04d", vvi_fpm_pilot)
	speed = string.format("%03d", groundspeed * 1.94384) -- meter/sec to kts

	if old_altitude ~= altitude or old_speed ~= speed then
		
		-- out_string = "X-Plane 11 / ground speed: " .. speed .. "kts vertical speed: " .. vertical_speed .. "ft/m altitude: " .. altitude .. "ft"
	
		out_string = "G/S: " .. speed .. "kts  ALT: " .. altitude .. "ft  V/S: " .. vertical_speed .. "fpm "
		
		alt_file = io.open(OUTPUT_DIR .. FL_FILE, 'w')
		alt_file:write(out_string)
		alt_file:close()
		
		old_altitude = altitude
		old_speed = speed
	end
	
end


do_often("dump_data()")
