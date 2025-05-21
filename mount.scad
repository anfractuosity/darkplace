// Night Vision adapter for P8079HP image intensifier
// Based on EF mount from http://www.thingiverse.com/thing:1029872/#files
//
// I found with that EF mount there where no locking 'tabs' so I added those
// and added an additional cylinder which the night vision tube fits into

$fa = 1.0;
$fs = 1.0;
clearance = 0.0; // increase up to max 1.0 if too tight

module wedge_180(h, r, d)
{
	rotate(d) difference()
	{
		rotate(180-d) difference()
		{
			cylinder(h = h, r = r);
			translate([-(r+1), 0, -1]) cube([r*2+2, r+1, h+2]);
		}
		translate([-(r+1), 0, -1]) cube([r*2+2, r+1, h+2]);
	}
}

module wedge(h, r, d){
	intersection()
	{
		if(d <= 180)
			wedge_180(h, r, d);
		else
			rotate(d) difference()
			{
				cylinder(h = h, r = r);
				translate([0, 0, -1]) wedge_180(h+2, r+1, 360-d);
			}
	}
}

module Ring(outer, inner, height)
{
	intersection(){
		difference() {
			cylinder(h = height, r = outer/2);
			cylinder(h = height, r = inner/2);
		}
	}
}

module EFmountSocket()
{
	union()
	{
		translate([0, 0, 7])
		difference()
		{
			Ring(59, 51, 1.5);
			union()
			{
				wid = 80;
				wedge(1.5, 59, wid);
				rotate([0, 0, 240])
					wedge(1.5, 59, wid);
				rotate([0, 0, 120])
					wedge(1.5, 59, wid);
			}
		}
		difference()
		{
			translate([0, 0, 5])
				cylinder(h = 6, r = 60/2);
			union()
			{
				translate([0, 0, 7])
					cylinder(h = 4, r = 55/2 + clearance);
				translate([0, 0, 5])
					cylinder(h = 2, r = 55/2 + clearance);
			}
		}
	}
}

union()
{
	translate([0, 0, 10])
		Ring(73, 55, 10);

	// Cylinder to hold night vision tube
	translate([0, 0, 10])
		Ring(73, 70, 20 * 4);

	EFmountSocket();

	// Add locking tabs for EF mount
	for(i = [0 : 3])
	{
		rotate(36 + (i * 120))
		{
			translate([0, (55 / 2) - 1.5, 7 + (1.5/2)])
			{
				cube([1.5, 1.5, 3]);
			}
		}
	}
}
