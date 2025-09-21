include <raspberry_pi_3.scad>
include <primitive_pillar.scad>

//M3 hole = 2.75
//M3 nut = 6.5


module rpi_support_pillars
(
	i_d_top = 6,
	i_d_bot = 10,
	i_h_pillar = 20,
	i_h_vertical = 4
)
{
	for (lo_temp = [0,gli_pi3_hole])
	{
		for (wo_temp = [0,gwi_pi3_hole])
		{
			translate([lo_temp,wo_temp,0])
			pillar
			(
				i_d_hole = 2.75,
				i_d_top = i_d_top,
				i_d_base = i_d_bot,
				i_h_slot = 6,
				i_h_pillar = i_h_pillar,
				//Vertical sections
				i_h_vertical = i_h_vertical,
				i_n_resolution = 60,
				//NUT at the base
				i_d_nut = 6.5,
				i_h_nut = 3.0
			);
		}
	}

}

//rpi_support_pillars();