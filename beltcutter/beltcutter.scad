// vim: filetype=cpp foldmethod=marker :
include <cbox.scad>

$fn = 50;
epsilon = .1;


d_guide = 8.5;
od_guide = 16;	// actual size is 15.
wall = 3;
swall = 1;
Cx = 4;
Cy = 30;
Ax = 20;
Ay = Cy + d_guide + 2 * wall;

h_slot = 30;
th_slot = 3;
d_drive = 12;
h_motor = h_slot - th_slot + d_drive / 2;
th_knife = .7;

nema17_side = 43.8;
nema17_dist = 31;
d_nema17_screw = 3.6;
d_motorhole = 23;

i_support = 8.5;
o_support = i_support + 8;
h_support1 = h_motor - nema17_side / 2 - o_support / 2 + epsilon;
h_support2 = h_motor + nema17_side / 2 + o_support / 2 - epsilon;

// knifeholder {{{

w_notch = 3;
h_notch = 5;
th_notch = th_knife;
d_notches = 6.5;

d_screw = 7;
h_screw = 6;

d_lead = 7;
dd_leadnut = 8;
d_leadnut = 2 * 8 / sqrt(3);
h_leadnut = 4;
h_guidebearing = 25;

h_base = h_guidebearing + 2 * wall;
h_notches = h_screw + 5;
h_lead = h_base - h_notch - h_notches - h_leadnut;

module notch(y, z) {
	union() {
		c(d = w_notch, h = th_notch + Cx / 2, ry = 90, x = -Cx / 2, y = y, z = z + w_notch / 2);
		box(-Cx / 2, th_notch, -w_notch / 2 + y, w_notch / 2 + y, w_notch / 2 + z, h_notch + z);
	}
}

A = [-Ax, -Ay];
B = [Ax, -Ay];
C = [-Cx, -Cy];
D = [0, -Cy];
E = [-Cx, Cy];
F = [0, Cy];
G = [-Ax, Ay];
H = [Ax, Ay];

module knifeholder() {
	//rotate([0, -90, 0])
	difference() {
		union() {
			for (y = [-1.5, -.5, .5, 1.5])
				notch(y * d_notches, h_notches);
			difference() {
				hull() {
					for (y = [-Ay, Ay])
						c(h = h_base, y = y, d = od_guide + swall * 2);
				}
				box(-th_knife / 2, od_guide / 2 + swall + 1, -Cy, Cy, -1, h_notch + h_notches);
			}
		}
		// Lead screw.
		c(d = d_lead, h = h_base + 1, z = h_notch + h_notches - epsilon);
		// Lead nut.
		union() {
			c(d = d_leadnut, h = h_leadnut, z = h_base - h_leadnut - swall, fn = 6);
			box(0, od_guide / 2 + swall + 1, -dd_leadnut / 2, dd_leadnut / 2, h_base - h_leadnut - swall, h_base - swall);
		}
		// Clamp screw.
		c(d = d_screw, h = 2 * Ax, ry = 90, x = -Ax, z = h_screw);
		// Guides.
		for (y = [-Ay, Ay]) {
			c(d = d_guide + swall, h = h_base + 2, z = -1, y = y);
			c(d = od_guide, h = h_base - 2 * wall, z = wall, y = y);
			c(d = od_guide, h = h_base + 2 * swall, z = -1, y = y, x = od_guide / 2);
		}
	}
}
// }}}

// Base. {{{

th_motorbracket = 5;
y_motorbracket = 20 - th_motorbracket / 2;
y_support = y_motorbracket - th_motorbracket / 2 - o_support / 2;

y_base1 = y_support;
x_bearing = 50;
l_bearing = 20;
w_base = o_support;
id_bearing = 8.5;

x_motor = Ax + o_support / 2 + nema17_side / 2 + wall;
id_idler = 8.5;
od_idler = 22;

w_slot = 8;
x_slot = x_motor;
x_slot_offset = 5;
slot_wall = 2;
cut = th_knife * 1.5;
wcut = 3 * cut;
cut_depth = 20;
d_trap = 2 * 13 / sqrt(3);
h_trap = 7;
cap_slot = 2;
guide_base = 5;
w_idlerblock = 10;
y_idlerblock = -Ay;

h_motorbracket_base = h_slot - th_slot - od_idler;
th_motorbracket_base = y_motorbracket * 2 - w_slot - wall;


