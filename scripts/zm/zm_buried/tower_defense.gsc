
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;

main()
{
    level endon("game_end");
    
    // Constructor START
    level.tower_port = "30007";
    level.blessing_count = 7;
    level.is_miniboss = 0;
    level.is_midboss = 0;
    level.votes = 0;  
    level.zombie_ai_limit = 32;
    level.zombie_actor_limit = 40;
    level.extra_hp = 0;
    level.extra_panzer = 0;
    level.extra_speed = 0;
    level.is_boss_casting = 0;
    level.primaryprogressbarwidth = 400;
    level.primaryprogressbarheight = 15;
    level.primaryprogressbarfontsize = 1;
    level.player_out_of_playable_area_monitor = false;

    level.staff_player_id = -1;
    level.isStamOn = false;
    level.isJuggOn = false;
    level.isQuickOn = false;
    level.isReloadOn = false;
    level.wave_modifier = 1.5;

    level.area_completed = 0;   
    level.final_wave = 0;
    level.boss_name = "^1You^3";
    level.game_started = 0;
    level.difficulty_selected = 0;
    level.ez_difficulty_vote_count = 0;
    level.chad_difficulty_vote_count = 0;
    level.gigachad_difficulty_vote_count = 0;
    level.gamemode_difficulty = "^2Ez^7";
    level.vote_required = 8;

    level.max_cells = 500;
    level.max_cells_growth = 50;
    level.research = 0;
    level.prestige = 0;
    level.prestige_names = [];
    level.prestige_names[level.prestige_names.size] = "^9Noob^7";

    level.cells_multiplier = 0;
    level.lvl = 1;
    level.xp = 0;
    level.towerlevel = 1;
    level.guid_starting_cells = 10;
    level.starting_cells = level.guid_starting_cells;

    level.nexus_hp = 1000;
    level.nexus_fr = 1;
    level.nexus_cd = 10;
    level.nexus_shield = 1;
    level.blessing_selected = 0; // Initialize to prevent undefined error
    // Constructor END

    wait 0.1; // Ensure map assets load before initializing blessings
    init_blessing(); // Fixed: Call directly instead of threading
}

init_blessing()
{
    level endon("game_end");

    // Define blessing tiers and properties
    level.blessing_array = [];
    level.blessing_array_desc = [];
    level.blessing_costs = []; // [cash, zcoins]
    level.blessing_min_level = []; // Minimum level to unlock
    level.blessing_min_prestige = []; // Minimum prestige to unlock
    level.blessing_bonus = []; // Bonus effects (e.g., cash/xp multiplier)

    // Basic Blessings (Level 1+, Prestige 0)
    /*level.blessing_array[level.blessing_array.size] = "Extra Life";
    level.blessing_array_desc[level.blessing_array_desc.size] = "^3Grants a Dying Wish charge (+10 percent XP)";
    level.blessing_costs[level.blessing_costs.size] = [10000, 1];
    level.blessing_min_level[level.blessing_min_level.size] = 1;
    level.blessing_min_prestige[level.blessing_min_prestige.size] = 0;
    level.blessing_bonus[level.blessing_bonus.size] = "xp_10";

    level.blessing_array[level.blessing_array.size] = "Speedrunner";
    level.blessing_array_desc[level.blessing_array_desc.size] = "^3Increases movement speed (+5% cash)";
    level.blessing_costs[level.blessing_costs.size] = [15000, 2];
    level.blessing_min_level[level.blessing_min_level.size] = 1;
    level.blessing_min_prestige[level.blessing_min_prestige.size] = 0;
    level.blessing_bonus[level.blessing_bonus.size] = "cash_5";

    // Advanced Blessings (Level 5+, Prestige 0)
    level.blessing_array[level.blessing_array.size] = "Juggernaut";
    level.blessing_array_desc[level.blessing_array_desc.size] = "^3Increases HP to 250 (+10% cash)";
    level.blessing_costs[level.blessing_costs.size] = [30000, 3];
    level.blessing_min_level[level.blessing_min_level.size] = 5;
    level.blessing_min_prestige[level.blessing_min_prestige.size] = 0;
    level.blessing_bonus[level.blessing_bonus.size] = "cash_10";

    level.blessing_array[level.blessing_array.size] = "Medic";
    level.blessing_array_desc[level.blessing_array_desc.size] = "^3Faster revives (+15% XP)";
    level.blessing_costs[level.blessing_costs.size] = [20000, 2];
    level.blessing_min_level[level.blessing_min_level.size] = 5;
    level.blessing_min_prestige[level.blessing_min_prestige.size] = 0;
    level.blessing_bonus[level.blessing_bonus.size] = "xp_15";

    // Elite Blessings (Level 10+, Prestige 1)
    level.blessing_array[level.blessing_array.size] = "Business";
    level.blessing_array_desc[level.blessing_array_desc.size] = "^3Passive cell income (+20% cells)";
    level.blessing_costs[level.blessing_costs.size] = [50000, 5];
    level.blessing_min_level[level.blessing_min_level.size] = 10;
    level.blessing_min_prestige[level.blessing_min_prestige.size] = 1;
    level.blessing_bonus[level.blessing_bonus.size] = "cells_20";

    level.blessing_array[level.blessing_array.size] = "Slayer";
    level.blessing_array_desc[level.blessing_array_desc.size] = "^3+0.5% damage per kill (+15% cash)";
    level.blessing_costs[level.blessing_costs.size] = [40000, 4];
    level.blessing_min_level[level.blessing_min_level.size] = 10;
    level.blessing_min_prestige[level.blessing_min_prestige.size] = 1;
    level.blessing_bonus[level.blessing_bonus.size] = "cash_15";*/
}

