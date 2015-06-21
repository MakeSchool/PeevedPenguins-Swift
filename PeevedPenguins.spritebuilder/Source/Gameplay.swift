//
//  Gameplay.swift
//  PeevedPenguins
//
//  Created by Dion Larson on 1/20/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import Foundation

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
  
  let minSpeed = CGFloat(5)
  
  weak var gamePhysicsNode: CCPhysicsNode!
  weak var contentNode: CCNode!
  weak var catapultArm: CCNode!
  weak var levelNode: CCNode!
  weak var pullbackNode: CCNode!
  weak var mouseJointNode: CCNode!
  var mouseJoint: CCPhysicsJoint?
  var currentPenguin: Penguin?
  var followAction: CCActionFollow?
  var penguinCatapultJoint: CCPhysicsJoint?
  
  func didLoadFromCCB() {
    userInteractionEnabled = true
    
    let level = CCBReader.load("Levels/Level1")
    levelNode.addChild(level)
    
    pullbackNode.physicsBody.collisionMask = []
    mouseJointNode.physicsBody.collisionMask = []
    gamePhysicsNode.collisionDelegate = self
  }
  
  override func update(delta: CCTime) {
    if let penguin = currentPenguin {
      if penguin.launched {
        if ccpLength(penguin.physicsBody.velocity) < minSpeed {
          nextAttempt()
          return
        }
        
        var xMin = penguin.boundingBox().origin.x
        
        if (xMin < boundingBox().origin.x) {
          nextAttempt()
          return
        }
        
        var xMax = xMin + penguin.boundingBox().size.width
        
        if xMax > (boundingBox().origin.x + boundingBox().size.width) {
          nextAttempt()
          return
        }
      }
    }
  }
  
  func nextAttempt() {
    currentPenguin = nil
    contentNode.stopAction(followAction)
    
    var actionMoveTo = CCActionMoveTo(duration: 1, position: CGPointZero)
    contentNode.runAction(actionMoveTo)
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    var touchLocation = touch.locationInNode(contentNode)
    
    if CGRectContainsPoint(catapultArm.boundingBox(), touchLocation) {
      mouseJointNode.position = touchLocation
      mouseJoint = CCPhysicsJoint.connectedSpringJointWithBodyA(mouseJointNode.physicsBody, bodyB: catapultArm.physicsBody, anchorA: CGPointZero, anchorB: CGPoint(x: 34, y: 138), restLength: 0, stiffness: 3000, damping: 150)
      
      currentPenguin = CCBReader.load("Penguin") as! Penguin?
      var penguinPosition = catapultArm.convertToWorldSpace(CGPoint(x: 34, y: 138))
      currentPenguin?.position = gamePhysicsNode.convertToNodeSpace(penguinPosition)
      gamePhysicsNode.addChild(currentPenguin!)
      currentPenguin?.physicsBody.allowsRotation = false
      
      penguinCatapultJoint = CCPhysicsJoint.connectedPivotJointWithBodyA(currentPenguin!.physicsBody, bodyB: catapultArm.physicsBody, anchorA: currentPenguin!.anchorPointInPoints)
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
      
      penguinCatapultJoint?.invalidate()
      penguinCatapultJoint = nil
      
      currentPenguin?.physicsBody.allowsRotation = true
      currentPenguin?.launched = true
      
      followAction = CCActionFollow(target: currentPenguin, worldBoundary: boundingBox())
      contentNode.runAction(followAction)
    }
  }
  
  func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, seal: Seal!, wildcard: CCNode!) {
    var energy = pair.totalKineticEnergy
    
    if energy > 5000 {
      gamePhysicsNode.space.addPostStepBlock({ () -> Void in
          self.sealRemoved(seal)
      }, key: seal)
    }
  }
  
  func sealRemoved(seal: Seal) {
    // load particle effect
    var explosion = CCBReader.load("SealExplosion") as! CCParticleSystem
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = true;
    // place the particle effect on the seals position
    explosion.position = seal.position;
    // add the particle effect to the same node the seal is on
    seal.parent.addChild(explosion)
    // finally, remove the seal from the level
    seal.removeFromParent()
  }
  
  func retry() {
    let gameplayScene = CCBReader.loadAsScene("Gameplay")
    CCDirector.sharedDirector().presentScene(gameplayScene)
  }
  
}
