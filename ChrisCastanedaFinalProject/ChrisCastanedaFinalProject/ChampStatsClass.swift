//
//  ChampStatsClass.swift
//  GG EZ
//
//  Created by Chris Castaneda on 5/14/15.
//  Copyright (c) 2015 Chris Castaneda. All rights reserved.
//

import UIKit

class ChampStatsClass {
    var health: Double;
    var healthRegen: Double;
    var mana: Double;
    var manaRegen: Double;
    var attackDamage: Double;
    var attackSpeed: Double;
    var armor: Double;
    var magicResist: Double;
    var moveSpeed: Double;
    
    init (stats: [Double]) {
        health = stats[0];
        healthRegen = stats[1];
        mana = stats[2];
        manaRegen = stats[3];
        attackDamage = stats[4];
        attackSpeed = Double(round(1000*(0.625/(1 - stats[5])))/1000); // Double(round(1000*(0.625/(1 - stats[5])))/1000)
        armor = stats[6];
        magicResist = stats[7];
        moveSpeed = stats[8];
    }
}
