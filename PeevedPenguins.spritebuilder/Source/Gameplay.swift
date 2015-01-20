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
  var pullbackNode: CCNode!
  var mouseJointNode: CCNode!
  var mouseJoint: CCPhysicsJoint?
  
  func didLoadFromCCB() {
    userInteractionEnabled = true
    
    let level: CCNode = CCBReader.load("Levels/Level1")
    levelNode.addChild(level)
    
    pullbackNode.physicsBody.collisionMask = []
    mouseJointNode.physicsBody.collisionMask = []
    physicsNode.debugDraw = true
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    var touchLocation = touch.locationInNode(contentNode)
    
    if CGRectContainsPoint(catapultArm.boundingBox(), touchLocation) {
      mouseJointNode.position = touchLocation
      mouseJoint = CCPhysicsJoint.connectedSpringJointWithBodyA(mouseJointNode.physicsBody, bodyB: catapultArm.physicsBody, anchorA: CGPointZero, anchorB: CGPoint(x: 34, y: 138), restLength: 0, stiffness: 3000, damping: 150)
    }
  }
  
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    var touchLocation = touch.locationInNode(contentNode)
    mouseJointNode.position = touchLocation
  }
  
  override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    releaseCatapult()
  }
  
  override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    releaseCatapult()
  }
  
  func releaseCatapult() {
    if let joint = mouseJoint {
      joint.invalidate()
      mouseJoint = nil
    }
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
