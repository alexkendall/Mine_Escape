import UIKit
let NUM_ROWS:Int = 5;
let NUM_COLS:Int = 4;
let NUM_LOCS = NUM_ROWS * NUM_COLS;
let TOP_BORDER:CGFloat = 20.0;
var COUNT:Int = 0;
var GAME_OVER:Bool = false;

var map = Array<Mine_cell>();

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
    
    override init()
    {
        loc_id = -1;
        mine_exists = false;
        insignia = "";
        explored = false;
        timer_running = false;
        super.init();
    }
    required init(coder aDecoder: NSCoder) {
        loc_id = -1;
        mine_exists = false;
        insignia = "";
        explored = false;
        super.init();
    }
    override init(frame: CGRect) {
        loc_id = -1;
        explored = false;
        mine_exists = false;
        insignia = "";
        timer_running = false;
        super.init(frame: frame);
    }
    init(location_identifier:Int)
    {
        loc_id = location_identifier;
        explored = false;
        mine_exists = false;
        insignia = "";
        timer_running = false;
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
            time_til_disappears = 1;
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "update", userInfo: nil, repeats: true);
            timer_running = true;
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