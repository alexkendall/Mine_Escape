//
//  ViewController.swift
//  MineEscape
//
//  Created by Alex Harrison on 3/20/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//®

//-------------------------------------------------------------------------

import UIKit
var next_game_win = Next_Game();

//-------------------------------------------------------------------------
// GLOBAL VARIABLES

// colors
let LIGHT_BLUE = UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0);
let DARK_BLUE = UIColor(red: 0.0, green: 0.0, blue: 0.3, alpha: 1.0);
let BLUE = UIColor.blueColor();

//SPEED
enum SPEED{case SLOW, FAST};

let NUM_SPEEDS:Int = 10;

//-------------------------------------------------------------------------
// CLASS THAT HOLDS DATA FOR EACH MINE CELL

class Mine_cell:UIButton
{
    var loc_id:Int;
    var mine_exists:Bool = false;
    var insignia:String = "";
    var explored:Bool = false;
    var time_til_disappears:Int = 0;
    var timer = NSTimer();
    var timer_running:Bool = false;
    var speed:SPEED;
    
    override init()
    {
        loc_id = -1;
        mine_exists = false;
        insignia = "";
        explored = false;
        timer_running = false;
        speed = SPEED.SLOW;
        super.init();
    }
    required init(coder aDecoder: NSCoder) {
        loc_id = -1;
        mine_exists = false;
        insignia = "";
        explored = false;
        speed = SPEED.SLOW;
        super.init();
    }
    override init(frame: CGRect) {
        loc_id = -1;
        explored = false;
        mine_exists = false;
        insignia = "";
        timer_running = false;
        speed = SPEED.SLOW;
        super.init(frame: frame);
    }
    init(location_identifier:Int)
    {
        loc_id = location_identifier;
        explored = false;
        mine_exists = false;
        insignia = "";
        timer_running = false;
        speed = SPEED.SLOW;
        super.init();
        loc_id = location_identifier;
    }
    func set_image(var name:String)
    {
        var image = UIImage(named: name);
        setImage(image, forState: UIControlState.Normal);
    }
    func update()
    {
        if(time_til_disappears > 0)
        {
            --time_til_disappears;
            if(speed == SPEED.SLOW)
            {
                switch time_til_disappears
                {
                case 3:
                    set_image("mine_red");
                case 2:
                    set_image("mine_orange");
                case 1:
                    set_image("mine_yellow");
                case 0:
                    imageView?.image = nil;
                default:
                    set_image("mine_black");
                }
            }
            else if(speed == SPEED.FAST)
            {
                switch time_til_disappears
                {
                case 3:
                    set_image("mine_dark_blue");
                case 2:
                    set_image("mine_blue");
                case 1:
                    set_image("mine_light_blue");
                case 0:
                    imageView?.image = nil;
                default:
                    set_image("mine_black");
                }
            }
        }
        else    // remove mine indicator
        {
            timer.invalidate();
            setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal);
            imageView?.image = nil;
            timer_running = false;
        }
    }
    func mark_mine()
    {
        mine_exists = true;
        setTitle(insignia, forState: UIControlState.Normal);
        set_image("mine_black");
        
        if(timer_running == false)
        {
            if(speed == SPEED.SLOW)
            {
                time_til_disappears = 4;
                timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "update", userInfo: nil, repeats: true);
                timer_running = true;
            }
            else if(speed == SPEED.FAST)
            {
                time_til_disappears = 4;
                timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "update", userInfo: nil, repeats: true);
                timer_running = true;
            }
        }
    }
    func mark_explored()
    {
        if(!explored)
        {
            explored = true;
            backgroundColor = UIColor.grayColor();
        }
    }
}

//-------------------------------------------------------------------------
// HOLDS DATA TO ENCAPSULATE A SINGLE GAME

class GameMap
{
    var map = Array<Mine_cell>();
    var NUM_ROWS:Int;
    var NUM_COLS:Int;
    var NUM_LOCS:Int;
    var COUNT:Int;
    var GAME_OVER:Bool = false;
    var START_LOC:Int;
    var GAME_STARTED:Bool;
    var MINE_SPEED:Int;
    var POLICY:MINE_POLICY;
    var level_indicator:UILabel = UILabel();
    var level_no:Int = 0;

    // labels
    var bottom_text = UILabel();

    // buttons
    var size_buttons = Array<UIButton>();
    var startup_menu = UIButton();
    var prev_button = UIButton();
    var next_button = UIButton();
    var repeat_button = UIButton();
    var level_button = UIButton();
    
