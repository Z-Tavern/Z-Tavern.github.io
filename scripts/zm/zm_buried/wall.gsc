#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_utility;

//known issues :

    //missing collision in tunnel top HQ here : (-956.844, 587.119, 420.125)

    //need tweak on Z origin :
    //chalks spot
    //when facing jugg / HQ

    //if players are able to move in tunnels they will be blocked due to fixed size of invis models



init()
{
    //precachemodel( "collision_clip_512x512x10" );
    //precachemodel("collision_clip_256x256x10");
    //precachemodel("collision_clip_64x64x10");

    precachemodel("collision_clip_wall_256x256x10");
    precachemodel("collision_wall_128x128x10_standard");

    //level.player_out_of_playable_area_monitor = false; //debug

    flag_wait( "initial_blackscreen_passed" );

    level thread tower_defense_ffotd();
}

tower_defense_ffotd()
{
    //HQ
    //Balcony
    wall1 = spawn("script_model", (-1106.51, 408.972, 268.361));
    wall1.angles = (0, 0, 0);
    wall1 setmodel("collision_clip_wall_256x256x10");

    wall2 = spawn("script_model", (-747.024, 404.602, 268.361));
    wall2.angles = (0, 0, 0);
    wall2 setmodel("collision_clip_wall_256x256x10");

    wall3 = spawn("script_model", (-700, 441.323, 268.361));
    wall3.angles = (0, 90, 0);
    wall3 setmodel("collision_clip_wall_256x256x10");

    //"ramp" to barn
    //when facing barn

    //leftside
    wall4 = spawn("script_model", (-870.168, 271.489, 268.361));
    wall4.angles = (0, 90, 0);
    wall4 setmodel("collision_clip_wall_256x256x10");

    wall5 = spawn("script_model", (-870.168, 154.717, 268.361));
    wall5.angles = (0, 90, 0);
    wall5 setmodel("collision_clip_wall_256x256x10");

    //rightside
    wall6 = spawn("script_model", (-976.399, 262.072, 268.361));
    wall6.angles = (0, 90, 0);
    wall6 setmodel("collision_clip_wall_256x256x10");


    wall7 = spawn("script_model", (-976.399, 212.072, 268.361));
    wall7.angles = (0, 90, 0);
    wall7 setmodel("collision_clip_wall_256x256x10");



    //barn
    //when facing the breach

    //leftside
    wall8 = spawn("script_model", (-742.33, 70.2043, 239.574));
    wall8.angles = (0, 0, 0);
    wall8 setmodel("collision_clip_wall_256x256x10");


    //rightside
    wall9 = spawn("script_model", (-652.33, -49.7957, 239.574));
    wall9.angles = (0, 90, 0);
    wall9 setmodel("collision_clip_wall_256x256x10");


    //diagonal
    wall10 = spawn("script_model", (-722.33, 20.2043, 239.574));
    wall10.angles = (0, -45, 0);
    wall10 setmodel("collision_clip_wall_256x256x10");

    //small breach
    wall105 = spawn("script_model", (-720.06, -529.931, 168.513));
    wall105.angles = (0, 90, 0);
    wall105 setmodel("collision_wall_128x128x10_standard");

    //chalks spot
    //when facing jugg / HQ

    //left side
    wall11 = spawn("script_model", (-670.093, -880.45, 297.225));
    wall11.angles = (0, 0, 0);
    wall11 setmodel("collision_clip_wall_256x256x10");


    //mid
    wall12 = spawn("script_model", (-410.355, -882.344, 297.225));
    wall12.angles = (0, 0, 0);
    wall12 setmodel("collision_clip_wall_256x256x10");


    //right
    wall13 = spawn("script_model", (-370.355, -882.344, 297.225));
    wall13.angles = (0, 0, 0);
    wall13 setmodel("collision_clip_wall_256x256x10");


    //corner
    wall14 = spawn("script_model", (-234.291, -911.486, 235.5));
    wall14.angles = (0, 90, 0);
    wall14 setmodel("collision_wall_128x128x10_standard");


    //when facing saloon
    //corner
    wall15 = spawn("script_model", (-97.947, -978.41, 231.582));
    wall15.angles = (0, 0, 0);
    wall15 setmodel("collision_clip_wall_256x256x10");


    //left side
    wall16 = spawn("script_model", (12.053, -1118.41, 231.582));
    wall16.angles = (0, 90, 0);
    wall16 setmodel("collision_clip_wall_256x256x10");


    //right side
    wall17 = spawn("script_model", (8.86, -1396.89, 231.582));
    wall17.angles = (0, 90, 0);
    wall17 setmodel("collision_clip_wall_256x256x10");


    //saloon

    //when facing chalk
    //corner near guillotine
    wall18 = spawn("script_model", (317.064, -1796.8, 220.762));
    wall18.angles = (0, 0, 0);
    wall18 setmodel("collision_wall_128x128x10_standard");


    //left breach
    wall19 = spawn("script_model", (255.682, -1646.25, 261.3));
    wall19.angles = (0, 90, 0);
    wall19 setmodel("collision_clip_wall_256x256x10");

    //right breach
    wall20 = spawn("script_model", (256.218, -1257.4, 268.125));
    wall20.angles = (0, 90, 0);
    wall20 setmodel("collision_wall_128x128x10_standard");


    //when facing power
    //left side
    wall21 = spawn("script_model", (539.263, -988.52, 278.125));
    wall21.angles = (0, 0, 0);
    wall21 setmodel("collision_clip_wall_256x256x10");


    //speed cola
    //breach
    wall22 = spawn("script_model", (-87.9384, 652.075, 277.717));
    wall22.angles = (0, -45, 0);
    wall22 setmodel("collision_clip_wall_256x256x10");


    //HQ => bank/items
    //balcony
    //when facing HQ

    //right side
    wall23 = spawn("script_model", (-337.264, 196.436, 223.491));
    wall23.angles = (0, 0, 0);
    wall23 setmodel("collision_clip_wall_256x256x10");


    //left side
    wall24 = spawn("script_model", (-488.564, 196.565, 162.863));
    wall24.angles = (0, 0, 0);
    wall24 setmodel("collision_wall_128x128x10_standard");


    //corner
    wall25 = spawn("script_model", (-515.132, 154.808, 182.9));
    wall25.angles = (0, 90, 0);
    wall25 setmodel("collision_wall_128x128x10_standard");


    //bank/items
    //when facing chalks

    //balcony
    //front
    wall26 = spawn("script_model", (-322.247, -736.876, 220.708));
    wall26.angles = (0, 0, 0);
    wall26 setmodel("collision_clip_wall_256x256x10");


    //corner
    wall27 = spawn("script_model", (-470.073, -687.33, 198.703));
    wall27.angles = (0, 90, 0);
    wall27 setmodel("collision_wall_128x128x10_standard");


    //when facing barn

    //balcony
    //front
    wall28 = spawn("script_model", (-528.324, -525.308, 231.783));
    wall28.angles = (0, 90, 0);
    wall28 setmodel("collision_clip_wall_256x256x10");

    //corner
    wall29 = spawn("script_model", (-505.081, -605.588, 191.004));
    wall29.angles = (0, 0, 0);
    wall29 setmodel("collision_wall_128x128x10_standard");


    //when facing chruch
    //breach
    wall30 = spawn("script_model", (287.641, 8.05799, 174.125));
    wall30.angles = (0, 90, 0);
    wall30 setmodel("collision_wall_128x128x10_standard");


    //power
    //when facing items/bank
    //right side
    wall31 = spawn("script_model", (405.836, -507.774, 242.233));
    wall31.angles = (0, 90, 0);
    wall31 setmodel("collision_clip_wall_256x256x10");


    //left side
    wall32 = spawn("script_model", (405.836, -743.683, 242.233));
    wall32.angles = (0, 90, 0);
    wall32 setmodel("collision_clip_wall_256x256x10");


    //when facing saloon
    //front
    wall33 = spawn("script_model", (503.161, -838.863, 264.437));
    wall33.angles = (0, 0, 0);
    wall33 setmodel("collision_clip_wall_256x256x10");


    //corner left
    wall34 = spawn("script_model", (616.493, -792.166, 203.357));
    wall34.angles = (0, 90, 0);
    wall34 setmodel("collision_wall_128x128x10_standard");
    
}