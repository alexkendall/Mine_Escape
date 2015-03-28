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
    var speed:Int;
    var policy:MINE_POLICY;
    override init()
    {
        speed = 0;
        policy = MINE_POLICY.LOCAL;
        super.init();
    }
    required init(coder aDecoder: NSCoder)
    {
        speed = 0;
        policy = MINE_POLICY.LOCAL;
        super.init();
    }
    override init(frame: CGRect)
    {
        speed = 0;
        policy = MINE_POLICY.LOCAL;
        super.init();
    }
    init(in_speed:Int, in_policy:MINE_POLICY)
    {
        speed = in_speed;
        policy = in_policy;
        super.init();
    }
}