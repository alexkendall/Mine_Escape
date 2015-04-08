//
//  menu.swift
//  MineEscape
//
//  Created by Alex Harrison on 3/28/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//

import UIKit

class level_button:UIButton
{
    var level:Int;
    var progress:Int;
    var level_status_indicator = Array<UIView>();
    override init()
    {
        self.level = 0;
        self.progress = 0;
        super.init();
    }
    required init(coder aDecoder: NSCoder) {
        self.level = 0;
        self.progress = 0;
        super.init();
    }
    override init(frame: CGRect) {
        self.level = 0;
        self.progress = 0;
        super.init(frame: frame);
    }
    init(in_level:Int, in_progress:Int)
    {
        self.level = in_level;
        self.progress = in_progress;
        super.init();
    }
    func update_progress()
    {
        for(var i = 0; i < level_status_indicator.count; ++i)
        {
            level_status_indicator[i].backgroundColor = UIColor.orangeColor();
            level_status_indicator[i].layer.borderWidth = 0.5;
        }
    }
}

class LevelMenu
{
    var buttons:Array<level_button> = Array<level_button>();
    var tabs = Array<UILabel>();
    var background = UIView();
    var scroll_view = UIScrollView();
    
    func removeMenu()
    {
        for(var i = 0; i < buttons.count; ++i)
        {
            buttons[i].removeFromSuperview();
        }
        buttons.removeAll(keepCapacity: true);
        for(var i = 0; i < tabs.count; ++i)
        {
            tabs[i].removeFromSuperview();
        }
        tabs.removeAll(keepCapacity: true);
        
        background.removeFromSuperview();
        
        
    }
    