module base_drive() { // {{{
	difference() {
		union() {
			box(Ax + o_support / 2 - wall, x_motor + nema17_side / 2, y_motorbracket - th_motorbracket / 2, y_motorbracket + th_motorbracket / 2, 0, h_motor + nema17_side / 2);
			box(Ax, x_motor + nema17_side / 2 + epsilon, y_motorbracket - th_motorbracket_base / 2, y_motorbracket + th_motorbracket_base / 2, 0, h_motorbracket_base);
		}
		for (x = [-.5, .5]) {
			for (z = [-.5, .5]) {
				c(d = d_nema17_screw, h = th_motorbracket + 2, rx = 90, y = y_motorbracket + th_motorbracket / 2 + 1, x = x_motor + x * nema17_dist, z = z * nema17_dist + h_motor);
			}
		}
		c(d = d_motorhole, h = th_motorbracket + 2, rx = 90, y = y_motorbracket + th_motorbracket / 2 + 1, z = h_motor, x = x_motor);
		c(d = id_idler, h = th_motorbracket + 2, rx = 90, y = y_motorbracket + th_motorbracket / 2 + 1, z = h_slot - th_slot - od_idler / 2, x = x_motor);
	}
} // }}}

module base_cutter() { // {{{
	difference() {
		union() {
			box(-Ax - o_support / 2, Ax + o_support / 2, -Ay - o_support / 2, Ay + o_support / 2, 0, h_slot);
			box(x_slot_offset, x_slot, -w_slot / 2 - wall, w_slot / 2 + wall, 0, h_slot + slot_wall + cap_slot);
			// idler block.
			box(0, x_motor + id_idler / 2 + wall, y_idlerblock - w_idlerblock / 2, y_idlerblock + w_idlerblock / 2, 0, h_slot - th_slot - od_idler / 2 + id_idler / 2 + wall);
		}
		// Motor holes.
		c(r = h_motor - h_slot + th_slot + wall, h = w_slot + 2 * wall + 2, rx = 90, y = w_slot / 2 + wall + 1, z = h_motor, x = x_motor);
		for (x = [-.5, .5]) {
			c(d = d_nema17_screw + 1, h = w_slot / 2 + wall + Ay + w_idlerblock / 2 + 2, rx = 90, y = w_slot / 2 + wall + 1, x = x_motor + x * nema17_dist, z = -nema17_dist / 2 + h_motor);
		}
		// Slots.
		box(-Ax - o_support - 1, x_slot + 1, -w_slot / 2, w_slot / 2, h_slot - th_slot, h_slot + cap_slot);
		box(-cut / 2, cut / 2, -Ay, Ay, h_slot - th_slot - cut_depth, h_slot + 1);
		translate([0, Ay, h_base]) {
			rotate([90, 0, 0]) {
				linear_extrude(height = 2 * Ay)
					polygon([[-cut / 2, -th_slot], [cut / 2, -th_slot], [wcut / 2, 0], [-wcut / 2, 0]]);
			}
		}
		// Holes.
		for (y = [-Ay, Ay]) {
			c(d = d_guide, h = h_slot, z = guide_base, y = y);
			for (x = [-Ax, Ax]) {
				c(d = d_guide, h = h_slot + 2, z = -1, x = x, y = y);
				c(d = d_trap, h = h_trap + 1, z = -1, x = x, y = y, fn = 6);
			}
		}
		// Idler.
		c(d = od_idler + wall, h = w_slot + 2 * wall + 2, rx = 90, y = w_slot / 2 + wall + 1, z = h_slot - th_slot - od_idler / 2, x = x_motor);
		box(x_motor - od_idler / 2 - wall / 2, x_motor + od_idler / 2 + wall / 2, -w_slot / 2 - wall - 1, w_slot / 2 + wall + 1, -1, h_slot - th_slot - od_idler / 2);
		c(d = id_idler, h = w_idlerblock + 2, rx = 90, y = y_idlerblock + w_idlerblock / 2 + 1, z = h_slot - th_slot - od_idler / 2, x = x_motor);
	}
} // }}}

module base() {
	union() {
		base_cutter();
		base_drive();
	}
}

// }}}

h_pusher = th_motorbracket;

module pusher() { // {{{
	difference() {
		box(-Ax - o_support / 2 - wall, Ax + o_support / 2 + wall, -Ay - o_support / 2 - wall, Ay + o_support / 2 + wall, 0, h_pusher);
		for (x = [-.5, .5]) {
			for (y = [-.5, .5]) {
				c(d = d_nema17_screw, h = h_pusher + 2, y = y * nema17_dist, x = x * nema17_dist, z = -1);
			}
		}
		c(d = d_motorhole, h = h_pusher + 2, z = -1);
		// Holes.
		for (y = [-Ay, Ay]) {
			c(d = d_guide, h = h_pusher + 2, z = -1, y = y);
			for (x = [-Ax, Ax]) {
				c(d = d_guide, h = h_pusher + 2, z = -1, x = x, y = y);
			}
		}
	}
} // }}}

