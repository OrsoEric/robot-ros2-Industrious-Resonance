
include <libs/shape_rounded_rectangle.scad>

//Model of the Rasperry Pi 3 and 5
//include <libs/raspberry_pi_3.scad>
//include <libs/rpi_support.scad>
//Model of the servo
include <libs/hs422-servo.scad>
include <libs/servo_holder.scad>
//Model of the batteries
include <libs/battery-18650.scad>
//Holder for a pivot tennis ball
include <libs/ball_holder.scad>


include <battery-18650-holder.scad>


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
	i_x_show_rpi = false,
	i_x_show_servo = false,
	i_x_show_battery = false,
	i_x_show_pivot = false,
	//Thickness of the base
	i_t_base = 3.5,
	//Precision
	i_e_precision = 0.05
)
{
	//Base Dimension
	c_l_base = 200.0;
	c_w_base = 140.0;
	c_r_base = 50.0;


	//Height offset of wheels
	ho_wheel = 11.0;
	//Specs of the wheels
	d_wheel = 70.0 + 5.0;
	t_wheel = 7.0 + 2.0;
	//Margin to apply to the wheel hole
	lm_wheel = -5.0;
	wm_wheel = 2.0;
	//Position of the motors on the base
	l_wheel = 28.0;
	w_wheel = 42.0;

	//Offset of the pivot wheel
	lo_pivot = -60;
	//This is a number to control anchor between pivot mechanism and its base
	//I can't be bothered to work out the angles with the arcsin to make it work without this parameter
	ho_pivot = 12;
	//Diameter of the hole where I'll stot in the pivot wheel mechanism
	d_pivot_cutout = 60;
	//Diameter of the pivot sphere (a tennis ball I had laying around)
	d_pivot_sphere = 40.0;

	//BASE parameters
	t_base = i_t_base;


	difference()
	{
		union()
		{
			//linear_extrude(h=i_t_base)
			//ellipse(x_r=c_r_base_major, y_r=c_r_base_minor);

			shape_rounded_rectangle
			(
				//Dimensions of the rectangle
				i_l = c_l_base,
				i_w = c_w_base,
				i_h = i_t_base,
				//Rounding of the corners in the XY direction
				i_r_rounding = c_r_base,
				//Error by the approximation
				i_n_error = i_e_precision
			);


			if (i_x_show_rpi == true)
			{
				if (false)
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
				translate
				([
					l_wheel,
					-w_wheel,
					gw_hs422/2+i_t_base+ho_wheel
				])
				rotate([0,180,90])
				HS422_wheel(i_d_wheel = d_wheel,i_t_wheel = t_wheel);

				//Left Wheel
				translate
				([
					l_wheel,
					w_wheel,
					gw_hs422/2+i_t_base+ho_wheel
				])
				rotate([0,0,90])
				HS422_wheel(i_d_wheel = d_wheel,i_t_wheel = t_wheel);
				
			}

			if (i_x_show_pivot==true)
			{
				color("#ffffff")
				translate([lo_pivot,0,ho_pivot])
				sphere(d=gd_ball,$fn=100);
			}

			holder_18650_2s1p( ix_show_battery = true, ix_show_tab = true );

		}
		//Extrude
		union()
		{
			//Right Wheel
			translate
			([
				l_wheel,
				-w_wheel - t_wheel * 0.5 - wm_wheel,
				0
			])
			linear_extrude(h=i_t_base)
			square([d_wheel+lm_wheel,t_wheel+wm_wheel],center=true);

			//Left Wheel
			translate
			([
				l_wheel,
				+w_wheel + t_wheel * 0.5 + wm_wheel,
				0
			])
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
		//Ball
		i_d_ball = 40.0,
		i_d_base = d_pivot_cutout,
		//Structural Strength
		i_t_structure = 4.0,
		i_t_hold = 3.0,
		//Height margin of the base
		i_ho_base = ho_pivot,
		//Thickness of the base
		i_t_base = i_t_base
	);

	//Length Offset of wheels
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
	if (false)
	translate([5,-20,t_base+30])
	rpi_support_pillars
	(
		i_d_top = 6,
		i_d_bot = 10,
		i_h_pillar = 20,
		i_h_vertical = 4
	);


}

industrious_resonance
(
	i_x_show_servo = true,
	i_x_show_pivot = true
);