    func createMenu()
    {
        // configure scroll view to encapsulate levels
        
        // configure constraints
        var scroll_width = NSLayoutConstraint(item: scroll_view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        
        var scroll_height = NSLayoutConstraint(item: scroll_view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        
        var scroll_center_x = NSLayoutConstraint(item: scroll_view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var scroll_center_y = NSLayoutConstraint(item: scroll_view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        
        // configure hiearchy
        scroll_view.setTranslatesAutoresizingMaskIntoConstraints(false);
        super_view.addSubview(scroll_view);
        super_view.addConstraint(scroll_width);
        super_view.addConstraint(scroll_height);
        super_view.addConstraint(scroll_center_x);
        super_view.addConstraint(scroll_center_y);
        
        
        background.setTranslatesAutoresizingMaskIntoConstraints(false);
        background.backgroundColor = LIGHT_BLUE;
        
        var width = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: scroll_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        
        var height = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: scroll_view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        
        var center_x = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: scroll_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var center_y = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: scroll_view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        
        scroll_view.addSubview(background);
        super_view.addConstraint(width);
        super_view.addConstraint(height);
        super_view.addConstraint(center_x);
        super_view.addConstraint(center_y);
        
        for(var i = 0; i < 3; ++i)
        {
            var difficulty_bar:UILabel = UILabel();
            difficulty_bar.backgroundColor = UIColor.blackColor();
            difficulty_bar.setTranslatesAutoresizingMaskIntoConstraints(false);
            
            difficulty_bar.text = String(format: "%iX%i", 4 + i, 4 + i);
            difficulty_bar.textAlignment = NSTextAlignment.Center;
            difficulty_bar.textColor = UIColor.whiteColor();
            
            super_view.addSubview(difficulty_bar);
            tabs.append(difficulty_bar);
            
            var constant:CGFloat = super_view.bounds.height / 3.0;
            var tab_height:CGFloat = 30.0;
            
            var width = NSLayoutConstraint(item: difficulty_bar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
            
            var height = NSLayoutConstraint(item: difficulty_bar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: difficulty_bar, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -tab_height);
            
            var center_x = NSLayoutConstraint(item: difficulty_bar, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
            
            var center_y = NSLayoutConstraint(item: difficulty_bar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: constant * CGFloat(i));
            
            super_view.addConstraint(width);
            super_view.addConstraint(height);
            super_view.addConstraint(center_x);
            super_view.addConstraint(center_y);
            
            let num_rows = 3;
            let num_cols = 5;
            let num_sections = 3;
            let levels_per_sec = num_rows * num_cols;
            
            for(var row = 0; row < num_rows; ++row)
            {
                for(var col = 0; col < num_cols; ++col)
                {
                    var level:Int = (i * levels_per_sec) + (row * num_cols) + col;
                    var subview = level_button(in_level: (num_cols * row) + col, in_progress: 0);
                    subview.backgroundColor = LIGHT_BLUE;
                    subview.setTranslatesAutoresizingMaskIntoConstraints(false);
                    subview.layer.borderWidth = 1.0;
                    subview.setTitle(String(level), forState: UIControlState.Normal);
                    subview.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
                    var sub_height = ((super_view.bounds.height / CGFloat(num_sections)) - tab_height) / CGFloat(num_rows);
                    var sub_width = super_view.bounds.width / CGFloat(num_cols);
                    
                    var center_y_const = tab_height + (sub_height * 0.5) + (sub_height * CGFloat(row)) + (super_view.bounds.height / 3.0 * CGFloat(i));
                    var center_x_const = (sub_width * 0.5) + (sub_width * CGFloat(col));
                    
                    var width_sub_constr = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0 / CGFloat(num_cols), constant: 0.0);
                    
                    var sub_height_constr = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -sub_height);
                    
                    var center_y_constr = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: center_y_const);
                    
                    var center_x_constr = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: center_x_const);
                    
                    super_view.addSubview(subview);
                    buttons.append(subview);
                    super_view.addConstraint(width_sub_constr);
                    super_view.addConstraint(sub_height_constr);
                    super_view.addConstraint(center_y_constr);
                    super_view.addConstraint(center_x_constr);
                    
                    for(var j = 0; j < 3; ++j)  // generate status
                    {
                        var level_status = UIView();
                        level_status.setTranslatesAutoresizingMaskIntoConstraints(false);
                        level_status.backgroundColor = UIColor.clearColor();
                        
                        var left_const = super_view.frame.width / CGFloat(num_cols) / 3.0 * CGFloat(j);
                        
                        var status_height_constr = NSLayoutConstraint(item: level_status, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: NSLayoutAttribute.Height, multiplier: 0.15, constant: 0.0);
                        
                        var status_width_constr = NSLayoutConstraint(item: level_status, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: NSLayoutAttribute.Width, multiplier: 1.0 / 3.0, constant: 0.0);

                        var status_left = NSLayoutConstraint(item: level_status, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: left_const);
                        
                        var status_bottom = NSLayoutConstraint(item: level_status, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0);
                        
                        subview.addSubview(level_status);
                        subview.addConstraint(status_left);
                        subview.addConstraint(status_bottom);
                        subview.addConstraint(status_height_constr);
                        subview.addConstraint(status_width_constr);
                        subview.level_status_indicator.append(level_status);
                    }
                }
            }
        }
        for(var i = 0; i < levels_completed.count; ++i)
        {
            buttons[levels_completed[i]].update_progress();
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
        background.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        
        // generate constraints for background
        var width = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        
        var height = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        
        var centerx = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var centery = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        super_view.addSubview(background);
        super_view.addConstraint(width);
        super_view.addConstraint(height);
        super_view.addConstraint(centerx);
        super_view.addConstraint(centery);
        
        // set up gradiant
        var gradient = CAGradientLayer();
        gradient.frame = super_view.bounds;
        gradient.locations = locations;
        gradient.colors = colors;
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0);
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0);
        background.layer.insertSublayer(gradient, atIndex: 0);
        
        // insert title
        var baseline:CGFloat = 150.0;
        var title_label = UILabel();
        title_label.setTranslatesAutoresizingMaskIntoConstraints(false);
        title_label.text = title;
        title_label.textColor = UIColor.orangeColor();
        title_label.font = UIFont(name: "Arial", size: 40.0);
        
        var center_title = NSLayoutConstraint(item: title_label, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var dist_from_top = NSLayoutConstraint(item: title_label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: baseline);
        
        background.addSubview(title_label);
        background.addConstraint(center_title);
        background.addConstraint(dist_from_top);
        
       
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
        
        background.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        // generate constraints for background
        var width = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        
        var height = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        
        var centerx = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var centery = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        super_view.addSubview(background);
        super_view.addConstraint(width);
        super_view.addConstraint(height);
        super_view.addConstraint(centerx);
        super_view.addConstraint(centery);
        
        // set up gradiant
        var colors = [UIColor.blackColor().CGColor, LIGHT_BLUE.CGColor];
        var locations = [0, 1];
        
        var gradient = CAGradientLayer();
        gradient.frame = super_view.bounds;
        gradient.locations = locations;
        gradient.colors = colors;
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0);
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0);
        background.layer.insertSublayer(gradient, atIndex: 0);

        super_view.addSubview(background);
        super_view.addConstraint(width);
        super_view.addConstraint(height);
        super_view.addConstraint(centerx);
        super_view.addConstraint(centery);
        
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
        back_button = UIButton();
        back_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        var left_back = NSLayoutConstraint(item: back_button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 30.0);
        var down_back = NSLayoutConstraint(item: back_button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -25.0);
        
        // organize hiearchy
        background.addSubview(back_button);
        background.addConstraint(left_back);
        background.addConstraint(down_back);
        
        back_button.setTitle("BACK", forState: UIControlState.Normal);
        back_button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted);
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
    var text = "code written by Alex Harrison\n" + "co-produced by Jai Koh\n" + "email: alexkendall.harrison@Gmail.com\n";
    var text_view = UITextView();
    var back_button = UIButton();
    
