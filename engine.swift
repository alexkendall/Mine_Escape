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
let NUM_ROWS:Int = 7;
let NUM_COLS:Int = 5;
let NUM_LOCS = NUM_ROWS * NUM_COLS;
let TOP_BORDER:CGFloat = 20.0;
var COUNT:Int = 0;
var GAME_OVER:Bool = false;
var GAME_STARTED = false;
var START_LOC = Int(floor(Float(NUM_LOCS) / 2.0));
var map = Array<Mine_cell>();

// colors
let LIGHT_BLUE = UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0);
let DARK_BLUE = UIColor(red: 0.0, green: 0.0, blue: 0.3, alpha: 1.0);

//SPEED
enum SPEED{case SLOW, MED, FAST};

//-------------------------------------------------------------------------

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
    class func won_game() ->(Bool)
    {
        return (COUNT == (NUM_ROWS * NUM_COLS))
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
            else if(speed == SPEED.MED)
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
        ++COUNT;
        
        if((timer_running == false) && (!GAME_OVER))
        {
            if(speed == SPEED.SLOW)
            {
                time_til_disappears = 4;
                timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "update", userInfo: nil, repeats: true);
                timer_running = true;
            }
            else if(speed == SPEED.MED)
            {
                time_til_disappears = 4;
                timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "update", userInfo: nil, repeats: true);
                timer_running = true;
            }
            else
            {
                
            }
        }
    }
    func mark_explored()
    {
        if(!explored)
        {
            explored = true;
            backgroundColor = UIColor.grayColor();
            ++COUNT;
        }
    }
    func neighbors()->(Array<Int>)
    {
        var neighbor_indicies:Array<Int> = Array<Int>();
        
        // add right neigbor (if it exists)
        if(((loc_id + 1) % NUM_COLS) != 0)
        {
            neighbor_indicies.append(loc_id + 1);
        }
        
        // left neighbor
        if(((loc_id % NUM_COLS) != 0) && (loc_id > 0))
        {
            neighbor_indicies.append(loc_id - 1);
        }
        // top neighbor
        if((loc_id - NUM_COLS) >= 0)
        {
            neighbor_indicies.append(loc_id - NUM_COLS)
        }
        // bottom neighbor
        if((loc_id + NUM_COLS) < map.count)
        {
            neighbor_indicies.append(loc_id + NUM_COLS);
        }
        return neighbor_indicies;
    }
    func unmarked_neighbors()->(Array<Int>)
    {
        var neighbor_indicies:Array<Int> = neighbors();
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
    func printNeighbors()
    {
        println("--------------------------------------");
        var neighbor_indicies:Array<Int> = neighbors();
        println(String(format:"Neighbors of location %i", loc_id));
        for(var i = 0; i <  neighbor_indicies.count; ++i)
        {
            println(String(neighbor_indicies[i]));
        }
        println("--------------------------------------\n");
    }
}

//-------------------------------------------------------------------------
// WILL RESTRUCTURE CLASSES LATER
// AND GAME_MAP TO encapsulate game
class GameMap
{
    var map = Array<Mine_cell>();
    let NUM_ROWS:Int;
    let NUM_COLS:Int;
    let NUM_LOCS:Int;
    var COUNT:Int;
    var GAME_OVER:Bool = false;
    init()
    {
        NUM_ROWS = 4;
        NUM_COLS = 6;
        COUNT = 0;
        NUM_LOCS = 24;
    }
    init(num_rows:Int, num_cols:Int)
    {
        NUM_ROWS = num_rows;
        NUM_COLS = num_cols;
        COUNT = 0;
        GAME_OVER = false;
        NUM_LOCS = num_rows * num_cols;
    }
}

//-------------------------------------------------------------------------