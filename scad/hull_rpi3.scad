//Model of the Rasperry Pi 3 and 5
include <libs/raspberry_pi_3.scad>
include <libs/rpi_support.scad>
//Model of the servo
include <libs/hs422-servo.scad>
include <libs/servo_holder.scad>
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

module industrious_resonance
(
	i_x_show_rpi = true,
	i_x_show_servo = false,
	i_x_show_battery = false,
	i_x_show_pivot = false,
	//Thickness of the base
	i_t_base = 3.5,
	dummy
)
{

	c_r_base_major = 90.0;
	c_r_base_minor = 60.0;

	//Height offset of wheels
	ho_wheel = 11.0;
	//Specs of the wheels
	d_wheel = 70.0;
	t_wheel = 8;
	//Margin to apply to the wheel hole
	lm_wheel = -5.0;
	wm_wheel = 2.0;
	//Position of the motors on the base
	l_wheel = 22.0;
	w_wheel = 37.0;

	//Offset of the pivot wheel
	lo_pivot = -40;
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


			if (i_x_show_rpi == true)
			{
				translate([65,30,t_base+40])
				rotate([0,0,180])
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
			translate([l_wheel,-w_wheel-1.5*t_wheel-0.5*wm_wheel,0])
			linear_extrude(h=i_t_base)
			square([d_wheel+lm_wheel,t_wheel+wm_wheel],center=true);
			//Left Wheel
			translate([l_wheel,+w_wheel+1.5*t_wheel+0.5*wm_wheel,0])
			linear_extrude(h=i_t_base)
			square([d_wheel+lm_wheel,t_wheel+wm_wheel],center=true);

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

	g_lo_wheel = 9.5;

	//Right Wheel
	translate([l_wheel+g_lo_wheel,-w_wheel,i_t_base])
	rotate([0,0,90])
	servo_holder
	(
		i_x_show_servo = false
	);

	//Left Wheel
	translate([l_wheel+g_lo_wheel,+w_wheel,i_t_base])
	rotate([0,0,-90])
	servo_holder
	(
		i_x_show_servo = false
	);

	//RPI Support
	translate([5,-20,t_base+30])
	rpi_support_pillars
	(
		i_d_top = 6,
		i_d_bot = 10,
		i_h_pillar = 20,
		i_h_vertical = 4
	);


}

industrious_resonance();