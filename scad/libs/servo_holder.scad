//Model of the servo
include <hs422-servo.scad>

translate([0,0,10+20])
HS422();


//This is a wide pillar that houses one side of the servo
module pillar
(
	i_l_base = 40,
	i_h_base = 10,
	i_l_top = 20,
	i_h_top = 60,
	i_t = 10
)
{



	ap_pillar = 
	[
		//X out, Y up
		//Origin
		[0,0],
		//Out to base
		[i_l_base,0],
		//Up to straight 
		[i_l_base,i_h_base],
		//slope
		[i_l_top, i_h_top],
		//in and close
		[0, i_h_top]
	];

	linear_extrude(h=i_t)
	polygon(ap_pillar);


}

pillar();