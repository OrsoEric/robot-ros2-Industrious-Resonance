


module ellipse(x_r=5, y_r=10, i_n_points = 100) {
    ap_ellipse =
	[
        for (n_index = [0 : i_n_points - 1])
            let (a_tempe = 360 * n_index / i_n_points)
			[x_r * cos(a_tempe), y_r * sin(a_tempe)]
    ];
    polygon(ap_ellipse);
}


module vein
(
	i_h_beam = 30,
	i_w_beam = 5,
	i_t_beam = 2,
	i_l_vein = 10,
	i_t_vein = 1
)
{
	linear_extrude(h=i_h_beam)
	square([i_w_beam,i_t_beam]);

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

vein();

//This creates two vertical brackets with screw hole and reinforcing veins
module servo_holder
(

)
{


}

servo_holder();


//

module industrious_resonance
(
)
{

	c_r_base_major = 100.0;
	c_r_base_minor = 60.0;

	linear_extrude(h=3);
	ellipse(x_r=c_r_base_major, y_r=c_r_base_minor);


	



}

//industrious_resonance();