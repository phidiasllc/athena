/************************************************************************************

athena_renderer.scad - easily select and render parts and plates for manufacture of Athena platform
Copyright 2015 Jerry Anzalone
Author: Jerry Anzalone <info@phidiasllc.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

************************************************************************************/

// include the modules required for rendering
include <athena.scad>

render_part(part_to_render = 14);
//render_plate(plate_to_render = 5);

// renders individual parts
module render_part(part_to_render) {
	// end that holds motor - 3 required
	if (part_to_render == 1) athena_end_idler(z_offset_guides = 8);

	// end that holds idler bearings and end limit switches - 3 required
	if (part_to_render == 2) athena_end_motor(z_offset_guides = 8);

	// clamps the guide rods firmly to motor/idler ends - 12 required
	if (part_to_render == 3) bar_clamp();

	// permits tensioning of belts and mount point to carriage - 3 sets required
	if (part_to_render == 4) athena_belt_terminators();

	// carriages ride on the guide rods 3 required for basic platform
	if (part_to_render == 5) athena_basic_carriage();

	// carriages ride on the guide rods 3 required for Parthenos
	if (part_to_render == 6) athena_convertible_carriage();

	// the roller switch mount - 3 required for Parthenos
	if (part_to_render == 7) central_limit_switch();

	// if the platform uses a BBB and melzi, one of these is required
	if (part_to_render == 8) bbb_melzi_mount();

	// mounts to vertical board, holds magnetic tools not in use and hides wires - convenience, not required for Parthenos
	if (part_to_render == 9) athena_tool_holder();

	// mounts to vertical board to which extruder drive is mounted and holds spool - convenience, not required
	if (part_to_render == 10) athena_spool_holder(render_mount = true, render_holder = true
	, mount_wood = true);

	// mounts to vertical board, holds tools and hides wires - convenience, not required
	if (part_to_render == 11) athena_hand_tool_holder(wood_mount = true, sonicare_magnet = false);

	// Mounting plate fits in slotted motor-end linking board, one required; print with support
	if (part_to_render == 12) connector_plate();

	// for holding glass to base plate, three required
	if (part_to_render == 13) glass_holddown();

	// end effector with built-in mount for hot end, one required for basic platform
	if (part_to_render == 14) hotend_effector(quickrelease = true, dalekify = false);

	// a place to play
	if (part_to_render == 99) sandbox();
}

// renders production plates
module render_plate(plate_to_render) {
	// approximate build circle to assure placement and fit on build platform
//	color([1, 0, 0])
//		circle(r = 125);

	if (plate_to_render == 1)
		for (i = [-1:1])
			translate([0, i * (w_clamp + 2) + 20, 0])
				athena_end_idler(z_offset_guides = 8);

	if (plate_to_render == 2) {
		translate([0, -w_clamp / 2 - 6, 0])
			athena_end_motor();

		translate([0, w_clamp / 2 + 6, 0])
			rotate([0, 0, 180])
				athena_end_motor();

		translate([l_clamp - 6, 0, 0])
			rotate([0, 0, 90])
				athena_end_motor();
	}

	// hot end effector with thumbscrew
	if (plate_to_render == 3) {
		translate([0, 0, 0.5])
			thumbscrew_quickrelease();

		hotend_effector(quickrelease = true, dalekify = false);
	}

	// simple carriages
	if (plate_to_render == 4) {
		for (i = [0:2])
			rotate([0, 0, i * 120])
				translate([-15, r_effector + 22, h_carriage / 2])
					athena_basic_carriage();
	}

	// belt terminators and bar clamps
	if (plate_to_render == 5) {
/*		for (i = [0:2])
			translate([i * 22, 0, 0]) {
				translate([0, 21, 0])
					mirror([0, 1, 0])
						athena_belt_terminators();

				athena_belt_terminators();

				translate([11, -33, 0])
					mirror([0, 1, 0])
						mirror([1, 0, 0])
							athena_belt_terminators();
			}
*/
		translate([-h_bar_clamp / 2 - 6, -w_clamp - 1, t_bar_clamp / 2])
			for (i = [0:2])
				for (j = [-4:3])
					translate([j * -(h_bar_clamp + 1), i * (w_clamp + 1), 0])
						bar_clamp();

/*		translate([3, -50, 6])
			mirror([0, 0,1])
				glass_holddown();

		translate([3, 48, 6])
			mirror([0, 0,1])
				glass_holddown();

		translate([15, 40, 6])
			mirror([0, 0,1])
				glass_holddown();
*/	}

	if (plate_to_render == 6) {
		// Parthenos carriages
		translate([22, -2, 0])
			rotate([0, 0, 180])
				athena_convertible_carriage();

		athena_convertible_carriage();

		translate([14, -39, 0])
			rotate([0, 0, 180])
				athena_convertible_carriage();
	}

