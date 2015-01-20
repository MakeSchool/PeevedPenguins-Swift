//
//  Gameplay.swift
//  PeevedPenguins
//
//  Created by Dion Larson on 1/20/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import Foundation

class Gameplay: CCNode {
  
  var physicsNode: CCPhysicsNode!
  var contentNode: CCNode!
  var catapultArm: CCNode!
  var levelNode: CCNode!
  
  func didLoadFromCCB() {
    userInteractionEnabled = true
    
    let level: CCNode = CCBReader.load("Levels/Level1")
    levelNode.addChild(level)
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    launchPenguin()
  }
  
  func launchPenguin() {
    // TODO: Check if explicit type is still needed for code completion
    let penguin: Penguin = CCBReader.load("Penguin") as Penguin
    penguin.position = ccpAdd(catapultArm.position, CGPoint(x: 16, y: 50))
    
    physicsNode.addChild(penguin)
    
    let launchDirection = CGPoint(x: 1, y: 0)
    let force = ccpMult(launchDirection, 8000)
    penguin.physicsBody.applyForce(force)
    
    position = CGPointZero
    let followAction = CCActionFollow(target: penguin, worldBoundary: boundingBox())
    contentNode.runAction(followAction)
  }
  
  func retry() {
    let gameplayScene: CCScene = CCBReader.loadAsScene("Gameplay")
    CCDirector.sharedDirector().replaceScene(gameplayScene)
  }
  
}
