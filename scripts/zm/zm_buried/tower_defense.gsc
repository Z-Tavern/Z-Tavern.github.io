#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;

// Initialize global game settings
main()
{
    level endon("game_end");
    
    precacheShader("zombies_rank_3");
    precacheShader("zombies_rank_5");
    level.blessing_count = 6;
    level.zombie_ai_limit = 32;
    level.zombie_actor_limit = 40;
    level.wave_modifier = 1.5;
    level.max_cells = 500;
    level.starting_cells = 10;
    level.lvl = 1;
    level.towerlevel = 1;
    level.nexus_hp = 1000;
    level.nexus_fr = 1;
    level.nexus_cd = 10;
    level.nexus_shield = 1;
    level.blessing_selected = 0;
    level.gamemode_difficulty = "^2Ez^7";

    wait 0.1;
    init_blessing();

    level thread on_player_connect();
}

// Define blessings with costs set to 50000 cash
init_blessing()
{
    level endon("game_end");

    level.blessing_array = [];
    level.blessing_array_desc = [];
    level.blessing_costs = [];
    level.blessing_min_level = [];
    level.blessing_min_prestige = [];
    level.blessing_bonus = [];

    // Extra Life: Level 1, Prestige 0
    level.blessing_array[0] = "Extra Life";
    level.blessing_array_desc[0] = "^3Grants 1x Dying Wish\n         (+10% XP)";
    level.blessing_costs[0] = 50000;
    level.blessing_min_level[0] = 1;
    level.blessing_min_prestige[0] = 0;
    level.blessing_bonus[0] = "xp_10";

    // Speedrunner: Level 1, Prestige 0
    level.blessing_array[1] = "Speedrunner";
    level.blessing_array_desc[1] = "^3Increases movement speed\n           (+5% cash)";
    level.blessing_costs[1] = 50000;
    level.blessing_min_level[1] = 1;
    level.blessing_min_prestige[1] = 0;
    level.blessing_bonus[1] = "cash_5";

    // Juggernaut: Level 5, Prestige 0
    level.blessing_array[2] = "Juggernaut";
    level.blessing_array_desc[2] = "^3Increases HP to 250\n             (+10% cash)";
    level.blessing_costs[2] = 50000;
    level.blessing_min_level[2] = 5;
    level.blessing_min_prestige[2] = 0;
    level.blessing_bonus[2] = "cash_10";

    // Medic: Level 5, Prestige 0
    level.blessing_array[3] = "Medic";
    level.blessing_array_desc[3] = "^3Faster revives\n               (+15% XP)";
    level.blessing_costs[3] = 50000;
    level.blessing_min_level[3] = 5;
    level.blessing_min_prestige[3] = 0;
    level.blessing_bonus[3] = "xp_15";

    // Business: Level 10, Prestige 1
    level.blessing_array[4] = "Business";
    level.blessing_array_desc[4] = "^3Passive cell income\n             (+20% cells)";
    level.blessing_costs[4] = 50000;
    level.blessing_min_level[4] = 10;
    level.blessing_min_prestige[4] = 1;
    level.blessing_bonus[4] = "cells_20";

    // Slayer: Level 10, Prestige 1
    level.blessing_array[5] = "Slayer";
    level.blessing_array_desc[5] = "^3+0.5% damage per kill\n           (+15% cash)";
    level.blessing_costs[5] = 50000;
    level.blessing_min_level[5] = 10;
    level.blessing_min_prestige[5] = 1;
    level.blessing_bonus[5] = "cash_15";
}

// Handle player connection
on_player_connect()
{
    level endon("game_end");
    for(;;)
    {
        level waittill("connected", player);
        player thread on_player_spawned();
        player thread money_watcher();
    }
}

// Initialize player on spawn and trigger blessing selector
on_player_spawned()
{
    self endon("disconnect");
    level endon("game_ended");

    flag_wait("initial_blackscreen_passed");

    self.lvl = 1;
    self.prestige = 0;
    self.noslow = 0;
    self.extrahp = 0;
    self.extrams = 0;
    self.hasBlessing = 0;
    self.slide_available = 1;
    self.score = 100000; // Enough cash for testing
    self.cells = level.starting_cells;
    self.max_cells = level.max_cells;
    self.blessing_array = [];

    self thread blessing_selector();
    self thread player_slide();
}