    func bring_up()
    {
        
        background.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        // generate constraints for background
        var width = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        
        var height = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        
        var centerx = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var centery = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        super_view.addSubview(background);
        super_view.addConstraint(width);
        super_view.addConstraint(height);
        super_view.addConstraint(centerx);
        super_view.addConstraint(centery);
        
        // set up gradiant
        var colors = [UIColor.blackColor().CGColor, LIGHT_BLUE.CGColor];
        var locations = [0, 1];
        
        var gradient = CAGradientLayer();
        gradient.frame = super_view.bounds;
        gradient.locations = locations;
        gradient.colors = colors;
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0);
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0);
        background.layer.insertSublayer(gradient, atIndex: 0);
        
        super_view.addSubview(background);
        super_view.addConstraint(width);
        super_view.addConstraint(height);
        super_view.addConstraint(centerx);
        super_view.addConstraint(centery);
        
        var baseline_height:CGFloat = 75.0;
        var seperation:CGFloat = 50.0;
        
        // generate constraints for text_view
        var width_tv = NSLayoutConstraint(item: text_view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Width, multiplier: 0.90, constant: 0.0);
        
        var height_tv = NSLayoutConstraint(item: text_view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Height, multiplier: 0.90, constant: 0.0);
        
        var centerx_tv = NSLayoutConstraint(item: text_view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var centery_tv = NSLayoutConstraint(item: text_view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: baseline_height + seperation);
        
        // generate title subview
        
        var title = UILabel();
        title.setTranslatesAutoresizingMaskIntoConstraints(false);
        var centerx_title = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        var centery_title = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: baseline_height);
        
        // configure title subview
        title.text = "About";
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
        text_view.font = UIFont(name: "Arial", size: 18.0);
        text_view.editable = false;
        
        
        // organize hiearchy
        background.addSubview(text_view);
        background.addConstraint(width_tv);
        background.addConstraint(height_tv);
        background.addConstraint(centerx_tv);
        background.addConstraint(centery_tv);
        
        // create back button
        back_button = UIButton();
        back_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        var left_back = NSLayoutConstraint(item: back_button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 30.0);
        var down_back = NSLayoutConstraint(item: back_button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -25.0);
        
        // organize hiearchy
        background.addSubview(back_button);
        background.addConstraint(left_back);
        background.addConstraint(down_back);
        
        back_button.setTitle("BACK", forState: UIControlState.Normal);
        back_button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted);
    }
    func pull_down()
    {
        while(background.subviews.count > 0)
        {
            background.subviews.first?.removeFromSuperview();
        }
    }
}

class settingsWondow
{
    var background = UIView();
    var back_button = UIButton();
    var volume_slider = UISlider();
    var volume_label = UILabel();
    
    func bring_up()
    {
        
        background.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        // generate constraints for background
        var width = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        
        var height = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        
        var centerx = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var centery = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        super_view.addSubview(background);
        super_view.addConstraint(width);
        super_view.addConstraint(height);
        super_view.addConstraint(centerx);
        super_view.addConstraint(centery);
        
        // set up gradiant
        var colors = [UIColor.blackColor().CGColor, LIGHT_BLUE.CGColor];
        var locations = [0, 1];
        
        var gradient = CAGradientLayer();
        gradient.frame = super_view.bounds;
        gradient.locations = locations;
        gradient.colors = colors;
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0);
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0);
        background.layer.insertSublayer(gradient, atIndex: 0);
        
        super_view.addSubview(background);
        super_view.addConstraint(width);
        super_view.addConstraint(height);
        super_view.addConstraint(centerx);
        super_view.addConstraint(centery);
        
        var baseline_height:CGFloat = 75.0;
        var seperation:CGFloat = 50.0;
        
        // generate title subview
        
        var title = UILabel();
        title.setTranslatesAutoresizingMaskIntoConstraints(false);
        var centerx_title = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        var centery_title = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: baseline_height);
        
        // configure title subview
        title.text = "VOLUME";
        title.textColor = UIColor.orangeColor();
        title.font = UIFont(name: "Arial", size: 30.0);
        
        // organize heiarchy
        background.addSubview(title);
        background.addConstraint(centerx_title);
        background.addConstraint(centery_title);
        
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
        
        // create back button
        back_button = UIButton();
        back_button.setTranslatesAutoresizingMaskIntoConstraints(false);
        var left_back = NSLayoutConstraint(item: back_button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 30.0);
        var down_back = NSLayoutConstraint(item: back_button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: background, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -25.0);
        
        // organize hiearchy
        background.addSubview(back_button);
        background.addConstraint(left_back);
        background.addConstraint(down_back);
        
        back_button.setTitle("BACK", forState: UIControlState.Normal);
        back_button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted);
    }
    func pull_down()
    {
        while(background.subviews.count > 0)
        {
            background.subviews.first?.removeFromSuperview();
        }
    }

}