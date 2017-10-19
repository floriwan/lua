
OUTPUT_DIR = 'C:\\Users\\fgz\\Desktop\\twitch\\'
FL_FILE = 'flightlevel.txt'

dataref("altitude_ft_pilot", "sim/cockpit2/gauges/indicators/altitude_ft_pilot")
dataref("vvi_fpm_pilot", "sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
dataref("groundspeed", "sim/flightmodel/position/groundspeed")

old_altitude = 0;
old_speed = 0;

function dump_data()

	altitude = string.format("%05d", altitude_ft_pilot)
	vertical_speed = string.format("%03d", vvi_fpm_pilot)
	speed = string.format("%03d", groundspeed * 1.94384) -- meter/sec to kts

	if old_altitude ~= altitude or old_speed ~= speed then
		out_string = "ground speed: " .. speed .. "kts  altitude: " .. altitude .. "ft"
	
		alt_file = io.open(OUTPUT_DIR .. FL_FILE, 'w')
		alt_file:write(out_string)
		alt_file:close()
		
		old_altitude = altitude
		old_speed = speed
	end
	
end


do_often("dump_data()")
