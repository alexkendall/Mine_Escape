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
    for(var i = 0; i < 8; ++i)
    {
        levels.append(Level(in_level: i, in_speed: 8, in_policy: MINE_POLICY.MIXED, in_dimension: 3));
    }
    for(var i = 8; i < 16; ++i)
    {
        levels.append(Level(in_level: i, in_speed: 6, in_policy: MINE_POLICY.MIXED, in_dimension: 5));
    }
    for(var i = 16; i < 24; ++i)
    {
        levels.append(Level(in_level: i, in_speed: 3, in_policy: MINE_POLICY.MIXED, in_dimension: 7));
    }
}



