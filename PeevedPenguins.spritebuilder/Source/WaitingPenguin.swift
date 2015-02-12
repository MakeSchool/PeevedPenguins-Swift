//
//  WaitingPenguin.swift
//  PeevedPenguins
//
//  Created by Dion Larson on 2/12/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

class WaitingPenguin: CCSprite {
  func didLoadFromCCB() {
    // generate a random number between 0.0 and 2.0
    var delay = CCRANDOM_0_1() * 2
    // call method to start animation after random delay
    self.scheduleOnce("startBlinkAndJump", delay: CCTime(delay))
  }
  
  func startBlinkAndJump() {
    self.animationManager.runAnimationsForSequenceNamed("BlinkAndJump")
  }
}
