//
//  ViewController.swift
//  MineEscape
//
//  Created by Alex Harrison on 3/20/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//

import UIKit
var super_view = UIView();

class ViewController: UIViewController {
    
    func pressed_loc(sender:Mine_cell!)
    {
        if(sender.mine_exists)  // user lost game
        {
            GAME_OVER = true;
            for(var i = 0; i < (NUM_ROWS * NUM_COLS); ++i)
            {
                map[i].timer.invalidate();
                map[i].backgroundColor = UIColor.redColor();
                if(map[i].mine_exists)
                {
                    map[i].mark_mine();
                }
            }
            super_view.bringSubviewToFront(sender);
            sender.layer.borderWidth = 5.0;
        }
        if(!sender.explored)
        {
            map[sender.tag].mark_explored();
            var neighbors = map[sender.tag].unmarked_neighbors();
            if((neighbors.count > 0) && ((NUM_LOCS - COUNT) > 1))
            {
                var temp_index:Int = Int(arc4random_uniform(UInt32(neighbors.count)));
                var index = neighbors[temp_index];
                map[index].mark_mine();
            }

        }
        if(Mine_cell.won_game())
        {
            for(var i = 0; i < (NUM_ROWS * NUM_COLS); ++i)
            {
                map[i].backgroundColor = UIColor.orangeColor();
                map[i].setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal);
                map[i].timer.invalidate();
            }
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        super_view = self.view;
        super_view.backgroundColor = UIColor.redColor();
        super_view.setTranslatesAutoresizingMaskIntoConstraints(false);
    
        var size:Float = 1.0;
        // create grid of elements
        for(var row = 0; row < NUM_ROWS; ++row)
        {
            for(var col = 0; col < NUM_COLS; ++col)
            {
                var width_const:CGFloat = CGFloat(1.0 / CGFloat(NUM_COLS));
                var height_const:CGFloat = CGFloat(1.0 / CGFloat(NUM_ROWS));
                
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
                subview.addTarget(self, action: "pressed_loc:", forControlEvents: UIControlEvents.TouchDown);
                map.append(subview);
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}

