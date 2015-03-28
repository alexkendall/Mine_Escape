//
//  menu.swift
//  MineEscape
//
//  Created by Alex Harrison on 3/28/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//

import UIKit

class menu_button:UIButton
{
    var level:Int;
    var progress:Int;
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
}

class Menu
{
    var buttons:Array<menu_button> = Array<menu_button>();
    var tabs = Array<UILabel>();
    var background = UIView();
    init()
    {
        
    }
    func createMenu()
    {
        background.setTranslatesAutoresizingMaskIntoConstraints(false);
        background.backgroundColor = LIGHT_BLUE;
        
        var width = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        
        var height = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        
        var center_x = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0);
        
        var center_y = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0);
        
        super_view.addSubview(background);
        super_view.addConstraint(width);
        super_view.addConstraint(height);
        super_view.addConstraint(center_x);
        super_view.addConstraint(center_y);
        
        for(var i = 0; i < 3; ++i)
        {
            var difficulty_bar:UILabel = UILabel();
            difficulty_bar.backgroundColor = UIColor.blackColor();
            difficulty_bar.layer.borderWidth = 1.0;
            difficulty_bar.setTranslatesAutoresizingMaskIntoConstraints(false);
            
            difficulty_bar.text = String(format: "%iX%i", 3 + (i * 2), 3 + (i * 2));
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
            
            let num_rows = 2;
            let num_cols = 4;
            let num_sections = 3;
            
            for(var row = 0; row < num_rows; ++row)
            {
                for(var col = 0; col < num_cols; ++col)
                {
                    var level:Int = (row * num_cols) + col + 1;
                    var subview = menu_button();
                    subview.backgroundColor = LIGHT_BLUE;
                    subview.setTranslatesAutoresizingMaskIntoConstraints(false);
                    subview.layer.borderWidth = 1.0;
                    subview.setTitle(String(level), forState: UIControlState.Normal);
                    subview.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
                    var sub_height = ((super_view.bounds.height / 3.0) - tab_height) / 2.0;
                    var sub_width = super_view.bounds.width / 4.0;
                    
                    var center_y_const = tab_height + (sub_height * 0.5) + (sub_height * CGFloat(row)) + (super_view.bounds.height / 3.0 * CGFloat(i));
                    var center_x_const = (sub_width * 0.5) + (sub_width * CGFloat(col));
                    
                    var width_sub_constr = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Width, multiplier: 0.25, constant: 0.0);
                    
                    var sub_height_constr = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -sub_height);
                    
                    var center_y_constr = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: center_y_const);
                    
                    var center_x_constr = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: super_view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: center_x_const);
                    
                    super_view.addSubview(subview);
                    super_view.addConstraint(width_sub_constr);
                    super_view.addConstraint(sub_height_constr);
                    super_view.addConstraint(center_y_constr);
                    super_view.addConstraint(center_x_constr);
                    
                    
                }
            }
        }
        
    }
}
