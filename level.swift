//
//  level.swift
//  MineEscape
//
//  Created by Alex Harrison on 3/28/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//

import UIKit
enum MINE_POLICY{case LOCAL, GLOBAL, MIXED};
var levels = Array<Level>();


class Level:UIButton
{
    var level:Int;
    var speed:Int;
    var policy:MINE_POLICY;
    var dimension:Int;
    override init()
    {
        self.level = 0;
        self.speed = 0;
        self.policy = MINE_POLICY.LOCAL;
        self.dimension = 5;
        
        super.init();
    }
    required init(coder aDecoder: NSCoder) {
        self.level = 0;
        self.speed = 0;
        self.policy = MINE_POLICY.LOCAL;
        self.dimension = 5;
        super.init();
    }
    override init(frame: CGRect) {
        self.level = 0;
        self.speed = 0;
        self.policy = MINE_POLICY.LOCAL;
        self.dimension = 5;
        super.init(frame:frame);
    }
    init(in_level:Int, in_speed:Int, in_policy:MINE_POLICY, in_dimension:Int)
    {
        self.level = in_level;
        self.speed = in_speed;
        self.policy = in_policy;
        self.dimension = in_dimension;
        super.init();
        self.dimension = in_dimension;
        self.policy = in_policy;
        self.level = in_level;
        self.speed = in_speed;
    }
}

func gen_levels()
{
    for(var i = 0; i < 15; ++i)
    {
        levels.append(Level(in_level: i, in_speed: 8, in_policy: MINE_POLICY.MIXED, in_dimension: 3));
    }
    for(var i = 15; i < 30; ++i)
    {
        levels.append(Level(in_level: i, in_speed: 5, in_policy: MINE_POLICY.GLOBAL, in_dimension: 5));
    }
    for(var i = 30; i < 45; ++i)
    {
        levels.append(Level(in_level: i, in_speed: 10, in_policy: MINE_POLICY.GLOBAL, in_dimension: 7));
    }
}

class Next_Game
{
    // create view that will hold next level
    var complete_container = UIView();
    var won_game = false;
    var next_level = UIButton();
    
    func bring_up_window()
    {
        // create container to hold next level buttn
        var width = super_view.bounds.width * 0.75;
        complete_container.layer.borderWidth = 1.0;
        complete_container.layer.borderColor = UIColor.whiteColor().CGColor;
        complete_container.backgroundColor = UIColor.blackColor();
        complete_container.alpha = 0.85;
        
        // add constraints
        complete_container.setTranslatesAutoresizingMaskIntoConstraints(false);
        var centerx = NSLayoutConstraint(item: complete_container, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var centery = NSLayoutConstraint(item: complete_container, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        var width_container = NSLayoutConstraint(item: complete_container, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: complete_container, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: width);
        
        var height_container = NSLayoutConstraint(item: complete_container, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: complete_container, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: width);
        
        super_view.addSubview(complete_container);
        super_view.addConstraint(centerx);
        super_view.addConstraint(centery);
        super_view.addConstraint(width_container);
        super_view.addConstraint(height_container);

        // add win or loss label
        
        var completed_label = UILabel();
        completed_label.font = UIFont(name: "Arial", size: 25.0);
        
        if(won_game)
        {
            completed_label.textColor = UIColor.orangeColor();
            completed_label.text = String(format: "Level %i Completed", current_level);
        }
        else
        {
            completed_label.textColor = UIColor.redColor();
            completed_label.text = String(format: "Level %i Failed", current_level);
        }
        
        // add constraints
        completed_label.setTranslatesAutoresizingMaskIntoConstraints(false);
        var centerx_label = NSLayoutConstraint(item: completed_label, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: complete_container, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var centery_label = NSLayoutConstraint(item: completed_label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: complete_container, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: width / 3.0);
        
        complete_container.addSubview(completed_label);
        complete_container.addConstraint(centerx_label);
        complete_container.addConstraint(centery_label);
        
        // add next level button
        next_level.setTranslatesAutoresizingMaskIntoConstraints(false);
        next_level.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        next_level.layer.borderWidth = 1.0;
        next_level.layer.borderColor = UIColor.whiteColor().CGColor;
        next_level.setTitleColor(LIGHT_BLUE, forState: UIControlState.Highlighted);
        if(won_game)
        {
            next_level.setTitle("Next Level", forState: UIControlState.Normal);
        }
        else
        {
            next_level.setTitle("Repeat Level", forState: UIControlState.Normal);
        }
        
        // add constraints
        var centery_next_level = NSLayoutConstraint(item: next_level, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: complete_container, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: width * 2.0 / 3.0);
        
        // add constraints
        var centerx_next_level = NSLayoutConstraint(item: next_level, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: complete_container, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var width_next_level = NSLayoutConstraint(item: next_level, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: complete_container, attribute: NSLayoutAttribute.Width, multiplier: 0.85, constant: 0.0);
        
        complete_container.addSubview(next_level);
        complete_container.addConstraint(centery_next_level);
        complete_container.addConstraint(centerx_next_level);
        complete_container.addConstraint(width_next_level);
    }
    func bring_down_window()
    {
        for(var i = 0; i < complete_container.subviews.count; ++i)
        {
            complete_container.subviews[i].removeFromSuperview();
        }
        complete_container.removeFromSuperview();
    }
}


