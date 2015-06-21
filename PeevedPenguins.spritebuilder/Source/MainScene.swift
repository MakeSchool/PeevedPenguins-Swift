//
//  MainScene.swift
//  PeevedPenguins
//
//  Created by Dion Larson on 1/19/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import Foundation

class MainScene: CCNode {

  func play() {
    let gameplayScene = CCBReader.loadAsScene("Gameplay")
    CCDirector.sharedDirector().presentScene(gameplayScene)
  }
  
}
