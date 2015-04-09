//
//  ViewController.swift
//  MineEscape
//
//  Created by Alex Harrison on 3/20/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//®
import UIKit
import AVFoundation
var super_view = UIView();
var game:GameMap = GameMap();
var DIM:Int = 4;
var level_menu:LevelMenu = LevelMenu();
var current_level = 0;
var levels_completed = Array<Int>(); // will store this in core data in future
var main_menu:Main_menu = Main_menu();
var in_main_menu = true;
var in_level_menu = false;
var in_game = false;
var in_how_to = false;
var in_about = false;
var in_volume = false;
var how_to_screen = HowToScreen();
var about_window:aboutWindow = aboutWindow();
var settings_window:settingsWondow = settingsWondow();
//var temporary_menu = temp_menu();

class ViewController: UIViewController {

    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func pressed_loc(sender:Mine_cell!)
    {
        game.mark_location(sender.loc_id);
    }
    
    func reset()
    {
        play_sound(SOUND.DEFAULT);
        viewDidLoad();
    }
    
    func load_level(sender:level_button!)
    {
        current_level = sender.level;
        game.bottom_text.text = "";
        level_menu.removeMenu();
        in_game = true;
        in_level_menu = false;
        in_how_to = false;
        in_main_menu = false;
        in_about = false;
        in_volume = false;
        play_sound(SOUND.DEFAULT);
        viewDidLoad();
    }
    
