module c(d = 0, h = 1, x = 0, y = 0, z = 0, rx = 0, ry = 0, fn = $fn, r = 0) {
	D = d ? d : 2 * r;
	translate([x, y, z]) {
		rotate([rx, ry, 0]) {
			rotate([0, 0, fn < 0 ? (360 / -fn) / 2 : 0])
				cylinder(d = D, h = h, $fn = fn > 0 ? fn : -fn);
		}
	}
}

module box(x0, x1, y0, y1, z0, z1) {
	translate([min(x0, x1), min(y0, y1), min(z0, z1)])
		cube([abs(x1 - x0), abs(y1 - y0), abs(z1 - z0)]);
}

function make_trap(d) = d * sqrt(3) / 1.5;
