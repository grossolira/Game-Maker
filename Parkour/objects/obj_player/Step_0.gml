//Key Checks
key_left = keyboard_check(ord("A"));
key_right = keyboard_check(ord("D"));
key_jump = keyboard_check_pressed(ord("W"));

//Horizontal Movement
wall_jumpdelay = max(wall_jumpdelay-1,0);
if (wall_jumpdelay == 0) {
	var dir = key_right - key_left;
	hspd += dir*hspd_acc;
	if(dir == 0){
		var hspd_fric_final = hspd_fric_ground;
		if (!onground) hspd_fric_final = hspd_fric_air;
		hspd = Approach(hspd,0,hspd_fric_final);
	}
	hspd = clamp(hspd,-hspd_base,hspd_base);
}

//Wall Jump

if(onwall != 0) && (!onground) && (key_jump){
	wall_jumpdelay = wall_jump_delay_max;
	hspd = -onwall * hspd_wjump;
	hspd_frac = 0;
	vspd = vspd_wjump;
	vspd_frac =	0;
}	
	

//Vertical Movement
var grav_final = grav;
var vspd_max_final = vspd_max;
if(onwall != 0) && (vspd > 0){
	grav_final = grav_wall;
	vspd_max_final = vspd_wall_max;
}

vspd += grav_final;
vspd = clamp(vspd,-vspd_max_final,vspd_max_final);

//Jump
if(jump_buffer>0){
	jump_buffer--;
	if (key_jump){
		jump_buffer=0;
		vspd = vspd_jump;
		vspd_frac =0;
	}
}
vspd = clamp(vspd,-vspd_max,vspd_max)

//Dumps
hspd += hspd_frac;
vspd += vspd_frac;
hspd_frac = frac(hspd);
vspd_frac = frac(vspd);
hspd -= hspd_frac;
vspd -= vspd_frac;

//Horizontal Collision
if place_meeting(x+hspd,y,obj_wall) {
        while !place_meeting(x+sign(hspd),y,obj_wall) {
                 x += sign(hspd);
        }
        hspd = 0;
}
x += hspd;

//Vertical Collision
if place_meeting(x,y+vspd,obj_wall) {
        while !place_meeting(x,y+sign(vspd),obj_wall) {
                 y += sign(vspd);
        }
        vspd = 0;
}
y += vspd;

//Current Status
onground = place_meeting(x,y+1,obj_wall)
onwall = place_meeting(x+1,y,obj_wall) - place_meeting(x-1,y,obj_wall);
onladder = place_meeting(x,y,obj_ladder)
if (onground) jump_buffer = 6;

//Sprite Managment
if(hspd==0 && onground=true) sprite_index=spr_player_stand

if(hspd>0 && onground=true){
	sprite_index=spr_player_run;
	image_xscale=1;
}

if(hspd<0 && onground=true){
	sprite_index= spr_player_run;
	image_xscale=-1;
}
if(onground = false){
	sprite_index=spr_player_jump;
	if(hspd>0) image_xscale=-1;
	if(hspd<0) image_xscale=1;
}
if(place_meeting(x+1,y,obj_wall)&& onground = false){
	sprite_index=spr_player_wall;
	image_xscale=-1;
}

if(place_meeting(x-1,y,obj_wall)&& onground = false){
	image_xscale=1;
	sprite_index=spr_player_wall;
}