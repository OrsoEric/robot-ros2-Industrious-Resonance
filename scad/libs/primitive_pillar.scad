
module pillar
(
	i_d_hole = 2.75,
	i_d_top = 6,
	i_d_base = 10,
	i_h_slot = 6,
	i_h_pillar = 30,
	//Vertical sections
	i_h_vertical = 5,
	i_n_resolution = 60,
	//NUT at the base
	i_d_nut = 6.5,
	i_h_nut = 3.0
)
{

	ap_pillar = 
	[
		//X out Y up
		[0,0],
		[i_d_base/2, 0],
		[i_d_base/2, i_h_vertical],
		[i_d_top/2, i_h_pillar -i_h_vertical],
		[i_d_top/2, i_h_pillar],
		[0, i_h_pillar]

	];

	difference()
	{
		union()
		{
			rotate_extrude(angle=360,$fn=i_n_resolution)
			polygon(ap_pillar);
		}
		union()
		{
			//Core hole
			translate([0,0,i_h_nut])
			cylinder(h = i_h_pillar-i_h_nut, d = i_d_hole, $fn=i_n_resolution);
			//Nut hole
			rotate([0,0,90])
			cylinder(h = i_h_nut, d = i_d_nut, $fn=6);
			//Slot
			translate([0,-i_d_nut/2,0])
			cube([i_d_base/2,i_d_nut,i_h_nut]);
		}
	}
}

//pillar();