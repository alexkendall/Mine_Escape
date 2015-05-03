//
//  menu.swift
//  MineEscape
//
//  Created by Alex Harrison on 3/28/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//

import UIKit

var EASY = "EASY", MEDIUM = "MEDIUM", HARD = "HARD", INSANE = "INSANE", IMPOSSIBLE = "IMPOSSIBLE";
var DIFFICULTY:[String] = [EASY, MEDIUM, HARD, INSANE, IMPOSSIBLE];


class level_button:UIButton
{
    var difficulty:String;
    var level:Int;
    var progress:Int;
    var level_status_indicator = Array<UIView>();
    init()
    {
        self.level = 0;
        self.progress = 0;
        self.difficulty = EASY;
        super.init(frame:CGRectZero);
    }
    required init(coder aDecoder: NSCoder) {
        self.level = 0;
        self.progress = 0;
        self.difficulty = EASY;
        super.init(frame:CGRectZero);
    }
    override init(frame: CGRect) {
        self.level = 0;
        self.progress = 0;
        self.difficulty = EASY;
        super.init(frame: frame);
    }
    init(in_level:Int, in_progress:Int, in_difficulty:String)
    {
        self.difficulty = in_difficulty;
        self.level = in_level;
        self.progress = in_progress;
        super.init(frame:CGRectZero);
        self.level = in_level;
    }
    func update_progress()
    {
        var color = UIColor.clearColor();
        if(progress == 3)
        {
            color = UIColor.greenColor();
        }
        else if(progress == 2)
        {
            color = UIColor.yellowColor();
        }
        else if(progress == 1)
        {
            color = UIColor.redColor();
        }
        for(var i = 0; i < progress; ++i)
        {
            level_status_indicator[i].backgroundColor = color;
            level_status_indicator[i].layer.borderWidth = 0.5;
        }
    }
}

class Main_menu
{
    var background = UIView();
    var menu_options = ["free play","about", "how to play", "settings"];
    var colors = [UIColor.blackColor().CGColor, LIGHT_BLUE.CGColor];
    var locations = [0, 1];
    var title = "MINE ESCAPE";
    var level_buttons = Array<UIButton>();
    
    func remove_main_menu()
    {
        while(background.subviews.count > 0)
        {
            background.subviews[0].removeFromSuperview();
        }
        for(var i = 0; i < level_buttons.count; ++i)
        {
            level_buttons[i].removeFromSuperview();
        }
        background.removeFromSuperview();
        level_buttons.removeAll(keepCapacity: true);
    }
    
    
    func show_main_menu()
    {
        configure_gradient(&background, UIColor.blackColor(), LIGHT_BLUE)
        background.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        // insert title
        var baseline:CGFloat = 150.0;
        var title = UILabel();
        add_title_button(&title, &background, "MINE ESCAPE", baseline, 40.0);
        
        // add the menu buttons
        for(var i = 0; i < menu_options.count; ++i)
        {
            var increment = (baseline * 1.75) + (50.0 * CGFloat(i));
            
            // set button attributes
            var level_button = UIButton();
            level_button.titleLabel?.font = UIFont(name: "Arial", size: 25.0);
            level_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
            level_button.setTranslatesAutoresizingMaskIntoConstraints(false);
            level_button.setTitle(menu_options[i], forState: UIControlState.Normal);
            level_buttons.append(level_button);
            // set button constraints
            var center_mb_x = NSLayoutConstraint(item: level_button, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
            
            var bottom_x = NSLayoutConstraint(item: level_button, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: increment);
            
            // organize hiearchy
            background.addSubview(level_button);
            background.addConstraint(center_mb_x);
            background.addConstraint(bottom_x);
        }
        var subview:UIView = UIView();
        subview.backgroundColor = UIColor.blackColor();
    }
}

class HowToScreen
{
    var background = UIView();
    var text = "Click all squares that do not contain mines." + " As you explore more squares, more mines will appear." +
        " But beware, mines disappear  after a short amount of time. Red mines will be visible longer than blue mines." +
    " You win once all squares not containing mines are explored.";
    var text_view = UITextView();
    var back_button = UIButton();
    
