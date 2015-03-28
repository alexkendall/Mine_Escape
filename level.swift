//
//  level.swift
//  MineEscape
//
//  Created by Alex Harrison on 3/28/15.
//  Copyright (c) 2015 Alex Harrison. All rights reserved.
//

import UIKit
enum MINE_POLICY{case LOCAL, GLOBAL, MIXED};

class Level:UIButton
{
    var level:Int;
    var speed:Int;
    var policy:MINE_POLICY;
    override init()
    {
        self.level = 0;
        self.speed = 0;
        self.policy = MINE_POLICY.LOCAL;
        
        super.init();
    }
    required init(coder aDecoder: NSCoder) {
        self.level = 0;
        self.speed = 0;
        self.policy = MINE_POLICY.LOCAL;
        super.init();
    }
    override init(frame: CGRect) {
        self.level = 0;
        self.speed = 0;
        self.policy = MINE_POLICY.LOCAL;
        super.init();
    }
    init(in_level:Int, in_speed:Int, in_policy:MINE_POLICY)
    {
        self.level = in_level;
        self.speed = in_speed;
        self.policy = in_policy;
        super.init();
    }
}