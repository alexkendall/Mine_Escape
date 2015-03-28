//
//  ViewController.swift
//  MineEscape
//
//  Created by Alex Harrison on 3/20/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//®

//-------------------------------------------------------------------------

import UIKit

//-------------------------------------------------------------------------
// GLOBAL VARIABLES

let TOP_BORDER:CGFloat = 20.0;

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
                timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "update", userInfo: nil, repeats: true);
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
    var new_game_button = UIButton();
    var bottom_text = UILabel();
    var NUM_ROWS:Int;
    var NUM_COLS:Int;
    var NUM_LOCS:Int;
    var COUNT:Int;
    var GAME_OVER:Bool = false;
    var START_LOC:Int;
    var GAME_STARTED:Bool;
    var size_buttons = Array<UIButton>();
    
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
                
                //var height = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Height, multiplier: height_const, constant: 0.0);
                
                var height = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
    
                var increment_centerx:CGFloat  = (CGFloat(super_view.bounds.width) / CGFloat(NUM_COLS) * 0.5) + (CGFloat(super_view.bounds.width) / CGFloat(NUM_COLS) * CGFloat(col));
                
                var increment_x = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: increment_centerx);
                
                var increment_centery:CGFloat  = (super_view.bounds.width / CGFloat(NUM_ROWS) * 0.5) + (super_view.bounds.width / CGFloat(NUM_ROWS) * CGFloat(row));

                var increment_y = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: increment_centery + TOP_BORDER);
                
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
        
        if(DIM == 7)
        {
            self.map[self.START_LOC].titleLabel?.font = UIFont(name: "Arial-BoldMT" , size: 10.0);
        }
        else
        {
            self.map[self.START_LOC].titleLabel?.font = UIFont(name: "Arial-BoldMT" , size: 15.0);
        }
        super_view.layer.borderWidth = 2.0;
        super_view.layer.borderColor = UIColor.blackColor().CGColor
        
        self.bottom_text.setTranslatesAutoresizingMaskIntoConstraints(false);
        var center_x = NSLayoutConstraint(item: bottom_text, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var center_y_const = (super_view.bounds.width + super_view.bounds.height) / 2.0;
        var center_y = NSLayoutConstraint(item: bottom_text, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: center_y_const);
        
        super_view.addSubview(self.bottom_text);
        super_view.addConstraint(center_x);
        super_view.addConstraint(center_y);
        
        self.bottom_text.textColor = UIColor.whiteColor();
        self.bottom_text.textAlignment = NSTextAlignment.Center;
        self.bottom_text.font = UIFont(name: "Arial-BoldMT" , size: 35.0);
        
        self.new_game_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        self.new_game_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        var offset_x = NSLayoutConstraint(item: new_game_button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0);
        
        var offset_y = NSLayoutConstraint(item: new_game_button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -15.0);
        
        super_view.addSubview(new_game_button);
        super_view.addConstraint(offset_x);
        super_view.addConstraint(offset_y);
        new_game_button.setTitle("NEW GAME", forState: UIControlState.Normal);
        
        for(var i = 0; i < 3; ++i)
        {
            var size_button = UIButton();
            size_button.setTranslatesAutoresizingMaskIntoConstraints(false);
            super_view.addSubview(size_button);
            
            var off_const:CGFloat = 170.0 + (40.0 * CGFloat(i));
            
            var csy = NSLayoutConstraint(item: size_button, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: new_game_button, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
            
            
            var offset_left = NSLayoutConstraint(item: size_button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: new_game_button, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: off_const);
            
            var num = 3 + (2*i);
            var dim_str = String(format: "%ix%i", num, num);
            size_button.setTitle(dim_str, forState: UIControlState.Normal);
            size_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
            size_button.tag = num;
            
            super_view.addConstraint(offset_left);
            super_view.addConstraint(csy);
            size_buttons.append(size_button);
        }
    }
    
    init()
    {
        NUM_ROWS = 4;
        NUM_COLS = 6;
        COUNT = 0;
        NUM_LOCS = 24;
        START_LOC = Int(floor(Float(NUM_LOCS) / 2.0));
        GAME_STARTED = false;
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
        create_game(NUM_ROWS, cols: NUM_COLS);
        
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
    
    // REQUIRES: SPEED IS FROM 0-10
    // generates mines based on policy
    func generate_mines(policy:MINE_POLICY, speed:Int, loc_id:Int)
    {
        var speed_pool = Array<SPEED>();
        let num_slow = 10 - speed;
        let num_fast = speed;
        
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
                generate_mines(MINE_POLICY.LOCAL, speed: speed, loc_id: loc_id);
            }
            else
            {
                generate_mines(MINE_POLICY.GLOBAL, speed: speed, loc_id: loc_id);
            }
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
                self.bottom_text.text = "YOU LOST!";
                self.bottom_text.textColor = UIColor.redColor();
            }
            else if(!map[loc_id].explored)
            {
                map[loc_id].mark_explored();
                ++COUNT;
                if(won_game())
                {
                    self.bottom_text.text = "YOU WIN!";
                    self.bottom_text.textColor = LIGHT_BLUE;
                    GAME_OVER = true;
                    end_game();
                }
            }
            if(!GAME_OVER)
            {
                generate_mines(MINE_POLICY.LOCAL, speed: 0, loc_id: loc_id);
            }
            
            // generate mines
            /*
            if(((NUM_LOCS - COUNT) > 1) && !GAME_OVER)
            {
                var local_neighbors = unmarked_neighbors(loc_id);
                var global_neighbors = unmarked_global();
                
                if(local_neighbors.count > 0)
                {
                    var local_temp:Int = Int(arc4random_uniform(UInt32(local_neighbors.count)));
                    var local_index = local_neighbors[local_temp];
                    var global_temp:Int = Int(arc4random_uniform(UInt32(global_neighbors.count)));
                    var global_index:Int = global_neighbors[global_temp];
                    
                    var rand_indx:Int = Int(arc4random_uniform(UInt32(global_neighbors.count)));
                    
                    var mod_nums_array = [0,1];
                    var rand_mod:Int = Int(arc4random_uniform(UInt32(mod_nums_array.count)));
                    var mod_num = mod_nums_array[rand_mod];
                    
                    if((local_index % 2) == mod_num)
                    {
                        if((rand_indx % 2 == mod_num))
                        {
                            map[local_index].speed = SPEED.FAST;
                        }
                        mark_mine(local_index);
                    }
                    
                    else
                    {
                        map[global_index].speed = SPEED.FAST;
                        mark_mine(global_index);
                        
                        if((rand_indx % 2 == mod_num))
                        {
                            map[global_index].speed = SPEED.FAST;
                        }
                    }
                }
            }
            */
            // end generate mines
        }
    }
}

//-------------------------------------------------------------------------