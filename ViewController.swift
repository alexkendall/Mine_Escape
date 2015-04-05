//
//  ViewController.swift
//  MineEscape
//
//  Created by Alex Harrison on 3/20/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//®
import UIKit
var super_view = UIView();
var game:GameMap = GameMap();
var DIM:Int = 3;
var level_menu:LevelMenu = LevelMenu();
var current_level = 0;
var levels_completed = Array<Int>(); // will store this in core data in future
var main_menu:Main_menu = Main_menu();
var in_main_menu = true;
var in_level_menu = false;
var in_game = false;
var in_how_to = false;
var how_to_screen = HowToScreen();
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
        game.bottom_text.text = "";
        viewDidLoad();
    }
    
    func load_level(sender:menu_button!)
    {
        current_level = sender.level;
        game.bottom_text.text = "";
        level_menu.removeMenu();
        in_level_menu = false;
        in_game = true;
        in_how_to = false;
        in_main_menu = false;
        viewDidLoad();
    }
    
    func enter_level_menu()
    {
        remove_subviews();
        level_menu.createMenu();
        for(var i = 0; i < level_menu.buttons.count; ++i)
        {
            level_menu.buttons[i].addTarget(self, action: "load_level:", forControlEvents: UIControlEvents.TouchUpInside);
            level_menu.buttons[i].setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted);
            level_menu.buttons[i].setTitleShadowColor(UIColor.whiteColor(), forState: UIControlState.Highlighted);
            level_menu.buttons[i].tag = i;
            level_menu.buttons[i].level = i;
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
    
    func exited_main(sender:UIButton!)
    {
        if(sender.tag == 0)
        {
            in_main_menu = false;
            in_game = false;
            in_how_to = false;
            in_level_menu = true;
            remove_subviews();
            viewDidLoad();
        }
        if(sender.tag == 2)
        {
            in_main_menu = false;
            in_how_to = true;
            in_game = false;
            remove_subviews();
            how_to_screen.bring_up();
            viewDidLoad();
        }
    }
    
    func entered_main(sender:UIButton!)
    {
        in_game = false;
        in_main_menu = true;
        how_to_screen.pull_down();
        remove_subviews();
        main_menu.remove_main_menu();
        viewDidLoad();
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        super_view = self.view;
        super_view.backgroundColor = UIColor.blackColor(); // hide date and time
        super_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        
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
        
            game.new_game_button.addTarget(self, action: "reset", forControlEvents: UIControlEvents.TouchUpInside);
            game.new_game_button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted);
            game.MENU_button.addTarget(self, action: "enter_level_menu", forControlEvents: UIControlEvents.TouchUpInside);
            game.MENU_button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted);
        
            for(var i = 0; i < 3; ++i)
            {
                if(game.size_buttons[i].tag == DIM)
                {
                    game.size_buttons[i].setTitleColor(LIGHT_BLUE, forState: UIControlState.Normal);
                }
            }
            
            // add button to enter main menu
            game.MAIN_MENU_button.addTarget(self, action: "entered_main:", forControlEvents: UIControlEvents.TouchUpInside);
            game.MAIN_MENU_button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted);
            
        }
        else if(in_main_menu)
        {
            main_menu.show_main_menu();
            
            // add targets to each button
            for(var i = 0; i < main_menu.menu_buttons.count; ++i)
            {
                main_menu.menu_buttons[i].addTarget(self, action: "exited_main:", forControlEvents: UIControlEvents.TouchUpInside);
                main_menu.menu_buttons[i].tag = i;
                main_menu.menu_buttons[i].setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted);
            }
        }
        else if(in_how_to)
        {
            how_to_screen.back_button.addTarget(self, action: "entered_main:", forControlEvents: UIControlEvents.TouchUpInside);
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