    func bring_up()
    {
        configure_gradient(&background, UIColor.blackColor(), LIGHT_BLUE);
        
        var baseline_height:CGFloat = 75.0;
        var seperation:CGFloat = 50.0;
        
        // generate constraints for text_view
        var width_tv = NSLayoutConstraint(item: text_view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Width, multiplier: 0.75, constant: 0.0);
        
        var height_tv = NSLayoutConstraint(item: text_view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Height, multiplier: 0.75, constant: 0.0);
        
        var centerx_tv = NSLayoutConstraint(item: text_view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var centery_tv = NSLayoutConstraint(item: text_view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: baseline_height + seperation);
        
        // generate title subview
        
        var title = UILabel();
        title.setTranslatesAutoresizingMaskIntoConstraints(false);
        var centerx_title = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        var centery_title = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: baseline_height);
        
        // configure title subview
        title.text = "How to Play";
        title.textColor = UIColor.orangeColor();
        title.font = UIFont(name: "Arial", size: 30.0);
        
        
        // organize heiarchy
        background.addSubview(title);
        background.addConstraint(centerx_title);
        background.addConstraint(centery_title);
        
        // configure text view
        text_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        text_view.frame = super_view.bounds;
        text_view.text = text;
        text_view.textAlignment = NSTextAlignment.Left;
        text_view.textColor = UIColor.whiteColor();
        text_view.backgroundColor = UIColor.clearColor();
        text_view.font = UIFont(name: "Arial", size: 25.0);
        text_view.editable = false;
        
        
        // organize hiearchy
        background.addSubview(text_view);
        background.addConstraint(width_tv);
        background.addConstraint(height_tv);
        background.addConstraint(centerx_tv);
        background.addConstraint(centery_tv);
        
        // create back button
        add_back_button(&back_button, &background);
    }
    func pull_down()
    {
        while(background.subviews.count > 0)
        {
            background.subviews.first?.removeFromSuperview();
        }
    }
}

class aboutWindow
{
    var background = UIView();
    var text = "code written by Alex Harrison\n" + "alexharr@umich.edu\n" + "alexkendall.harrison@Gmail.com\n";
    var text_view = UITextView();
    var back_button = UIButton();
    
    func bring_up()
    {
        configure_gradient(&background, UIColor.blackColor(), LIGHT_BLUE);
        
        var baseline_height:CGFloat = 75.0;
        var seperation:CGFloat = 50.0;
        
        // generate constraints for text_view
        var width_tv = NSLayoutConstraint(item: text_view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Width, multiplier: 0.90, constant: 0.0);
        
        var height_tv = NSLayoutConstraint(item: text_view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Height, multiplier: 0.90, constant: 0.0);
        
        var centerx_tv = NSLayoutConstraint(item: text_view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var centery_tv = NSLayoutConstraint(item: text_view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: baseline_height + seperation);
        
        // generate title subview
        var title = UILabel();
        add_title_button(&title, &background, "ABOUT", baseline_height, 30.0);
        
        // configure text view
        text_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        text_view.frame = super_view.bounds;
        text_view.text = text;
        text_view.textAlignment = NSTextAlignment.Left;
        text_view.textColor = UIColor.whiteColor();
        text_view.backgroundColor = UIColor.clearColor();
        text_view.font = UIFont(name: "Arial", size: 18.0);
        text_view.editable = false;
        
        
        // organize hiearchy
        background.addSubview(text_view);
        background.addConstraint(width_tv);
        background.addConstraint(height_tv);
        background.addConstraint(centerx_tv);
        background.addConstraint(centery_tv);
        
        // create back button
        add_back_button(&back_button, &background);
    }
    func pull_down()
    {
        while(background.subviews.count > 0)
        {
            background.subviews.first?.removeFromSuperview();
        }
    }
}

class settingsWindow
{
    var background = UIView();
    var back_button = UIButton();
    var volume_slider = UISlider();
    var volume_label = UILabel();
    
