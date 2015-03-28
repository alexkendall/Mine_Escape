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
var DIM:Int = 5;

class ViewController: UIViewController {

    func pressed_loc(sender:Mine_cell!)
    {
        game.mark_location(sender.loc_id);
    }
    
    func reset()
    {
        game.bottom_text.text = "";
        viewDidLoad();
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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        super_view = self.view;
        super_view.backgroundColor = UIColor.blackColor(); // hide date and time
        super_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        game = GameMap(num_rows: DIM, num_cols:DIM);
        for(var i = 0; i < game.NUM_LOCS; ++i)
        {
            game.map[i].addTarget(self, action: "pressed_loc:", forControlEvents: UIControlEvents.TouchDown);
        }
        game.new_game_button.addTarget(self, action: "reset", forControlEvents: UIControlEvents.TouchDown);
        for(var i = 0; i < 3; ++i)
        {
            game.size_buttons[i].addTarget(self, action: "set_dimension:", forControlEvents: UIControlEvents.TouchDown);
            if(game.size_buttons[i].tag == DIM)
            {
                game.size_buttons[i].setTitleColor(LIGHT_BLUE, forState: UIControlState.Normal);
            }
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
    }
}

