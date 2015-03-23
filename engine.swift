import UIKit
let NUM_ROWS:Int = 4;
let NUM_COLS:Int = 3;
let NUM_LOCS = NUM_ROWS * NUM_COLS;
let TOP_BORDER:CGFloat = 20.0;
var COUNT:Int = 0;
var GAME_OVER:Bool = false;

var map = Array<Grid_loc>();

//-------------------------------------------------------------------------
class Grid_loc:UIButton
{
    var mine_exists:Bool = false;
    var insignia:String = "";
    var explored:Bool = false;
    var time_til_disappears:Int = 0;
    var timer = NSTimer();
    var timer_running:Bool = false;
    
    override init()
    {
        mine_exists = false;
        insignia = "";
        explored = false;
        timer_running = false;
        super.init();
    }
    required init(coder aDecoder: NSCoder) {
        mine_exists = false;
        insignia = "";
        explored = false;
        super.init();
    }
    override init(frame: CGRect) {
        explored = false;
        mine_exists = false;
        insignia = "";
        timer_running = false;
        super.init(frame: frame);
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
        else if(GAME_OVER)
        {
            timer.invalidate();
            timer_running = false;
            println("Game Over");
        }
        else    // make mine disappear
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
        
        if(timer_running == false)
        {
            time_til_disappears = 1;
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true);
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
}

//-------------------------------------------------------------------------