    func remove_views()
    {
        for(var i = 0; i < map.count; ++i)
        {
            map[i].removeFromSuperview();
        }
        bottom_text.removeFromSuperview();
        for(var i = 0; i < size_buttons.count; ++i)
        {
            size_buttons[i].removeFromSuperview();
        }
        level_button.removeFromSuperview();
        level_indicator.removeFromSuperview();
        startup_menu.removeFromSuperview();
        repeat_button.removeFromSuperview();
        prev_button.removeFromSuperview();
        next_button.removeFromSuperview();
    }
    
    func create_game(rows:Int, cols:Int)
    {
        NUM_ROWS = rows;
        NUM_COLS = cols;
        NUM_LOCS = rows * cols;
        map.removeAll(keepCapacity: true);
        COUNT = 0;
        GAME_OVER = false;
        START_LOC = Int(floor(Float(NUM_LOCS) / 2.0));
        GAME_STARTED = false;
        
        var margin_height = (super_view.bounds.height - super_view.bounds.width) / 2.0;
        
        var size:Float = 1.0;
        // create grid of elements
        for(var row = 0; row < self.NUM_ROWS; ++row)
        {
            for(var col = 0; col < self.NUM_COLS; ++col)
            {
                var width_const:CGFloat = CGFloat(1.0 / CGFloat(self.NUM_COLS));
                var height_const:CGFloat = CGFloat(1.0 / CGFloat(self.NUM_ROWS));
                
                var loc = (row * NUM_COLS) + col;
                var subview:Mine_cell = Mine_cell(location_identifier:loc);
                subview.setTranslatesAutoresizingMaskIntoConstraints(false);
                
                var width = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: width_const, constant: 0.0);
                
                var height = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
    
                var increment_centerx:CGFloat  = (CGFloat(super_view.bounds.width) / CGFloat(NUM_COLS) * 0.5) + (CGFloat(super_view.bounds.width) / CGFloat(NUM_COLS) * CGFloat(col));
                
                var increment_x = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: increment_centerx);
                
                var increment_centery:CGFloat  = (super_view.bounds.width / CGFloat(NUM_ROWS) * 0.5) + (super_view.bounds.width / CGFloat(NUM_ROWS) * CGFloat(row));

                var increment_y = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: increment_centery + margin_height);
                