    func enter_level_menu()
    {
        play_sound(SOUND.DEFAULT);
        remove_subviews();
        level_menu.createMenu();
        for(var i = 0; i < level_menu.level_buttons.count; ++i)
        {
            level_menu.level_buttons[i].addTarget(self, action: "load_level:", forControlEvents: UIControlEvents.TouchUpInside);
            level_menu.level_buttons[i].setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted);
            level_menu.level_buttons[i].setTitleShadowColor(UIColor.whiteColor(), forState: UIControlState.Highlighted);
            level_menu.level_buttons[i].tag = i;
            level_menu.level_buttons[i].level = i;
        }
        
    }
    
    func set_dimension(sender:UIButton!)
    {
        for(var i = 0; i < 3; ++i)
        {
            game.size_buttons[i].setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        }
        sender.setTitleColor(LIGHT_BLUE, forState: UIControlState.Normal);
        DIM = sender.tag;
    }
    
    func exited_startup(sender:UIButton!)
    {
        play_sound(SOUND.DEFAULT);
        if(sender.tag == 0)         // entered level menu
        {
            in_level_menu = true;
            in_main_menu = false;
            in_game = false;
            in_how_to = false;
            in_about = false;
            in_volume = false;
            remove_subviews();
            viewDidLoad();
        }
        else if(sender.tag == 1)         // entered about menu
        {
            in_about = true;
            in_level_menu = false;
            in_main_menu = false;
            in_game = false;
            in_how_to = false;
            in_volume = false;
            remove_subviews();
            about_window.bring_up();
            viewDidLoad();
        }
        else if(sender.tag == 2)         // entered how to menu
        {
            in_how_to = true;
            in_main_menu = false;
            in_game = false;
            in_main_menu = false;
            in_level_menu = false;
            in_volume = false;
            remove_subviews();
            how_to_screen.bring_up();
            viewDidLoad();
        }
        else if(sender.tag == 3)    // entered settings window
        {
            in_volume = true;
            in_how_to = false;
            in_main_menu = false;
            in_game = false;
            in_main_menu = false;
            in_level_menu = false;
            remove_subviews();
            settings_window = settingsWondow();
            settings_window.bring_up();
            viewDidLoad();
        }
    }
    
    func entered_startup(sender:UIButton!)
    {
        play_sound(SOUND.DEFAULT);
        in_main_menu = true;
        in_game = false;
        in_volume = false;
        in_about = false;
        in_level_menu = false;
        in_how_to = false;
        
        about_window.pull_down();
        how_to_screen.pull_down();
        settings_window.pull_down();
        main_menu.remove_main_menu();
        remove_subviews();
        viewDidLoad();
    }
    
    func adjust_volume(sender:UISlider!)
    {
    
        // update volume
        VOLUME_LEVEL = sender.value;
        
        // change volume label
        settings_window.volume_label.text = String(Int(100.0 * VOLUME_LEVEL));
    }
    
    func demonstrate_volume(UISlider!)
    {
        play_sound(SOUND.DEFAULT);
    }
    
    
    func next_level(sender:UIButton!)
    {
        play_sound(SOUND.DEFAULT);
        if(sender.tag == 0) // clicked either next level or repeat level in pop-up window after finishing game
        {
                if(next_game_win.won_game)
                {
                    if((current_level + 1) == NUM_LEVELS - 1)
                    {
                        // no more levels left to complete do something here
                    }
                    else
                    {
                        current_level++;
                    }
                }
                next_game_win.bring_down_window();
                viewDidLoad();
        }
        else if(sender.tag == 1) // clicked next level button on bottom m
        {
            if((current_level + 1) == NUM_LEVELS - 1)
            {
                // no more levels left to complete do something here
            }
            else
            {
                ++current_level;
            }
            viewDidLoad();
        }
        else if(sender.tag == -1)
        {
            if((current_level - 1) < 0)
            {
                // not allowed
            }
            else
            {
                --current_level;
            }
            viewDidLoad();
        }
    }
    
    func closed_window(sender:UIButton)
    {
        next_game_win.bring_down_window();
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        super_view = self.view;
        super_view.backgroundColor = UIColor.blackColor(); // hide date and time
        super_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        next_game_win.bring_down_window();

        //temporary_menu.bring_up();
    
        if(in_level_menu)
        {
            enter_level_menu();
        }
        else if(in_game)
        {
            gen_levels();
            game.remove_views();
            game = GameMap(level: levels[current_level]);
            DIM = levels[current_level].dimension;
            for(var i = 0; i < game.NUM_LOCS; ++i)
            {
                game.map[i].addTarget(self, action: "pressed_loc:", forControlEvents: UIControlEvents.TouchDown);
            }
        
            game.level_button.addTarget(self, action: "enter_level_menu", forControlEvents: UIControlEvents.TouchUpInside);
            game.level_button.setTitleColor(LIGHT_BLUE, forState: UIControlState.Highlighted);
        
            for(var i = 0; i < NUM_MEGA_LEVELS; ++i)
            {
                if(game.size_buttons[i].tag == DIM)
                {
                    game.size_buttons[i].setTitleColor(LIGHT_BLUE, forState: UIControlState.Normal);
                }
            }
            
            // add button to enter main menu
            game.startup_menu.addTarget(self, action: "entered_startup:", forControlEvents: UIControlEvents.TouchUpInside);
            game.startup_menu.setTitleColor(LIGHT_BLUE, forState: UIControlState.Highlighted);
            next_game_win.x_button.addTarget(self, action: "closed_window:", forControlEvents: UIControlEvents.TouchUpInside);
            next_game_win.next_level.addTarget(self, action: "next_level:", forControlEvents: UIControlEvents.TouchUpInside);
            next_game_win.next_level.tag = 0;
            
            // add repeat, prev, and next actions
            game.repeat_button.addTarget(self, action: "viewDidLoad", forControlEvents: UIControlEvents.TouchUpInside);
            game.repeat_button.addTarget(self, action: "reset", forControlEvents: UIControlEvents.TouchUpInside);
            game.next_button.addTarget(self, action: "next_level:", forControlEvents: UIControlEvents.TouchUpInside);
            game.prev_button.addTarget(self, action: "next_level:", forControlEvents: UIControlEvents.TouchUpInside);
            
            // tag next and previous
            game.next_button.tag = 1;
            game.prev_button.tag = -1;
            
        }
        else if(in_main_menu)
        {
            main_menu.show_main_menu();
            
            // add targets to each button
            for(var i = 0; i < main_menu.level_buttons.count; ++i)
            {
                main_menu.level_buttons[i].addTarget(self, action: "exited_startup:", forControlEvents: UIControlEvents.TouchUpInside);
                main_menu.level_buttons[i].tag = i;
                main_menu.level_buttons[i].setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted);
            }
        }
        else if(in_how_to)
        {
            how_to_screen.back_button.addTarget(self, action: "entered_startup:", forControlEvents: UIControlEvents.TouchUpInside);
        }
        else if(in_about)
        {
            about_window.back_button.addTarget(self, action: "entered_startup:", forControlEvents: UIControlEvents.TouchUpInside);
        }
        else if(in_volume)
        {
            settings_window.back_button.addTarget(self, action: "entered_startup:", forControlEvents: UIControlEvents.TouchUpInside);
            settings_window.volume_slider.addTarget(self, action: "adjust_volume:", forControlEvents: UIControlEvents.ValueChanged);
            settings_window.volume_slider.addTarget(self, action: "demonstrate_volume:", forControlEvents: UIControlEvents.TouchUpInside);
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func remove_subviews()
    {
        var subs = super_view.subviews;
        for(var i = 0; i < subs.count; ++i)
        {
            subs[i].removeFromSuperview();
        }
        super_view.layer.borderWidth = 0.0;
    }
}