on_player_connect()
{
    level endon("game_end");

    for(;;)
    {
        level waittill("connected", player);
        player thread on_player_spawned();
    }
}

on_player_spawned()
{
    self endon("disconnect");
    level endon("game_ended"); 

    if (getdvar("net_port") != level.tower_port)
        return;
    flag_wait("initial_blackscreen_passed");
    self.noslow = 0;
    self.extrahp = 0;
    self.extrams = 0;
    self.hasBlessing = 0;
    self.slide_available = 1;

    level.pers_upgrade_revive = 1;
    if (level.game_started == 0 && self.sessionstate != "spectator")
    {
        id = self getEntityNumber();
      //  self thread tp_to_HQ(id);
        self thread blessing_selector();
        self thread player_slide();
    }
    lock = 0;
    for (;;)
    {
        if (self.sessionstate == "spectator")
        {
            lock = 1;
        }
        else if (lock == 1)
        {
            id = self getEntityNumber();
       //     self thread tp_to_HQ(id);
            lock = 0;
        }
        wait 0.1;
    }
}

player_slide()
{
    self endon("disconnect");
    level endon("game_ended");

    slide_cooldown = 5;
    slide_duration = 0.5;
    slide_stamina = 100;
    stamina_regen_rate = 20;

    for (;;)
    {
        if (isdefined(self.slide_available) && isdefined(self.lvl) && self.lvl >= 5 && isdefined(self.speedrunner) && self.speedrunner == 1)
        {
            if (self SprintButtonPressed() && self StanceButtonPressed() && slide_stamina >= 50 && self isOnGround())
            {
                forward = anglesToForward(self GetPlayerAngles());
                slide_velocity = vectorScale(forward, 400);
                self SetVelocity(slide_velocity);
                self playsound("zmb_player_slide");
                if (isdefined(level._effect["fx_dust_slide"]))
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

        if (slide_stamina < 100)
        {
            slide_stamina = min(slide_stamina + (stamina_regen_rate * 0.05), 100);
        }
        wait 0.05;
    }
}

blessing_selector()
{
    self endon("disconnect");
    level endon("game_ended");

    self.blessing_hud = maps\mp\gametypes_zm\_hud_util::createFontString("big", 2);
    self.blessing_hud maps\mp\gametypes_zm\_hud_util::setPoint("CENTER", "TOP", 0, 20);
    self.blessing_hud settext("^5Select a Blessing (Melee to cycle, Use to confirm)");
    self.blessing_hud.alpha = 0.8;
    self.blessing_hud.foreground = 1;

    self.blessing_desc = maps\mp\gametypes_zm\_hud_util::createFontString("big", 1);
    self.blessing_desc maps\mp\gametypes_zm\_hud_util::setPoint("CENTER", "TOP", 0, 50);
    self.blessing_desc.alpha = 0.8;
    self.blessing_desc.foreground = 1;

    available_blessings = [];
    available_descs = [];
    available_costs = [];
    for (i = 0; i < level.blessing_array.size; i++)
    {
        if (isdefined(self.lvl) && isdefined(self.prestige) && self.lvl >= level.blessing_min_level[i] && self.prestige >= level.blessing_min_prestige[i])
        {
            available_blessings[available_blessings.size] = level.blessing_array[i];
            available_descs[available_descs.size] = level.blessing_array_desc[i] + "\n^3Cost: ^2" + level.blessing_costs[i][0] + " Cash, ^5" + level.blessing_costs[i][1] + " Z-Coins";
            available_costs[available_costs.size] = level.blessing_costs[i];
        }
    }

    if (available_blessings.size == 0)
    {
        self iprintln("^1No blessings available! Level up to unlock.");
        self.blessing_hud destroy();
        self.blessing_desc destroy();
        return;
    }

    current_index = 0;
    has_selected = 0;
    for (i = 0; i < 600; i++)
    {
        self.blessing_desc settext(available_descs[current_index]);
        if (self MeleeButtonPressed())
        {
            current_index = (current_index + 1) % available_blessings.size;
            wait 0.2;
        }
        if (self UseButtonPressed())
        {
            selected_blessing = available_blessings[current_index];
            selected_cost = available_costs[current_index];
            playerzcoin = int(getDvar("zcoins_" + self getGuid()));
            if (self.score >= selected_cost[0] && playerzcoin >= selected_cost[1])
            {
                self maps\mp\zombies\_zm_score::minus_to_player_score(selected_cost[0], 1);
                setDvar("zcoins_" + self getGuid(), playerzcoin - selected_cost[1]);
                self iprintln("^5" + selected_cost[1] + " Z-Coins used. Remaining: ^5" + getDvar("zcoins_" + self getGuid()));
                self apply_blessing(selected_blessing);
                self.blessing_array[self.blessing_array.size] = selected_blessing;
                level.blessing_selected++;
                has_selected = 1;
                self iprintln("^7Selected ^5" + selected_blessing);
                break;
            }
            else
            {
                self iprintln("^1Not enough cash or Z-Coins!");
                wait 1;
            }
        }
        wait 0.05;
    }

    if (!has_selected)
    {
        self iprintln("^1Blessing selection timed out.");
    }

    if (isdefined(self.blessing_hud)) self.blessing_hud destroy();
    if (isdefined(self.blessing_desc)) self.blessing_desc destroy();

    self playsound("zmb_quest_electricchair_spawn");
    for (i = 0; i < 5; i++)
        if (isdefined(level._effect["afterlife_teleport"]))
            playfx(level._effect["afterlife_teleport"], self.origin);
}

apply_blessing(blessing_name)
{
    self endon("disconnect");
    level endon("game_ended");

    if (blessing_name == "Extra Life")
    {
        self thread scripts\AATs_Perks::drawshader_and_shadermove("Dying_Wish", 1, 1, "custom");
        self.xp_multiplier = 1.1;
    }
    else if (blessing_name == "Speedrunner")
    {
        self.speedrunner = 1;
        self SetMoveSpeedScale(1.15 + (isdefined(self.lvl) ? self.lvl * 0.01 : 0));
        self.cash_multiplier = 1.05;
    }
    else if (blessing_name == "Juggernaut")
    {
        self.extrahp = 1;
 //       self thread permaJuggernaut();
        self.cash_multiplier = 1.1;
    }
    else if (blessing_name == "Medic")
    {
   //     self thread permaQuickRevive();
        self.perma_quick = 1;
        self.xp_multiplier = 1.15;
    }
    else if (blessing_name == "Business Tycoon")
    {
        self thread business_manager();
        self.cells_multiplier = 1.2;
    }
    else if (blessing_name == "Slayer")
    {
        self.slayer_multiplier = 1;
    //    self thread apply_slayer_effects();
        self.cash_multiplier = 1.15;
    }
}

business_manager()
{
    self endon("disconnect");
    level endon("game_ended");

    base_cell_income = 10 + (isdefined(self.lvl) ? self.lvl * 2 : 0) + (isdefined(self.prestige) ? self.prestige * 10 : 0);
    income_interval = 30;

    for (;;)
    {
        if (isdefined(self.cells) && isdefined(self.max_cells) && self.cells < self.max_cells)
        {
            self.cells = min(self.cells + base_cell_income, self.max_cells);
            self iprintln("^3Business Tycoon: ^2+" + base_cell_income + " cells^7 (Total: " + self.cells + ")");
        }
        wait income_interval;
    }
}

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
    level.nexus create_zombie_point_of_interest( 1536, 32, 10000 );
	level.nexus.attract_to_origin = 1;
	level.nexus thread create_zombie_point_of_interest_attractor_positions( 4, 45 );
	level.nexus thread maps\mp\zombies\_zm_weap_cymbal_monkey::wait_for_attractor_positions_complete();
}

all_zombies_unpath_from_nexus()
{
    // not implemented
}

all_zombies_path_to_point(point)
{
    attractor_point = spawn( "script_model", point );
	attractor_point setmodel( "tag_origin" );
	attractor_point create_zombie_point_of_interest( 1536, 32, 10000 );
	attractor_point.attract_to_origin = 1;
	attractor_point thread create_zombie_point_of_interest_attractor_positions( 4, 45 );
	attractor_point thread maps\mp\zombies\_zm_weap_cymbal_monkey::wait_for_attractor_positions_complete();
}

all_zombies_unpath_from_point(point)
{
    // not implemented
}