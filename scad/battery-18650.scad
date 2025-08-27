//		2024-06-23
//	Printed but too short for the batteries
//		2025-08-26
//	Model for just the battery with margin


//Library to draw 18650 batteries
//Legend:
//gl = Global Length
//gw =
//gh

//Battery constants
gl_18650 = 66.0;
gd_18650 = 18.4;
gl_18650_key = 3.0;
gd_18650_key = 10.0;

//can be modeled sideway on x with rotation flag
module battery_18650
(
	ix_sideway = 0,
	in_invert_poles = false,
	in_precision = 0.5
)
{
    if (in_invert_poles == false)
    {
        gl_18650_nokey = gl_18650 -gl_18650_key;
        translate([0,0,gd_18650/2* ix_sideway])
        rotate([0,90*ix_sideway,0])
        union()
        {
            color("blue")
            linear_extrude( gl_18650_nokey )
            circle( d=gd_18650, $fa = in_precision, $fs =in_precision );
            
            color("gold")
            translate( [0,0,gl_18650_nokey] )
            linear_extrude( gl_18650_key )
            circle( d=gd_18650_key, $fa = in_precision, $fs =in_precision );
        }
    }
    else
    {
        gl_18650_nokey = gl_18650 -gl_18650_key;
        translate([0,0,gd_18650/2* ix_sideway])
        rotate([0,90*ix_sideway,0])
        union()
        {
            color("gold")
            linear_extrude( gl_18650_key )
            circle( d=gd_18650_key, $fa = in_precision, $fs =in_precision );

            translate( [0,0,gl_18650_key] )
            color("blue")
            linear_extrude( gl_18650_nokey )
            circle( d=gd_18650, $fa = in_precision, $fs =in_precision );
        }
    }
}

//battery_18650();