	if (plate_to_render == 7) {
		translate([22, -2, 0])
			rotate([0, 0, 180])
				athena_basic_carriage();

		athena_basic_carriage();

		translate([14, -34, 0])
			rotate([0, 0, 180])
				athena_basic_carriage();
	}
}

module sandbox() {
//	count = 6;

//	for (i = [0:count - 1]) {
//		rotate([0, 0, i * 360 / count])
//			translate([22, 0, 0])
//				rotate([0, 0, 30])
					thumbscrew_quickrelease();
//	}
}

module bbb_melzi_mount() {
	// width is short dimension, length is long dimension
	cc_w_melzi_mounts = 45.75 - 3.75; // c-c of melzi mounts on width axis
	cc_l_melzi_mounts = 200; // c-c of melzi mounts on length axis
	offset_melzi_mounts = 3.75 / 2 + 2; // distance from edge of board
	w_melzi = 50;
	w_bbb = 54.5;
	l_bbb = 86.3;
	bbb_melzi_offset = -20;
	h_standoff = 9;

	union() {
		// melzi
		translate([bbb_melzi_offset, -w_melzi, 0]) {
			difference() {
				union() {
					for (i = [-1, 1])
							translate([offset_melzi_mounts, i * cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
								cylinder(r1 = d_M3_screw / 2 + 3, r2 = d_M3_screw / 2 + 1, h = h_standoff, center = true);

					translate([0, 0, 1 - h_standoff / 2]) {
						hull(){
							translate([offset_melzi_mounts, -cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

							translate([-bbb_melzi_offset + bbb_hole1[0], w_melzi + bbb_hole1[1], 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
						}

						hull(){
							translate([offset_melzi_mounts, -cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

							translate([offset_melzi_mounts, cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
						}

						hull(){
							translate([offset_melzi_mounts, cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

							translate([-bbb_melzi_offset + bbb_hole0[0], w_melzi + bbb_hole0[1], 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
						}

						hull(){
							translate([offset_melzi_mounts, -cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

							translate([-bbb_melzi_offset + bbb_hole0[0], w_melzi + bbb_hole0[1], 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
						}

						hull(){
							translate([-bbb_melzi_offset + bbb_hole0[0], w_melzi + bbb_hole0[1], 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

							translate([-bbb_melzi_offset + bbb_hole1[0], w_melzi + bbb_hole1[1], 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
						}

						hull(){
							translate([-bbb_melzi_offset + bbb_hole1[0], w_melzi + bbb_hole1[1], 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

							translate([-bbb_melzi_offset + bbb_hole2[0], w_melzi + bbb_hole2[1], 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
						}

						hull(){
							translate([-bbb_melzi_offset + bbb_hole0[0], w_melzi + bbb_hole0[1], 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

							translate([-bbb_melzi_offset + bbb_hole2[0], w_melzi + bbb_hole2[1], 0])
								cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
						}

						translate([4, w_melzi / 2, 0])
							hull()
								for (i = [0, -10])
									translate([i, 0, 0])
										cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);


						translate([-bbb_melzi_offset + bbb_hole1[0], w_melzi + bbb_hole2[1] - (bbb_hole2[1] - bbb_hole1[1]) / 2, 0])
							hull()
								for (i = [0, 10])
									translate([i, 0, 0])
										cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

					}
				}

				for (i = [-1, 1])
					translate([offset_melzi_mounts, i * cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
						cylinder(r = d_M3_screw / 2 - 0.25, h = h_standoff + 1, center = true);

				translate([-6, w_melzi / 2, 0])
					cylinder(r = d_M3_screw / 2, h = h_standoff + 1, center = true);

				translate([-bbb_melzi_offset + bbb_hole1[0] + 10, w_melzi + bbb_hole2[1] - (bbb_hole2[1] - bbb_hole1[1]) / 2, 0])
					cylinder(r = d_M3_screw / 2, h = h_standoff + 1, center = true);
			}
		}

		// bbb
		difference() {
			for (i = [0:2])
				translate([bbb_holes[i][0], bbb_holes[i][1], 0])
					cylinder(r1 = d_M3_screw / 2 + 3, r2 = d_M3_screw / 2 + 1, h = h_standoff, center = true);

			for (i = [0:3])
				translate([bbb_holes[i][0], bbb_holes[i][1], 0])
					cylinder(r = d_M3_screw / 2 - 0.25, h = h_standoff + 1, center = true);
		}
	}

	// for the opposite end of the melzi:
	translate([w_melzi / 2, 20, 0])
	rotate([0, 0, 90])
		difference() {
			union() {
				for (i = [-1, 1])
					translate([offset_melzi_mounts, i * cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
						cylinder(r1 = d_M3_screw / 2 + 3, r2 = d_M3_screw / 2 + 1, h = h_standoff, center = true);

				translate([0, 0, 1 - h_standoff / 2]) {
					hull(){
						translate([offset_melzi_mounts, -cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
							cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

						translate([offset_melzi_mounts, cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
							cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
					}

					translate([4, w_melzi / 2, 0])
						hull()
							for (i = [0, -10])
								translate([i, 0, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
				}
			}

			for (i = [-1, 1])
				translate([offset_melzi_mounts, i * cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
					cylinder(r = d_M3_screw / 2 - 0.25, h = h_standoff + 1, center = true);

			translate([-6, w_melzi / 2, 0])
				cylinder(r = d_M3_screw / 2, h = h_standoff + 1, center = true);
		}
}

module connector_plate() {
	l_bbl_opening = 15; // length of barrel connector panel opening
	w_bbl_opening = 11.5; // width of barrel connector panel opening
	t_bbl_mount = 2; // thickness of the barrel connector mounting plate
	t_bbl_panel = 1.75; // thickness of the barrel connector panel (groove in barrel jack)
	l_bbl_body = l_bbl_opening + 2; // length of connector body
	w_bbl_body = w_bbl_opening + 2; // width of connector body
	h_bbl_case = 18; // height of the barrel connector case

	h_plate = 12 + t_bbl_panel; // tall enough for hooking into 12mm plywood

	l_rj45_housing = 36.5;
	w_rj45_housing = 22;
	w_rj45_jack = 14;
	l_rj45_jack = 16.5;
	top_offset_rj45_jack = 6;
	cc_rj45_mounts = 27.5;

	l_usb_housing = 38;
	w_usb_housing = 13;
	cc_usb_mounts = 28;
	l_usb_opening = 17;
	w_usb_opening = 9;
	r_plate_corners = 10;
	l_plate = 102; //l_rj45_housing + l_usb_housing + w_bbl_opening + 12;
	w_plate = 24; //w_rj45_housing + 2;

	difference() {
		union() {
			hull()
				for (i = [-1, 1])
					for (j = [-1, 1])
						translate([i * (l_plate / 2 - r_plate_corners), j * (w_plate / 2 - r_plate_corners), 0])
							cylinder(r = r_plate_corners, h = h_plate);

			hull()
				for (i = [-1, 1])
					for (j = [-1, 1])
						translate([i * (l_plate / 2 - r_plate_corners + 5), j * (w_plate / 2 - r_plate_corners + 5), 0])
							cylinder(r = r_plate_corners, h = t_bbl_panel);

			translate([(l_plate - l_usb_housing) / 2 - 5 - l_usb_housing / 2, 0, h_plate])
				hull()
					for (i = [-1, 1])
						translate([0, i * (w_plate / 2 - 1), 0])
							cylinder(r1 = 4, r2 = 0, h = 3);

			translate([0, 0, h_plate])
				hull()
					for (i = [-1, 1])
						translate([i * (l_plate / 2 - 1), 0, 0])
							cylinder(r1 = 4, r2 = 0, h = 3);

		}

		hull()
			for (i = [-1, 1])
				for (j = [-1, 1])
					translate([i * (l_plate / 2 - r_plate_corners - 1), j * (w_plate / 2 - r_plate_corners - 1), t_bbl_panel])
						cylinder(r = r_plate_corners - 1, h = h_plate + 5);

		// barrel connector
		translate([-(l_plate - w_bbl_opening) / 2 + 1, w_plate / 2 - l_bbl_opening - 1, 0]) {
			translate([0, 0, -1])
				cube([w_bbl_opening, l_bbl_opening + 10, h_bbl_case + 1]);

			translate([-3, -3, t_bbl_panel])
				cube([w_bbl_opening + 6, l_bbl_opening + 16, h_plate]);
		}

		// rj45 jack
		translate([-12, 0, 0]) {
			translate([-l_rj45_jack / 2, top_offset_rj45_jack - w_rj45_housing / 2, -1]) {
				cube([l_rj45_jack, w_rj45_jack, h_plate + 2]);

				translate([-(w_rj45_housing - l_rj45_jack) / 2, -w_plate / 2, t_bbl_panel + 1])
					cube([w_rj45_housing, 2 * w_plate, h_plate]);
			}

			for (i = [-1, 1])
				translate([i * cc_rj45_mounts / 2, 0, -1])
					cylinder(r = d_M3_screw / 2, h = h_plate + 2);
		}

		// usb jack
		translate([(l_plate - l_usb_housing) / 2 - 4, 0, 0]) {
			for (i = [-1, 1])
				translate([i * cc_usb_mounts / 2, 0, -1])
					cylinder(r = d_M3_screw / 2, h = h_plate + 2);

			translate([-l_usb_opening / 2, -w_usb_opening / 2, -1])
				cube([l_usb_opening, w_usb_opening, h_plate + 2]);
		}
	}
}