// Monitor player's cash and play cha-ching sound on increase
money_watcher()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        self.last_score = self.score;
        wait 0.1;
        if(isdefined(self.score) && isdefined(self.last_score) && self.score < self.last_score)
        {
            self playsound("zmb_cha_ching"); 
        }
    }
}

// Handle player slide ability
player_slide()
{
    self endon("disconnect");
    level endon("game_ended");

    slide_cooldown = 5;
    slide_duration = 0.5;
    slide_stamina = 100;
    stamina_regen_rate = 20;

    for(;;)
    {
        if(isdefined(self.slide_available) && self.lvl >= 5 && isdefined(self.speedrunner) && self.speedrunner == 1)
        {
            if(self SprintButtonPressed() && self StanceButtonPressed() && slide_stamina >= 50 && self isOnGround())
            {
                forward = anglesToForward(self GetPlayerAngles());
                slide_velocity = vectorScale(forward, 400);
                self SetVelocity(slide_velocity);
                self playsound("zmb_player_slide");
                if(isdefined(level._effect["fx_dust_slide"]))
                    playfx(level._effect["fx_dust_slide"], self.origin);

                slide_stamina -= 50;
                self iprintln("^3Slide Activated!^7 Stamina: " + slide_stamina);
                wait slide_duration;
                self SetVelocity((0, 0, 0));
                self.slide_available = 0;
                wait slide_cooldown;
                self.slide_available = 1;
                self iprintln("^3Slide Ready!^7");
            }
        }
        if(slide_stamina < 100)
            slide_stamina = min(slide_stamina + (stamina_regen_rate * 0.05), 100);
        wait 0.05;
    }
}
// Display and handle blessing selection with two-option UI
blessing_selector()
{
    self endon("disconnect");
    level endon("game_ended");

    if(self.sessionstate != "playing")
    {
        self iprintln("^1Cannot select blessing in spectator mode!");
        return;
    }

    self iprintln("^3Blessing selector started..."); // Debug message

    // Filter available blessings based on level, prestige, and existing blessings
    blessing_array_tmp = [];
    blessing_array_tmp_desc = [];
    blessing_array_tmp_costs = [];

    foreach(i, blessing in level.blessing_array)
    {
        if(isdefined(self.lvl) && isdefined(self.prestige) && self.lvl >= level.blessing_min_level[i] && self.prestige >= level.blessing_min_prestige[i])
        {
            have_blessing = 0;
            foreach(player_blessing in self.blessing_array)
            {
                if(player_blessing == blessing)
                {
                    have_blessing = 1;
                    break;
                }
            }
            if(!have_blessing)
            {
                blessing_array_tmp[blessing_array_tmp.size] = blessing;
                blessing_array_tmp_desc[blessing_array_tmp_desc.size] = level.blessing_array_desc[i];
                blessing_array_tmp_costs[blessing_array_tmp_costs.size] = level.blessing_costs[i];
            }
        }
    }

    if(blessing_array_tmp.size < 2)
    {
        self iprintln("^1Not enough blessings available! Level up to unlock.");
        return;
    }

    // Select two random blessings
    rand = randomintrange(0, blessing_array_tmp.size);
    blessing_left = blessing_array_tmp[rand];
    blessing_left_desc = blessing_array_tmp_desc[rand];
    blessing_left_cost = blessing_array_tmp_costs[rand];
    selected = rand;
    while(true)
    {
        rand = randomintrange(0, blessing_array_tmp.size);
        if(rand != selected)
            break;
        wait 0.05;
    }
    blessing_right = blessing_array_tmp[rand];
    blessing_right_desc = blessing_array_tmp_desc[rand];
    blessing_right_cost = blessing_array_tmp_costs[rand];

    self iprintln("^3Left: " + blessing_left + " | Right: " + blessing_right); // Debug message

    // Create HUD elements with shaders
    shader = "zombies_rank_5";
    self.notifyiconb = self drawshader(shader, 70, 68, 140, 140, (1, 0, 0), 1);
    self.notifyicon = self drawshader(shader, 70, 70, 128, 128, (0, 0, 0), 1);
    self.notifyicon2b = self drawshader(shader, -70, 68, 140, 140, (1, 0, 0), 1);
    self.notifyicon2 = self drawshader(shader, -70, 70, 128, 128, (0, 0, 0), 1);
    shader = "zombies_rank_3";
    self.notifyiconA = self drawshader(shader, 0, 4, 231, 66, (0, 0, 1), 1);
    self.notifyicon2a = self drawshader(shader, 0, 4, 210, 60, (0, 0, 0), 1); 
    self.zombieChoiceA = maps\mp\gametypes_zm\_hud_util::createFontString("objective", 1.8);
    self.zombieChoiceA maps\mp\gametypes_zm\_hud_util::setPoint("CENTER", "TOP", 0, 25);
    self.zombieChoiceA settext("^5Select a Blessing");
    self.zombieChoiceA.alpha = 1;
    self.zombieChoiceA.foreground = 1;
    self.zombieChoiceLeft = maps\mp\gametypes_zm\_hud_util::createFontString("big", 2);
    self.zombieChoiceLeft maps\mp\gametypes_zm\_hud_util::setPoint("CENTER", "TOP", -70, 100);
    self.zombieChoiceLeft settext("^3[^5" + blessing_left + "^3]^7");
    self.zombieChoiceLeft.alpha = 0.8;
    self.zombieChoiceLeft.foreground = 1;
    self.zombieChoiceRight = maps\mp\gametypes_zm\_hud_util::createFontString("big", 2);
    self.zombieChoiceRight maps\mp\gametypes_zm\_hud_util::setPoint("CENTER", "TOP", 70, 100);
    self.zombieChoiceRight settext("^5" + blessing_right + "^7");
    self.zombieChoiceRight.alpha = 0.8;
    self.zombieChoiceRight.foreground = 1;
    self.zombieChoiceLeftDesc = maps\mp\gametypes_zm\_hud_util::createFontString("objective", 1.2);
    self.zombieChoiceLeftDesc maps\mp\gametypes_zm\_hud_util::setPoint("CENTER", "TOP", -70, 120);
    self.zombieChoiceLeftDesc settext(blessing_left_desc);
    self.zombieChoiceLeftDesc.alpha = 0.8;
    self.zombieChoiceRightDesc = maps\mp\gametypes_zm\_hud_util::createFontString("objective", 1.2);
    self.zombieChoiceRightDesc maps\mp\gametypes_zm\_hud_util::setPoint("CENTER", "TOP", 70, 120);
    self.zombieChoiceRightDesc settext(blessing_right_desc);
    self.zombieChoiceRightDesc.alpha = 0.8;

    // Selection loop
    selector = "left";
    has_selected = 0;
    for(i = 0; i < 600; i++)
    {
        if(self MeleeButtonPressed())
        {
            selector = (selector == "left") ? "right" : "left";
            self.zombieChoiceLeft settext(selector == "left" ? "^3[^5" + blessing_left + "^3]^7" : "^5" + blessing_left + "^7");
            self.zombieChoiceRight settext(selector == "right" ? "^3[^5" + blessing_right + "^3]^7" : "^5" + blessing_right + "^7");
            wait 0.2;
        }
        if(self UseButtonPressed())
        {
            selected_blessing = (selector == "left") ? blessing_left : blessing_right;
            selected_cost = (selector == "left") ? blessing_left_cost : blessing_right_cost;
            if(self.score >= selected_cost)
            {
                self maps\mp\zombies\_zm_score::minus_to_player_score(selected_cost, 1);
                self apply_blessing(selected_blessing);
                self.blessing_array[self.blessing_array.size] = selected_blessing;
                level.blessing_selected++;
                has_selected = 1;
                self iprintln(self.name + " ^7selected ^5" + selected_blessing);
                break;
            }
            else
            {
                self iprintln("^1Not enough cash!");
                wait 1;
            }
        }
        wait 0.05;
    }

    // Auto-select if timed out
    if(!has_selected)
    {
        selected_blessing = (selector == "left") ? blessing_left : blessing_right;
        selected_cost = (selector == "left") ? blessing_left_cost : blessing_right_cost;
        if(self.score >= selected_cost)
        {
            self maps\mp\zombies\_zm_score::minus_to_player_score(selected_cost, 1);
            self apply_blessing(selected_blessing);
            self.blessing_array[self.blessing_array.size] = selected_blessing;
            level.blessing_selected++;
            self iprintln(self.name + " ^7selected ^5" + selected_blessing);
        }
        else
        {
            self iprintln("^1Blessing selection timed out. Not enough cash!");
        }
    }

    // Apply visual and audio effects
    for(i = 0; i < 10; i++)
        if(isdefined(level._effect["afterlife_teleport"]))
            playfx(level._effect["afterlife_teleport"], self.origin);
    self playsound("zmb_quest_electricchair_spawn");

    // Clean up HUD
    if(isdefined(self.notifyiconb)) self.notifyiconb destroy();
    if(isdefined(self.notifyicon)) self.notifyicon destroy();
    if(isdefined(self.notifyicon2b)) self.notifyicon2b destroy();
    if(isdefined(self.notifyicon2)) self.notifyicon2 destroy();
    if(isdefined(self.notifyiconA)) self.notifyiconA destroy();
    if(isdefined(self.notifyicon2a)) self.notifyicon2a destroy();
    if(isdefined(self.zombieChoiceA)) self.zombieChoiceA destroy();
    if(isdefined(self.zombieChoiceLeft)) self.zombieChoiceLeft destroy();
    if(isdefined(self.zombieChoiceRight)) self.zombieChoiceRight destroy();
    if(isdefined(self.zombieChoiceLeftDesc)) self.zombieChoiceLeftDesc destroy();
    if(isdefined(self.zombieChoiceRightDesc)) self.zombieChoiceRightDesc destroy();
}
// Apply selected blessing effects
apply_blessing(blessing_name)
{
    self endon("disconnect");
    level endon("game_ended");

    if(blessing_name == "Extra Life")
    {
        self thread scripts\AATs_Perks::drawshader_and_shadermove("Dying_Wish", 1, 1, "custom");
        self.xp_multiplier = 1.1;
    }
    else if(blessing_name == "Speedrunner")
    {
        self.speedrunner = 1;
        self SetMoveSpeedScale(1.15 + (isdefined(self.lvl) ? self.lvl * 0.01 : 0));
        self.cash_multiplier = 1.05;
    }
    else if(blessing_name == "Juggernaut")
    {
        self.extrahp = 1;
        self.cash_multiplier = 1.1;
    }
    else if(blessing_name == "Medic")
    {
        self.perma_quick = 1;
        self.xp_multiplier = 1.15;
    }
    else if(blessing_name == "Business")
    {
        self thread business_manager();
        self.cells_multiplier = 1.2;
    }
    else if(blessing_name == "Slayer")
    {
        self.slayer_multiplier = 1;
        self.cash_multiplier = 1.15;
    }
}

