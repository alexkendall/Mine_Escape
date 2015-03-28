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
    var NUM_ROWS:Int;
    var NUM_COLS:Int;
    var NUM_LOCS:Int;
    var COUNT:Int;
    var GAME_OVER:Bool = false;
    var START_LOC:Int;
    var GAME_STARTED:Bool;
    
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
        self.map[self.START_LOC].titleLabel?.font = UIFont(name: "Arial-BoldMT" , size: 15.0);
        super_view.layer.borderWidth = 2.0;
        super_view.layer.borderColor = UIColor.blackColor().CGColor
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
        //println(COUNT);
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
                println("You Lost! Game over...\n");
            }
            else if(!map[loc_id].explored)
            {
                map[loc_id].mark_explored();
                ++COUNT;
                //println(COUNT);
                if(won_game())
                {
                    println("You Won The game\n");
                    GAME_OVER = true;
                    end_game();
                }
            }
            // generate mines
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
        }
    }
}

//-------------------------------------------------------------------------