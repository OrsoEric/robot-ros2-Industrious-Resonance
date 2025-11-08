
include <libs/shape_rounded_rectangle.scad>

//Model of the Rasperry Pi 3 and 5
//include <libs/raspberry_pi_3.scad>
include <libs/sbc_support.scad>
//Model of the servo
//include <libs/hs422-servo.scad>
include <libs/servo_holder.scad>

//Holder for a pivot tennis ball
include <libs/ball_holder.scad>

include <battery-18650-holder.scad>

include <sbc_lattepanda_mu_lite_board.scad>


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
	i_x_show_sbc = false,
	i_x_show_servo = false,
	i_x_show_battery = false,
	i_x_show_pivot = false,
	//Thickness of the base
	i_t_base = 2.0,
	//Precision
	i_e_precision = 0.05
)
{
	//------------------------------------------------------------------
	//	BASE
	//------------------------------------------------------------------

	//Base Dimension
	c_l_base = 210.0;
	c_w_base = 150.0;
	c_r_base = 60.0;

	//BASE parameters
	t_base = i_t_base;
	//------------------------------------------------------------------
	//	PIVOT
	//------------------------------------------------------------------

	//Offset of the pivot wheel
	lo_pivot = -70;
	//This is a number to control anchor between pivot mechanism and its base
	//I can't be bothered to work out the angles with the arcsin to make it work without this parameter
	ho_pivot = 10;
	//Diameter of the hole where I'll stot in the pivot wheel mechanism
	d_pivot_cutout = 60;
	//Diameter of the pivot sphere (a tennis ball I had laying around)
	d_pivot_sphere = 40.0;
	//Clearance under the base
	h_pivot_clearance = d_pivot_sphere / 2 - ho_pivot;

	echo("Pivot ball clearance: ",h_pivot_clearance);
	//------------------------------------------------------------------
	//	WHEELS
	//------------------------------------------------------------------

	//Position of the motors on the base
	l_wheel = 40.0;
	w_wheel = 51.0;
	//Height offset of wheels
	//ho_wheel = 0.0;
	//Specs of the wheels
	d_wheel = 62.0;
	t_wheel = 7.0;
	//Margin to apply to the wheel hole
	wm_wheel = -0.5;
	tm_wheel = 2.0;
	dm_wheel = 5.0;
	//Parameters to adjust the relative position of wheel and servo
	wo_wheel = gh_hs422_flange / 2;

	//Height of the servo from floor of pillar
	//Wheel radious minus half servo thickness minus base thickness MINUS pivot height from floor clearance
	//
	h_floor_servo = d_wheel / 2 - 10 - t_base - h_pivot_clearance;

	//------------------------------------------------------------------
	//	BATTERY
	//------------------------------------------------------------------

	//Battery Offset
	lo_battery = -20;
	wo_battery = 0;

	//------------------------------------------------------------------
	//	SBC
	//------------------------------------------------------------------

	lo_sbc = 19.0;
	wo_sbc = 0.0;

	li_sbc_hole = g_li_lpmu_hole;
	wi_sbc_hole = g_wi_lpmu_hole;

	t_sbc = 33;

	//------------------------------------------------------------------
	//	GEOMETRY
	//------------------------------------------------------------------

	difference()
	{
		union()
		{
			//ROBOT BASE
			color("#888888")
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


			if (i_x_show_sbc == true)
			{
				translate
				([
					lo_sbc,
					wo_sbc,
					t_base+t_sbc
				])
				rotate([0,0,180])
				sbc_lattepanda_mu_lite_board();
			}

			//SBC Support
			color("orange")
			translate
			([
				lo_sbc,
				wo_sbc,
				t_base
			])
			sbc_support_pillars
			(
				i_d_top = 6,
				i_d_bot = 10,
				i_h_pillar = t_sbc,
				i_h_vertical = 6,
				//Interaxis between holes
				i_li_sbc = li_sbc_hole,
				i_wi_sbc = wi_sbc_hole
			);


			translate
			([
				lo_battery,
				wo_battery - c_w_base / 2,
				t_base
			])
			rotate([0,0,90])
			holder_18650_2s2p
			(
				ix_show_battery = i_x_show_battery,
				ix_show_tab = i_x_show_battery
			);

			//Right Wheel
			translate
			([
				l_wheel,
				-w_wheel,
				i_t_base
			])
			rotate([0,0,90])
			servo_holder
			(
				//Height of the servo from floor of pillar
				i_ho_servo = h_floor_servo,
				//Wheel
				i_d_wheel = d_wheel,
				i_t_wheel = t_wheel,
				//Visualize components
				i_x_right = true,
				i_x_show_servo = true,
				i_x_show_wheel = true,
				i_e_precision = 0.01
			);

			//Left Wheel
			translate
			([
				l_wheel,
				+w_wheel,
				i_t_base
			])
			rotate([0,0,-90])
			servo_holder
			(
				//Height of the servo from floor of pillar
				i_ho_servo = h_floor_servo,
				//Wheel
				i_d_wheel = d_wheel,
				i_t_wheel = t_wheel,
				//Visualize components
				i_x_right = false,
				i_x_show_servo = true,
				i_x_show_wheel = true,
				i_e_precision = 0.01
			);

		}
		//Extrude
		union()
		{
			//Right Wheel Hole
			translate
			([
				l_wheel,
				-w_wheel - wm_wheel - (t_wheel + tm_wheel) * 0.5,
				0
			])
			shape_rounded_rectangle
			(
				//Dimensions of the rectangle
				i_l = d_wheel + dm_wheel,
				i_w = t_wheel + tm_wheel,
				i_h = i_t_base,
				//Rounding of the corners in the XY direction
				i_r_rounding = 2,
				//Error by the approximation
				i_n_error = i_e_precision
			);


			//Left Wheel Hole
			translate
			([
				l_wheel,
				+w_wheel + wm_wheel + (t_wheel + tm_wheel) * 0.5,
				0
			])
			shape_rounded_rectangle
			(
				//Dimensions of the rectangle
				i_l = d_wheel+dm_wheel,
				i_w = t_wheel+tm_wheel,
				i_h = i_t_base,
				//Rounding of the corners in the XY direction
				i_r_rounding = 2,
				//Error by the approximation
				i_n_error = i_e_precision
			);

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
		i_t_base = i_t_base,
		//Show ball
		i_x_show_ball = i_x_show_pivot
	);


}

//industrious_resonance();

//if (false)
industrious_resonance
(
	i_x_show_sbc = false,
	i_x_show_battery = true,
	i_x_show_servo = true,
	i_x_show_pivot = true
);