    func bring_up()
    {
        configure_gradient(&background, UIColor.blackColor(), LIGHT_BLUE);
        
        var baseline_height:CGFloat = 75.0;
        var seperation:CGFloat = 50.0;
        
        // generate title subview
        
        var title = UILabel();
        add_title_button(&title, &background, "VOLUME", baseline_height, 30.0);
        
        // configure volume slider
        volume_slider.setTranslatesAutoresizingMaskIntoConstraints(false);
        volume_slider.maximumValue = 1.0;
        volume_slider.minimumValue = 0.0;
        volume_slider.maximumTrackTintColor = LIGHT_BLUE;
        volume_slider.minimumTrackTintColor = UIColor.orangeColor();
        volume_slider.setValue(VOLUME_LEVEL, animated: false);
        
        var width_slider = NSLayoutConstraint(item: volume_slider, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 0.75, constant: 0.0);
        
        var height_slider = NSLayoutConstraint(item: volume_slider, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: volume_slider, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -40.0);
        
        var centerx_slider = NSLayoutConstraint(item: volume_slider, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var centery_slider = NSLayoutConstraint(item: volume_slider, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        // organize hiearchy
        super_view.addSubview(volume_slider);
        super_view.addConstraint(width_slider);
        super_view.addConstraint(height_slider);
        super_view.addConstraint(centerx_slider);
        super_view.addConstraint(centery_slider);
        
        
        // configure volume label
        volume_label.setTranslatesAutoresizingMaskIntoConstraints(false);
        volume_label.backgroundColor = UIColor.orangeColor();
        volume_label.layer.borderWidth = 2.0;
        volume_label.layer.borderColor = UIColor.whiteColor().CGColor;
        volume_label.text = String(Int(100.0 * VOLUME_LEVEL));
        volume_label.textColor = UIColor.whiteColor();
        volume_label.textAlignment = NSTextAlignment.Center;
        volume_label.font = UIFont(name: "Arial", size: 30.0);
        
        var width_label = NSLayoutConstraint(item: volume_label, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 0.30, constant: 0.0);
        
        var height_label = NSLayoutConstraint(item: volume_label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Height, multiplier: 0.2, constant: -10.0);
        
        var centerx_label = NSLayoutConstraint(item: volume_label, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var centery_label = NSLayoutConstraint(item: volume_label, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: volume_slider, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -30.0);
        
        super_view.addSubview(volume_label);
        super_view.addConstraint(width_label);
        super_view.addConstraint(height_label);
        super_view.addConstraint(centerx_label);
        super_view.addConstraint(centery_label);
        
        add_back_button(&back_button, &background);
    }
    func pull_down()
    {
        while(background.subviews.count > 0)
        {
            background.subviews.first?.removeFromSuperview();
        }
    }
}

// Class that displays each level and allows users to scroll and pick particular levels. Also indicates progress of each level.
class LevelMenu
{
    var NUM_MEGA_LEVELS = 5;    // 4X4, 5X5, 6X6, 7X7, 8X8
    var NUM_SUB_LEVELS = 25;     // 16 sublevels per megalevel
    var scroll_view = UIScrollView();
    var level_buttons = Array<level_button>();
    var background = UIView();
    var tabs = Array<UILabel>();
    var back_button = UIButton();
    var title = UILabel();
    
    
    func removeMenu()
    {
        for(var i = 0; i < level_buttons.count; ++i)
        {
            level_buttons[i].removeFromSuperview();
        }
        level_buttons.removeAll(keepCapacity: true);
        for(var i = 0; i < tabs.count; ++i)
        {
            tabs[i].removeFromSuperview();
        }
        tabs.removeAll(keepCapacity: true);
        background.removeFromSuperview();
    }
    
    func createMenu()
    {
        configure_gradient(&background, UIColor.blackColor(), LIGHT_BLUE);
        
        // configure scroll view
        var scroll_mult:CGFloat = 0.9;
        
        var scroll_width = NSLayoutConstraint(item: scroll_view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Width, multiplier: scroll_mult, constant: 0.0);
        
        var scroll_height = NSLayoutConstraint(item: scroll_view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Height, multiplier: 0.8, constant: 0.0);
        
        var scroll_centerx = NSLayoutConstraint(item: scroll_view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var scroll_centery = NSLayoutConstraint(item: scroll_view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        
        
        scroll_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        scroll_view.backgroundColor = UIColor.clearColor();
        scroll_view.layer.borderColor = UIColor.whiteColor().CGColor;
        scroll_view.layer.borderWidth = 1.0;
        scroll_view.frame = super_view.bounds;
        super_view.addSubview(scroll_view);
        super_view.addConstraint(scroll_width);
        super_view.addConstraint(scroll_height);
        super_view.addConstraint(scroll_centerx);
        super_view.addConstraint(scroll_centery);
        
        var margin:CGFloat = 40.0;
        var dimension:Int = Int(sqrt(Float(NUM_SUB_LEVELS)));
        var mega_width:CGFloat = super_view.bounds.width * scroll_mult;
        var mega_height:CGFloat = mega_width;
        var sub_height:CGFloat = mega_height / CGFloat(dimension);
        var sub_width:CGFloat = mega_width / CGFloat(dimension);
        
        scroll_view.scrollEnabled = false;
        var content_width:CGFloat = super_view.bounds.width * scroll_mult;
        var content_height:CGFloat = (mega_height * CGFloat(NUM_MEGA_LEVELS)) + (CGFloat(NUM_MEGA_LEVELS) * margin);
        
        scroll_view.contentSize = CGSize(width: super_view.bounds.width * scroll_mult, height: content_height);
        scroll_view.clipsToBounds = false;
        
        for(var i = 0; i < NUM_MEGA_LEVELS; ++i)
        {
            // configure tab properties
            var tab = UILabel();
            var current_dim = 4 + i;
            tab.backgroundColor = UIColor.whiteColor();
            tab.setTranslatesAutoresizingMaskIntoConstraints(false);
            tab.text = DIFFICULTY[i]; //+ String(format: " - %i X %i ", current_dim, current_dim);
            tab.textAlignment = NSTextAlignment.Center;
            tab.textColor = UIColor.blackColor();
            tabs.append(tab);
            
            // configure constraints
            var baseline = ((margin + mega_height) * CGFloat(i));
            
            var tab_x = NSLayoutConstraint(item:tab, attribute: NSLayoutAttribute.CenterX , relatedBy: NSLayoutRelation.Equal, toItem: scroll_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
            
            var tab_y = NSLayoutConstraint(item:tab, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scroll_view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: baseline);
            
            var tab_width = NSLayoutConstraint(item:tab, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: scroll_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
            
            var tab_height = NSLayoutConstraint(item:tab, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: tab, attribute: NSLayoutAttribute.Height, multiplier: 0, constant: margin);
            
            scroll_view.clipsToBounds = true;
            scroll_view.addSubview(tab);
            scroll_view.addConstraint(tab_x);
            scroll_view.addConstraint(tab_y);
            scroll_view.addConstraint(tab_width);
            scroll_view.addConstraint(tab_height);
            
            for(var row = 0; row < dimension; ++row)
            {
                for(var col = 0; col < dimension; ++col)
                {
                    // configure level button properties
                    //var level_but:level_button = level_button(in_level: (i * (NUM_SUB_LEVELS)) + (dimension * row) + col, in_progress: 0);
                    var level_but:level_button = level_button(in_level: (row * dimension) + col + 1, in_progress: 0, in_difficulty:DIFFICULTY[i]);
                    level_but.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75);
                    level_but.layer.borderWidth = 1.0;
                    level_but.layer.borderColor = UIColor.whiteColor().CGColor;
                    level_but.clipsToBounds = false;
                    level_but.setTranslatesAutoresizingMaskIntoConstraints(false);
                    level_but.setTitle(String(level_but.level), forState: UIControlState.Normal);
                    
                    
                    var baseline = margin + ((margin + mega_height) * CGFloat(i)) + (CGFloat(row) * sub_height);
                    
                    var level_center_x = NSLayoutConstraint(item:level_but, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scroll_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: CGFloat(col) * sub_width);
                    
                    var level_center_y = NSLayoutConstraint(item:level_but, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scroll_view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: baseline);
                    
                    var level_width = NSLayoutConstraint(item:level_but, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: scroll_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0 / CGFloat(dimension), constant: 0.0);
                    
                    var level_height = NSLayoutConstraint(item:level_but, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: scroll_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0 / CGFloat(dimension), constant: 0.0);
                    
                    scroll_view.addSubview(level_but);
                    scroll_view.addConstraint(level_center_x);
                    scroll_view.addConstraint(level_center_y);
                    scroll_view.addConstraint(level_width);
                    scroll_view.addConstraint(level_height);
                    level_buttons.append(level_but);
                    
                    for(var j = 0; j < 3; ++j)  // generate status
                    {
                        var level_status = UIView();
                        level_status.setTranslatesAutoresizingMaskIntoConstraints(false);
                        level_status.backgroundColor = UIColor.clearColor();
                        
                        //var num_cols = 5.0;
                        var width:CGFloat = super_view.frame.width * scroll_mult / 5.0 / 3.0;
                        
                        var status_height_constr = NSLayoutConstraint(item: level_status, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: level_but, attribute: NSLayoutAttribute.Height, multiplier: 0.15, constant: 0.0);
                        
                        var status_width_constr = NSLayoutConstraint(item: level_status, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: level_but, attribute: NSLayoutAttribute.Width, multiplier: 1.0 / 3.0, constant: 0.0);
                        
                        var status_left = NSLayoutConstraint(item: level_status, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: level_but, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: width * CGFloat(j));
                        
                        var status_bottom = NSLayoutConstraint(item: level_status, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: level_but, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0);
                        
                        level_but.addSubview(level_status);
                        level_but.addConstraint(status_left);
                        level_but.addConstraint(status_bottom);
                        level_but.addConstraint(status_height_constr);
                        level_but.addConstraint(status_width_constr);
                        level_but.level_status_indicator.append(level_status);
                    }
                }
            }
            
        }
        for(var i = 0; i < levels.count; ++i)
        {
            level_buttons[i].progress = levels[i].progress;
            level_buttons[i].difficulty = levels[i].difficulty;
            level_buttons[i].update_progress();
        }
        add_back_button(&back_button, &background);
        add_title_button(&title, &background, "Levels", 15.0, 30.0);
        scroll_view.scrollEnabled = true;
    }
}
