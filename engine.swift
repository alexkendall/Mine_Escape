import UIKit
let NUM_ROWS:Int = 10;
let NUM_COLS:Int = 6;
let TOP_BORDER:CGFloat = 20.0;

var map = Array<Grid_loc>();


//-------------------------------------------------------------------------
class Grid_loc:UIButton
{
    var mine_exists:Bool = false;
    var insignia = "";
    override init()
    {
        mine_exists = false;
        insignia = "";
        super.init();
    }
    required init(coder aDecoder: NSCoder) {
        mine_exists = false;
        insignia = "";
        super.init();
    }
    override init(frame: CGRect) {
        mine_exists = false;
        insignia = "";
        super.init(frame: frame);
    }
    func mark_mine()
    {
         setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        insignia = "X";
        mine_exists = true;
        setTitle(insignia, forState: UIControlState.Normal);
    }
}

//-------------------------------------------------------------------------