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
                    setTitleColor(UIColor.redColor(), forState: UIControlState.Normal);
                case 2:
                    setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal);
                case 1:
                    setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal);
                case 0:
                    setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal);
                default:
                    setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
                }
            }
            else if(speed == SPEED.FAST)
            {
                switch time_til_disappears
                {
                case 3:
                    setTitleColor(DARK_BLUE, forState: UIControlState.Normal);
                case 2:
                    setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal);
                case 1:
                    setTitleColor(LIGHT_BLUE, forState: UIControlState.Normal);
                case 0:
                    setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal);
                default:
                    setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
                }
            }
        }
        else    // remove mine indicator
        {
            timer.invalidate();
            setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal);
            timer_running = false;
        }
    }
    func mark_mine()
    {
        setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        insignia = "X";
        mine_exists = true;
        setTitle(insignia, forState: UIControlState.Normal);
        titleLabel?.font = UIFont(name: "Arial-BoldMT" , size: 30.0);
        
        if(timer_running == false)
        {
            if(speed == SPEED.SLOW)
            {
                time_til_disappears = 4;
                timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "update", userInfo: nil, repeats: true);
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
    let NUM_ROWS:Int;
    let NUM_COLS:Int;
    let NUM_LOCS:Int;
    var COUNT:Int;
    var GAME_OVER:Bool = false;
    var START_LOC:Int;
    var GAME_STARTED:Bool;
    
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
                
                var height = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Height, multiplier: height_const, constant: 0.0);
                
                var increment_centerx:CGFloat  = (CGFloat(super_view.bounds.width) / CGFloat(NUM_COLS) * 0.5) + (CGFloat(super_view.bounds.width) / CGFloat(NUM_COLS) * CGFloat(col));
                
                var increment_x = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: increment_centerx);
                
                var increment_centery:CGFloat  = ((CGFloat(super_view.bounds.height) - TOP_BORDER) / CGFloat(NUM_ROWS) * 0.5) + ((CGFloat(super_view.bounds.height - TOP_BORDER)) / CGFloat(NUM_ROWS) * CGFloat(row));
                
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
        super_view.layer.borderColor = UIColor.blackColor().CGColor;
        
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
        ++COUNT;
    }
    
    func end_game()
    {
        for(var i = 0; i < NUM_LOCS; ++i)
        {
            if(map[i].mine_exists == true)
            {
                map[i].mark_mine();
                map[i].backgroundColor = UIColor.redColor();
                map[i].timer.invalidate();
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
                println("You Lost! Game over...\n");
            }
            else if(!map[loc_id].explored)
            {
                map[loc_id].mark_explored();
                ++COUNT;
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
                var neighbors = unmarked_neighbors(loc_id);
                if(neighbors.count > 0)
                {
                    var temp_index:Int = Int(arc4random_uniform(UInt32(neighbors.count)));
                    var index = neighbors[temp_index];
                    if((index % 4) == 0)
                    {
                        map[index].speed = SPEED.FAST;
                    }
                    mark_mine(index);
                }
            }
        }
    }
}

//-------------------------------------------------------------------------