                subview.backgroundColor = UIColor.whiteColor();
                subview.layer.borderWidth = 1.0;
                super_view.addSubview(subview);
                super_view.addConstraint(width);
                super_view.addConstraint(height);
                super_view.addConstraint(increment_x);
                super_view.addConstraint(increment_y);
                // tag element to uniquely identify it
                subview.tag = (row * NUM_COLS) + col;
                var tag:Int = (row * NUM_COLS) + col;
                //subview.addTarget(super_view, action: "pressed_loc:", forControlEvents: UIControlEvents.TouchDown);
                self.map.append(subview);
                //self.map[tag].addTarget(self, action: "pressed_loc:", forControlEvents: UIControlEvents.TouchDown);
            }
        }
        self.map[self.START_LOC].backgroundColor = UIColor.grayColor();
        self.map[self.START_LOC].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        self.map[self.START_LOC].setTitle("START", forState: UIControlState.Normal);
        
        if(NUM_ROWS == 7)
        {
            self.map[self.START_LOC].titleLabel?.font = UIFont(name: "Arial-BoldMT" , size: 10.0);
        }
        else if(NUM_ROWS == 5)
        {
            self.map[self.START_LOC].titleLabel?.font = UIFont(name: "Arial-BoldMT" , size: 15.0);
        }
        else
        {
            self.map[self.START_LOC].titleLabel?.font = UIFont(name: "Arial-BoldMT" , size: 18.0);
        }
        super_view.layer.borderWidth = 2.0;
        super_view.layer.borderColor = UIColor.blackColor().CGColor
        
        self.bottom_text.setTranslatesAutoresizingMaskIntoConstraints(false);
        var center_x = NSLayoutConstraint(item: bottom_text, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var center_y_const = (super_view.bounds.width + super_view.bounds.height) / 2.0;
        var center_y = NSLayoutConstraint(item: bottom_text, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: center_y_const);
        
        var menu_font_size:CGFloat = 20.0
        super_view.addSubview(self.bottom_text);
        super_view.addConstraint(center_x);
        super_view.addConstraint(center_y);
        
        self.bottom_text.textColor = UIColor.whiteColor();
        self.bottom_text.textAlignment = NSTextAlignment.Center;
        self.bottom_text.font = UIFont(name: "Arial-BoldMT" , size: 35.0);
        
        level_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        level_button.setTitle("LEVEL MENU", forState: UIControlState.Normal);
        level_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        level_button.titleLabel?.font = UIFont(name: "Arial", size: menu_font_size);
        super_view.addSubview(level_button);
        
        var menu_offset_x = NSLayoutConstraint(item: level_button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0);
        
        var offsety_menu = NSLayoutConstraint(item: level_button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 20.0);
        
        super_view.addConstraint(menu_offset_x);
        super_view.addConstraint(offsety_menu);
        
        startup_menu.setTranslatesAutoresizingMaskIntoConstraints(false);
        startup_menu.setTitle("MAIN MENU", forState: UIControlState.Normal);
        startup_menu.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        startup_menu.titleLabel?.font = UIFont(name: "Arial", size: menu_font_size);
        super_view.addSubview(startup_menu);
        
        var main_menu_offset_x = NSLayoutConstraint(item: startup_menu, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0);
        
        var main_offsety_menu = NSLayoutConstraint(item: startup_menu, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 20.0);
        
        super_view.addConstraint(main_menu_offset_x);
        super_view.addConstraint(main_offsety_menu);
        
        
        for(var i = 0; i < 3; ++i)
        {
            var size_button = UIButton();
            size_button.setTranslatesAutoresizingMaskIntoConstraints(false);
            super_view.addSubview(size_button);
            
            var off_const:CGFloat = 20.0 + (40.0 * CGFloat(i));
            
            var csy = NSLayoutConstraint(item: size_button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -20.0);
            
            
            var offset_right = NSLayoutConstraint(item: size_button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -off_const);
            
            var num = 3 + (2*i);
            var dim_str = String(format: "%ix%i", num, num);
            size_button.setTitle(dim_str, forState: UIControlState.Normal);
            size_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
            size_button.tag = num;
            
            
            super_view.addConstraint(offset_right);
            super_view.addConstraint(csy);
            size_buttons.append(size_button);
        }
        
        level_indicator.setTranslatesAutoresizingMaskIntoConstraints(false);
        super_view.addSubview(level_indicator);
        
        var centery_li = NSLayoutConstraint(item: level_indicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: size_buttons[0], attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        var offset_left_li = NSLayoutConstraint(item: level_indicator, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0);
        
        super_view.addConstraint(centery_li);
        super_view.addConstraint(offset_left_li);
        level_indicator.text = String(format:"LEVEL %i", current_level);
        level_indicator.textColor = LIGHT_BLUE;
        
        
        var repeat_image = UIImage(named: "repeat_level");
        var prev_image = UIImage(named: "prev_level");
        var next_image = UIImage(named: "next_level");
        
        // create repeat button
        repeat_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        repeat_button.setBackgroundImage(repeat_image, forState: UIControlState.Normal);
        repeat_button.layer.borderWidth = 1.0;
        repeat_button.layer.borderColor = UIColor.whiteColor().CGColor;
        repeat_button.layer.backgroundColor = UIColor.blackColor().CGColor;
        
        var button_width:CGFloat = 40.0;
        
        //set constraints
        var centerx_repeat = NSLayoutConstraint(item: repeat_button, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var centery_repeat = NSLayoutConstraint(item: repeat_button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: map[map.count - 1], attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 15.0);
    
        var width_repeat = NSLayoutConstraint(item: repeat_button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: repeat_button, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: button_width);
        
        var height_repeat = NSLayoutConstraint(item: repeat_button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: repeat_button, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -button_width);
        
        // configure hiearchy
        super_view.addSubview(repeat_button);
        super_view.addConstraint(centerx_repeat);
        super_view.addConstraint(centery_repeat);
        super_view.addConstraint(width_repeat);
        super_view.addConstraint(height_repeat);
        
        // create previous button
        prev_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        prev_button.setBackgroundImage(prev_image, forState: UIControlState.Normal);
        prev_button.layer.borderWidth = 1.0;
        prev_button.layer.borderColor = UIColor.whiteColor().CGColor;
        prev_button.layer.backgroundColor = UIColor.blackColor().CGColor;
        
        //set constraints
        var centerx_prev = NSLayoutConstraint(item: prev_button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: repeat_button, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: -15.0);
        
        var centery_prev = NSLayoutConstraint(item: prev_button, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: repeat_button, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        var width_prev = NSLayoutConstraint(item: prev_button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: prev_button, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: button_width);
        
        var height_prev = NSLayoutConstraint(item: prev_button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: prev_button, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -button_width);
        
        // configure hiearchy
        super_view.addSubview(prev_button);
        super_view.addConstraint(centerx_prev);
        super_view.addConstraint(centery_prev);
        super_view.addConstraint(width_prev);
        super_view.addConstraint(height_prev);

        // create next button
        next_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        next_button.setBackgroundImage(next_image, forState: UIControlState.Normal);
        next_button.layer.borderWidth = 1.0;
        next_button.layer.borderColor = UIColor.whiteColor().CGColor;
        next_button.layer.backgroundColor = UIColor.blackColor().CGColor;
        
        //set constraints
        var centerx_next = NSLayoutConstraint(item: next_button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: repeat_button, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 15.0);
        
        var centery_next = NSLayoutConstraint(item: next_button, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: repeat_button, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        var width_next = NSLayoutConstraint(item: next_button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: next_button, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: button_width);
        
        var height_next = NSLayoutConstraint(item: next_button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: next_button, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -button_width);
        
        // configure hiearchy
        super_view.addSubview(next_button);
        super_view.addConstraint(centerx_next);
        super_view.addConstraint(centery_next);
        super_view.addConstraint(width_next);
        super_view.addConstraint(height_next);
    }
    init()
    {
        NUM_ROWS = 4;
        NUM_COLS = 6;
        COUNT = 0;
        NUM_LOCS = 24;
        START_LOC = Int(floor(Float(NUM_LOCS) / 2.0));
        GAME_STARTED = false;
        self.MINE_SPEED = 5;
        self.POLICY = MINE_POLICY.MIXED;
    }
    init(num_rows:Int, num_cols:Int)
    {
        
        NUM_ROWS = num_rows;
        NUM_COLS = num_cols;
        COUNT = 0;
        GAME_OVER = false;
        NUM_LOCS = num_rows * num_cols;
        START_LOC = Int(floor(Float(NUM_LOCS) / 2.0));
        GAME_STARTED = false;
        self.MINE_SPEED = 5;
        self.POLICY = MINE_POLICY.MIXED;
        create_game(NUM_ROWS, cols: NUM_COLS);
        
    }
    
    init(level:Level)
    {
        NUM_ROWS = level.dimension;
        NUM_COLS = level.dimension;
        COUNT = 0;
        GAME_OVER = false;
        NUM_LOCS = NUM_ROWS * NUM_COLS;
        START_LOC = Int(floor(Float(NUM_LOCS) / 2.0));
        GAME_STARTED = false;
        self.MINE_SPEED = level.speed;
        self.POLICY = level.policy;
        create_game(level.dimension, cols: level.dimension);
        self.level_no = level.level;
    }
    
    func won_game()->Bool
    {
        return (COUNT == NUM_LOCS);
    }
    
    func neighbors(var index:Int)->(Array<Int>)
    {
        var neighbor_indicies:Array<Int> = Array<Int>();
        
        // add right neigbor (if it exists)
        if(((index + 1) % NUM_COLS) != 0)
        {
            neighbor_indicies.append(index + 1);
        }
        
        // left neighbor
        if(((index % NUM_COLS) != 0) && (index > 0))
        {
            neighbor_indicies.append(index - 1);
        }
        // top neighbor
        if((index - NUM_COLS) >= 0)
        {
            neighbor_indicies.append(index - NUM_COLS)
        }
        // bottom neighbor
        if((index + NUM_COLS) < map.count)
        {
            neighbor_indicies.append(index + NUM_COLS);
        }
        return neighbor_indicies;
    }
    
    func unmarked_neighbors(var index:Int)->(Array<Int>)
    {
        var neighbor_indicies:Array<Int> = neighbors(index);
        var unexplored:Array<Int> = Array<Int>();
        for(var i = 0; i < neighbor_indicies.count; ++i)
        {
            if(!map[neighbor_indicies[i]].mine_exists && !map[neighbor_indicies[i]].explored)
            {
                unexplored.append(neighbor_indicies[i]);
            }
        }
        return unexplored;
    }
    
    func printNeighbors(var index:Int)
    {
        println("--------------------------------------");
        var neighbor_indicies:Array<Int> = neighbors(index);
        println(String(format:"Neighbors of location %i", index));
        for(var i = 0; i <  neighbor_indicies.count; ++i)
        {
            println(String(neighbor_indicies[i]));
        }
        println("--------------------------------------\n");
    }
    
    func mark_mine(var loc_id:Int)
    {
        map[loc_id].mark_mine();
        map[loc_id].mine_exists = true;
        ++COUNT;
    }
    
    func end_game()
    {
        for(var i = 0; i < NUM_LOCS; ++i)
        {
            if(map[i].mine_exists == true)
            {
                map[i].mark_mine();
                map[i].timer.invalidate();
                if(won_game())
                {
                    map[i].backgroundColor = LIGHT_BLUE;
                }
                else
                {
                    map[i].backgroundColor = UIColor.redColor();
                }

            }
        }
    }
    
    func unmarked_global()->(Array<Int>)
    {
        var arr = Array<Int>();
        for(var i = 0; i < NUM_LOCS; ++i)
        {
            if((!map[i].explored) && (!map[i].mine_exists))
            {
                arr.append(i);
            }
        }
        return arr;
    }
    
    // REQUIRES: SPEED IS WITHIN [0-10]
    // generates mines based on policy
    func generate_mines(policy:MINE_POLICY, loc_id:Int)
    {
        var speed_pool = Array<SPEED>();
        let num_slow = 10 - self.MINE_SPEED;
        let num_fast = self.MINE_SPEED;
        
        for(var i = 0; i < num_slow; ++i)
        {
            speed_pool.append(SPEED.SLOW);
        }
        for(var i = 0; i < num_fast; ++i)
        {
            speed_pool.append(SPEED.FAST);
        }
        // get random speed out of distribution of those generated
        var speed_index = arc4random_uniform(10);
        var mine_speed = speed_pool[Int(speed_index)];
        
        //
        var local_unmarked = unmarked_neighbors(loc_id);
        var global_unmarked = unmarked_global();
        
        if((policy == MINE_POLICY.LOCAL) && (local_unmarked.count > 0) )
        {
            var temp_index = Int(arc4random_uniform(UInt32(local_unmarked.count)));
            var index = local_unmarked[temp_index];
            map[index].speed = mine_speed;
            mark_mine(index);
        }
        else if((policy == MINE_POLICY.GLOBAL) && (global_unmarked.count > 0))
        {
            var temp_index = Int(arc4random_uniform(UInt32(global_unmarked.count)));
            var index = global_unmarked[temp_index];
            map[index].speed = mine_speed;
            mark_mine(index);
        }
        else    // MIXED policy
        {
            // generate random number from 0-1, and chose mine speed on 50/50 distribution
            var rand_num = arc4random_uniform(2); // can be either 0 or 1
            if(rand_num == 0)
            {
                generate_mines(MINE_POLICY.LOCAL, loc_id: loc_id);
            }
            else
            {
                generate_mines(MINE_POLICY.GLOBAL, loc_id: loc_id);
            }
        }
    }
    
    func mark_completed()
    {
        if(find(levels_completed, level_no) == nil)
        {
            levels_completed.append(level_no);
        }
    }
    
    func mark_location(var loc_id:Int)
    {
        if(GAME_STARTED == false)
        {
            if(loc_id == START_LOC) // dont start game until user presses start button
            {
                GAME_STARTED = true;
                map[loc_id].setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal);
                mark_location(loc_id);
                map[loc_id].explored = true;
            }
        }
        else if(!GAME_OVER)
        {
            if(map[loc_id].mine_exists)
            {
                // game is over
                GAME_OVER = true;
                end_game();
                map[loc_id].setTitleColor(UIColor.redColor(), forState: UIControlState.Normal);
                map[loc_id].backgroundColor = UIColor.blackColor();
                map[loc_id].layer.borderWidth = 1.0;
                map[loc_id].layer.borderColor = UIColor.whiteColor().CGColor;
                map[loc_id].set_image("mine_white");
                //self.bottom_text.textColor = UIColor.redColor();
                next_game_win.won_game = false;
                next_game_win.bring_up_window();
            }
            else if(!map[loc_id].explored)
            {
                map[loc_id].mark_explored();
                ++COUNT;
                if(won_game())
                {
                    self.bottom_text.textColor = LIGHT_BLUE;
                    mark_completed();
                    GAME_OVER = true;
                    end_game();
                    next_game_win.won_game = true;
                    next_game_win.bring_up_window();
                }
                else if(!GAME_OVER)
                {
                    generate_mines(self.POLICY, loc_id: loc_id);
                }
            }
        }
    }
}

//-------------------------------------------------------------------------