// Stand. {{{
d_stand = 50;
h_stand = d_guide * 2 + wall * 3;
stand_offset = d_stand / 4;
stand_angle = 60;
d_foot = d_guide + 2 * wall;
h_foot = 30;

module stand_top() {
	difference() {
		c(d = d_stand, h = h_stand);
		rotate([0, 0, 90 - stand_angle / 2])
			c(d = d_guide, h = 3 * d_stand, rx = 90, y = d_stand * 1.5, x = stand_offset / 2, z = h_stand / 2 + d_guide / 2 + wall / 2);
		rotate([0, 0, -90 + stand_angle / 2])
			c(d = d_guide, h = 3 * d_stand, rx = 90, y = d_stand * 1.5, x = stand_offset / 2, z = h_stand / 2 - d_guide / 2 - wall / 2);
		c(d = d_guide, h = h_stand + 2, z = -1, x = -stand_offset);
	}
}

module stand_foot() {
	difference() {
		difference() {
			c(d = d_foot, h = h_foot * 2);
			translate([0, 0, h_foot])
				rotate([0, stand_angle / 2, 0])
					box(-10 * h_foot, 10 * h_foot, -d_foot / 2 - 1, d_foot / 2 + 1, 0, 10 * h_foot);
		}
		c(d = d_guide, h = h_foot - wall + 1, z = -1);
	}
}
// }}}

// Spooler. {{{
d_platform = 100;
h_platform = 4;
h_platform_bearing = 7;
id_platform_bearing = 7.5;
md_platform_bearing = 15;
od_platform_bearing = 23;
platform_screws = 6;
d_platform_screw = 3.5;
dist_platform_screw = d_platform * 3 / 8;
offset_spooler = 150;
h_platform_base = wall;
h_platform_guide = 20;
h_platform_spacer = 1;
d_platform_spacer = md_platform_bearing;

offset_guide = offset_spooler - 20;
d_spooler_guide = 14;
id_guide = 8;
th_guide = 4;
h_guide = h_platform_guide;

w_leg = 30;

module spooler_platform() {
	difference() {
		union() {
			c(d = d_platform, h = h_platform);
			translate([0, 0, h_platform / 2])
				cylinder(d1 = od_platform_bearing + 4 * wall, d2 = od_platform_bearing + 2 * wall, h = h_platform / 2 + h_platform_bearing);
		}
		c(d = od_platform_bearing, h = h_platform_bearing + 1, z = h_platform - epsilon);
		c(d = md_platform_bearing, h = h_platform + 2, z = -1);
		for (i = [0:platform_screws - 1]) {
			rotate([0, 0, 360 * i / platform_screws])
				c(d = d_platform_screw, h = h_platform + 2, z = -1, x = dist_platform_screw);
		}
	}
}

module spooler_base() {
	difference() {
		union() {
			// Base.
			c(h = h_platform_base, d = od_platform_bearing, x = 0);
			c(x = offset_spooler, h = h_platform_base, d = od_platform_bearing);
			box(0, offset_spooler, -od_platform_bearing / 2, od_platform_bearing / 2, 0, h_platform_base);
			// Leg.
			c(x = offset_spooler, y = -w_leg, h = h_platform_base, d = od_platform_bearing);
			box(offset_spooler - od_platform_bearing / 2, offset_spooler + od_platform_bearing / 2, -w_leg, 0, 0, h_platform_base);
			// Spool bearing.
			c(h = h_platform_spacer + h_platform_base / 2, d = d_platform_spacer, z = h_platform_base / 2);
			c(h = h_platform_bearing + 1 - swall, d = id_platform_bearing, z = h_platform_base + h_platform_spacer - 1);
			// Guide bearing.
			c(x = offset_spooler, h = h_platform_guide - h_platform_bearing / 2 + h_platform_base / 2, d = d_platform_spacer, z = h_platform_base / 2);
			c(x = offset_spooler, h = h_platform_bearing + h_platform_bearing / 2 + wall, d = id_platform_bearing, z = h_platform_guide - h_platform_bearing / 2);
			// Guide slot.
			difference() {
				box(offset_guide - d_spooler_guide / 2, offset_guide + d_spooler_guide / 2, -d_spooler_guide / 2, od_platform_bearing / 2 + d_spooler_guide / 2, 0, h_guide + id_guide + wall + id_guide / 2);
				box(offset_guide - d_spooler_guide / 2 - 1, offset_guide + d_spooler_guide / 2 + 1, od_platform_bearing / 2 - th_guide / 2, od_platform_bearing / 2 + th_guide / 2, h_guide - id_guide / 2, h_guide + id_guide);
			}
		}
	}
}
// }}}

//base();
//pusher();
//knifeholder();
//stand_top();
//stand_foot();
spooler_platform();
//spooler_base();
