//Model of the Rasperry Pi 3 and 5
include <libs/raspberry_pi_3.scad>
//Model of the servo
include <libs/hs422-servo.scad>
//Model of the batteries
include <libs/battery-18650.scad>
//Holder for a pivot tennis ball
include <libs/ball_holder.scad>

module ellipse
(
	x_r=5,
	y_r=10,
	i_n_points = 100
)
{
    ap_ellipse =
	[
        for (n_index = [0 : i_n_points - 1])
            let (a_tempe = 360 * n_index / i_n_points)
			[x_r * cos(a_tempe), y_r * sin(a_tempe)]
    ];
    polygon(ap_ellipse);
}

module vertical_support
(
	i_h_beam = 30,
	i_l_vein = 10,
	i_t_vein = 1
)
{
	translate([i_t_vein,0,i_h_beam])
	rotate([-90,0,90])
	linear_extrude(h=i_t_vein)
	polygon
	([
		[0,0],
		[0,i_h_beam],
		[i_l_vein,i_h_beam]
	]);
}


module vein
(
	i_d_hole = 3.2,
	i_h_hole = gw_hs422/2,

	i_h_beam = 30,
	i_w_beam = 8,
	i_t_beam = 2,
	i_l_vein = 10,
	i_t_vein = 1
)
{
	difference()
	{
		union()
		{
			linear_extrude(h=i_h_beam)
			square([i_w_beam,i_t_beam]);

			vertical_support
			(
				i_h_beam = i_h_beam,
				i_l_vein = i_l_vein,
				i_t_vein = i_t_vein
			);

		}
		union()
		{
			translate([i_w_beam/2,i_t_beam,i_h_hole+gwi_hs422_hole/2])
			rotate([90,0,0])
			cylinder(d=i_d_hole,h=i_t_beam,$fn=20);

			translate([i_w_beam/2,i_t_beam,i_h_hole-gwi_hs422_hole/2])
			rotate([90,0,0])
			cylinder(d=i_d_hole,h=i_t_beam,$fn=20);


		}
	}
}

//vein();

//This creates two vertical brackets with screw hole and reinforcing veins
module servo_holder
(

)
{


}


module industrious_resonance
(
	i_x_show_rpi = true,
	i_x_show_servo = true,
	i_x_show_battery = true,
	i_x_show_pivot = true,
	//Thickness of the base
	i_t_base = 3.5,
	dummy
)
{

	c_r_base_major = 120.0;
	c_r_base_minor = 90.0;

	//Height offset of wheels
	ho_wheel = 11.0;
	//Specs of the wheels
	d_wheel = 70.0;
	t_wheel = 2.5;
	//Margin to apply to the wheel hole
	m_wheel = 2.0;
	//Position of the motors on the base
	l_wheel = 45.0;
	w_wheel = 55.0;

	//Offset of the pivot wheel
	lo_pivot = -70;
	//This is a number to control anchor between pivot mechanism and its base
	//I can't be bothered to work out the angles with the arcsin to make it work without this parameter
	ho_pivot = 12;
	//Diameter of the hole where I'll stot in the pivot wheel mechanism
	d_pivot_cutout = 60;
	//Diameter of the pivot sphere (a tennis ball I had laying around)
	d_pivot_sphere = 40.0;

	//BASE parameters<
	t_base = i_t_base;


	difference()
	{
		union()
		{
			linear_extrude(h=i_t_base)
			ellipse(x_r=c_r_base_major, y_r=c_r_base_minor);


			vein();

			if (i_x_show_rpi == true)
			{
				translate([-40,+00,t_base+5])
				rotate([0,0,270])
				raspberry_pi_3();
			}


			if (i_x_show_battery == true)
			{

				for (n_cnt =[0:4-1])
				{
					translate([-20,+(n_cnt-1.5)*gd_18650,t_base])
					battery_18650(ix_sideway = 0,in_invert_poles=false );
				}
			}

			if (i_x_show_servo == true)
			{
				//Right Wheel
				
				translate([l_wheel,-w_wheel,gw_hs422/2+i_t_base+ho_wheel])
				rotate([0,180,90])
				HS422_wheel(i_d_wheel = d_wheel,i_t_wheel = t_wheel);
				//Left Wheel
				translate([l_wheel,w_wheel,gw_hs422/2+i_t_base+ho_wheel])
				rotate([0,0,90])
				HS422_wheel(i_d_wheel = d_wheel,i_t_wheel = t_wheel);
				
			}

			if (i_x_show_pivot==true)
			{
				color("#ffffff")
				translate([lo_pivot,0,ho_pivot])
				sphere(d=gd_ball,$fn=100);
			}

		}
		//Extrude
		union()
		{
			//Right Wheel
			translate([l_wheel,-w_wheel-1.5*t_wheel-0.5*m_wheel,0])
			linear_extrude(h=i_t_base)
			square([d_wheel+m_wheel,t_wheel+m_wheel],center=true);
			//Left Wheel
			translate([l_wheel,+w_wheel+1.5*t_wheel+0.5*m_wheel,0])
			linear_extrude(h=i_t_base)
			square([d_wheel+m_wheel,t_wheel+m_wheel],center=true);
			//An hole where I'll slot in the pivot wheel
			translate([lo_pivot,0,0])
			cylinder(h=i_t_base,d=d_pivot_cutout, $fn=80);


		}
	}

	translate([lo_pivot,0,0])
	ball_holder
	(
		i_d_ball = 40.0,
		i_d_base = d_pivot_cutout,
		//Height margin of the base
		i_ho_base = ho_pivot,

		i_t_base = i_t_base
	);

}

industrious_resonance();