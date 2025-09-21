//Given a ball of diameter D
//Create an holder with a number of semi sphjeresto let the ball rotate without much attrition
//It should have spring tabs to hold the ball

//I create three arms, each with two semisphere that converge above the ball
//Other three arms go anchor to the base where it's screwed

include <primitive_arm_arc.scad>

//Diameter of the ball that needs to be held
gd_ball = 40.0;


//It's an arm arc, but adds cushion spheres to minimize contact area with the ball itself
module arm_arc_with_balls
(
	i_r_inner = 20,   // Inner radius of the arc
    i_r_outer = 40,   // Outer radius of the arc
    i_a_arc_start = 90, // Start angle in degrees
    i_a_arc_end = 10,   // End angle in degrees
    i_t = 10,          // Thickness (height) of the extruded arc
    i_n_points = 10,    // Number of points for arc approximation
	i_d_sphere = 5,		//Diameter of the cushion sphere
	i_n_sphere = 2		//Number of cushion spheres
)
{
	arm_arc
	(
		i_r_inner = i_r_inner,
		i_r_outer = i_r_outer,
		i_a_arc_start = i_a_arc_start, // Start angle in degrees
		i_a_arc_end = i_a_arc_end,   // End angle in degrees
		i_t = i_t,          // Thickness (height) of the extruded arc
		i_n_points = i_n_points    // Number of points for arc approximation
	);
	if(i_n_sphere>1)
	for (n_temp = [1:i_n_sphere-1])
		let(a_sphere = i_a_arc_start +(i_a_arc_end-i_a_arc_start)*n_temp/(i_n_sphere+0))
		translate([
			i_r_inner * cos(a_sphere),
			0,
			i_r_inner * sin(a_sphere)

		])
		sphere(d=i_d_sphere,$fn=100);



	translate([
		i_r_inner * cos(i_a_arc_start +(i_a_arc_end-i_a_arc_start)*0.95),
		0,
        i_r_inner * sin(i_a_arc_start +(i_a_arc_end-i_a_arc_start)*0.95)

	])
	sphere(d=i_d_sphere,$fn=80);
}

//arm_arc_with_balls();


module donut
(
	i_r_internal = 40,
	i_d_external = 60,
	i_h = 5,
	i_n_resolution = 80
)
{
	difference()
	{
		union()
		{
			//Base
			cylinder(h=i_h,d=i_d_external,$fn=i_n_resolution);
		}
		union()
		{
			//Drill
			cylinder(h=i_h,d=i_r_internal,$fn=i_n_resolution);

		}

	}

}

module ball_holder_base
(
	i_d_hole = 41,
	i_d_external = 65,

	i_h_base = 5,
	
	//Number of sectors cut into the base for the holders
	i_n_sector = 3,
	//Margin separation between sector and base, game of the arm
	i_m_sector = 1,
	//Size of the sector
	i_d_sector = 30,
	//Interference between sector and base, it's an arc
	i_di_sector = 10,

	i_n_resolution = 60
)
{

	difference()
	{
		union()
		{
			donut(i_d_hole,i_d_external,i_h_base,i_n_resolution);
		}
		union()
		{
			//Ball hole
			//cylinder(h=i_h_base,d=i_d_hole,$fn=i_n_resolution);
			//Sector
			for (n_cnt = [0:(i_n_sector-1)])
			{
				translate
				([
					(i_d_hole/2 -i_d_sector/2 +i_di_sector/2)*cos(n_cnt/(i_n_sector)*360),
					(i_d_hole/2 -i_d_sector/2 +i_di_sector/2)*sin(n_cnt/(i_n_sector)*360),
					0
				])
				donut
				(
					i_r_internal = i_d_sector,
					i_d_external = i_d_sector+i_m_sector,
					i_h = 5,
					i_n_resolution = i_n_resolution
				);
			}
			
		}

	}


}

//ball_holder_base();

module ball_holder
(
	
	i_d_ball = 40.0,
	i_d_base = 70.0,
	//Height margin of the base
	i_ho_base = 13,

	i_t_base = 5

)
{
	//How much bigger are the structural arm in diameter
	dm_struct_hold = 3.0;

	//Diameter of the cushion spheres
	d_cushion = 6;
	//Interference between the ball and the cushion
	i_ball_cushion = 0.0;

	//The structural arm have a bigger radious
	d_arm_struct = i_d_ball +dm_struct_hold;
	w_arm_struct = 20;
	t_arm_struct = 10;

	d_arm_hold = i_d_ball;
	w_arm_hold = 10;
	t_arm_hold = 5;

	t_base = 2;


	n_resolution = 50;

	
	ball_holder_base
	(
		i_d_hole = i_d_ball+1,
		i_d_external = i_d_base,

		i_h_base = i_t_base,
		i_n_resolution = n_resolution,
		//Number of sectors cut into the base for the holders
		i_n_sector = 3,
		//Margin separation between sector and base, game of the arm
		i_m_sector = 2,
		//Size of the sector
		i_d_sector = 20,
		//Interference between sector and base, it's an arc
		i_di_sector = 15
	);

	//Add a cap to smooth out the merging of the arms
	translate([0,0,d_arm_struct/2+i_ho_base])
	cylinder(h=t_arm_struct*1.0,d=0.7*i_d_ball,$fn=n_resolution);


	translate([0,0,i_ho_base])
	for (a_ray = [0+60,120+60,240+60])
		rotate([0,0,a_ray])
		arm_arc
		(
			i_r_inner = d_arm_struct/2,   // Inner radius of the arc
			i_r_outer = d_arm_struct/2+t_arm_struct,   // Outer radius of the arc
			i_a_arc_start = 90, // Start angle in degrees
			i_a_arc_end = -16,   // End angle in degrees
			i_t = w_arm_struct,          // Thickness (height) of the extruded arc
			i_n_points = n_resolution    // Number of points for arc approximation
		);

	translate([0,0,i_ho_base])
	for (a_ray = [0,120,240])
		rotate([0,0,a_ray])
		arm_arc_with_balls
		(
			i_r_inner = d_arm_hold/2+d_cushion/2-i_ball_cushion,   // Inner radius of the arc
			i_r_outer = d_arm_hold/2+d_cushion/2-i_ball_cushion+t_arm_hold,   // Outer radius of the arc
			i_a_arc_start = 90, // Start angle in degrees
			i_a_arc_end = -21,   // End angle in degrees
			i_t = w_arm_hold,          // Thickness (height) of the extruded arc
			i_n_points = n_resolution,    // Number of points for arc approximation
			i_d_sphere = d_cushion,		//Diameter of the cushion sphere
			i_n_sphere = 3		//Number of cushion spheres
		);




}

if (false)
color("#ffffff")
translate([0,0,13])
sphere(d=gd_ball,$fn=100);

if (false)
ball_holder();
