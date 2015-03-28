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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        super_view = self.view;
        super_view.backgroundColor = UIColor.blackColor(); // hide date and time
        super_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        game = GameMap(num_rows: 5, num_cols: 5);
        for(var i = 0; i < game.NUM_LOCS; ++i)
        {
            game.map[i].addTarget(self, action: "pressed_loc:", forControlEvents: UIControlEvents.TouchDown);
        }
        game.new_game_button.addTarget(self, action: "reset", forControlEvents: UIControlEvents.TouchDown);
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