// Handle passive cell income for Business blessing
business_manager()
{
    self endon("disconnect");
    level endon("game_ended");

    base_cell_income = 10 + (isdefined(self.lvl) ? self.lvl * 2 : 0) + (isdefined(self.prestige) ? self.prestige * 10 : 0);
    income_interval = 30;

    for(;;)
    {
        if(isdefined(self.cells) && isdefined(self.max_cells) && self.cells < self.max_cells)
        {
            self.cells = min(self.cells + base_cell_income, self.max_cells);
            self iprintln("^3Business: ^2+" + base_cell_income + " cells^7 (Total: " + self.cells + ")");
        }
        wait income_interval;
    }
}

// Award cash and XP for kills
give_rewards(kill)
{
    base_cash = 100;
    base_xp = 50;
    cash = base_cash * (isdefined(self.cash_multiplier) ? self.cash_multiplier : 1);
    xp = base_xp * (isdefined(self.xp_multiplier) ? self.xp_multiplier : 1);
    self.score += cash;
    self.xp += xp;
}

spawn_nexus()
{
    level.nexus = spawn("script_model", (0, 0, 0));
    level.nexus setmodel("viewmodel_zombie_cymbal_monkey");
}

all_zombies_path_to_nexus()
{
    level.nexus create_zombie_point_of_interest(1536, 32, 10000);
    level.nexus.attract_to_origin = 1;
    level.nexus thread create_zombie_point_of_interest_attractor_positions(4, 45);
    level.nexus thread maps\mp\zombies\_zm_weap_cymbal_monkey::wait_for_attractor_positions_complete();
}

all_zombies_unpath_from_nexus()
{
    // not implemented
}

all_zombies_path_to_point(point)
{
    attractor_point = spawn("script_model", point);
    attractor_point setmodel("tag_origin");
    attractor_point create_zombie_point_of_interest(1536, 32, 10000);
    attractor_point.attract_to_origin = 1;
    attractor_point thread create_zombie_point_of_interest_attractor_positions(4, 45);
    attractor_point thread maps\mp\zombies\_zm_weap_cymbal_monkey::wait_for_attractor_positions_complete();
}

all_zombies_unpath_from_point(point)
{
    // not implemented
}