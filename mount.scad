// Night Vision adapter for P8079HP image intensifier
//
// Uses EF mount from:
// http://www.thingiverse.com/thing:1029872/#files (adapted to add locking tabs)
// and nut cutout from:
// https://www.printables.com/model/772241-m3-nut-cutout-model-with-openscad-code/files
//
// I found with that EF mount there where no locking 'tabs' so I added those.
// I added a cylinder which the night vision tube fits into, battery holder and
// switch holder.

$fn = 128;
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

module wedge(h, r, d)
{
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
	intersection()
	{
		difference()
		{
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

screw_dim=3.2;
nut_dim=6.64;
nut_height=2.6;
nut_first_plat=0.4;
nut_second_plat=0.2;
first_plat_size=3.2;
second_plat_size=5.75;

// nut cutout with screw
module draw_nut_cutout(screw_length)
{
    cylinder( d=nut_dim, h=nut_height, $fn=6);
    translate([0,0,nut_height])
    cylinder( d=screw_dim, h=screw_length);
}

difference(){
	// Thickness of wall
	wall = 2;
	bat_len = 85 + 6.9 + wall;
	bat_wid = 21 + wall;
	bat_hig = 21;
	union()
	{
		// Internal diameter
		nighttube = 71;

		// External diameter
		nighttube_edge = 75;

		translate([0, 0, 10])
			Ring(nighttube_edge, 55, wall);

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

		translate([0, 0, 10])
		difference()
		{
			union()
			{
				Ring(nighttube_edge, nighttube, 20 * 5);
				for(i = [0 : 2])
				{
					rotate([-i * 120 + 300, 90, 0])
					translate([-80, 0, 35.4 + 3])
						cylinder(d=8,h=3, center = true);
				}
			}

			for(i = [0 : 2])
			{
				rotate([-i * 120 + 300, 90, 0])
				translate([-80, 0, 35.4])
				union()
				{
					draw_nut_cutout(100);
				}
			}
		}

		// Battery holder
		rotate([0, 90, 0])
		translate([-110, - (bat_wid / 2), 35.5])
		union(){
			translate([87, 0, 0])
			difference()
			{
				union()
				{
					difference()
					{
						cube([6.9, bat_wid+wall, bat_hig + wall - 6.5 ]);
						translate([6.9 / 2 - 1.5 / 2,  12.7 / 2, 8])
						cube([2.5, 12.7, bat_hig + wall - 6.5 ]);
					}
					translate([-wall, 0, 0])
						cube([wall, bat_wid+wall, bat_hig + wall]);
				}

				translate([-wall, 12.7 / 2, 0])
					cube([10, 7.5 * 1.5, 12.7]);
			}

			difference()
			{
				cube([bat_len + wall, bat_wid + wall, bat_hig + wall]);
				translate([wall, wall, wall])
				cube([bat_len - wall, bat_wid - wall, bat_hig]);
			}
		}
	}

	// Hole for wires
	translate([0,0,30])
	rotate([0,90,0])
		cylinder(100,4,4);
}