//
//  ViewController.swift
//  DynamicDemo
//
//  Created by akhil mantha on 16/06/17.
//  Copyright © 2017 akhil mantha. All rights reserved.
//

import UIKit
protocol UIDynamicItem : NSObjectProtocol {
    var center : CGPoint {get set}
    var bound : CGRect{get }
    var transform : CGAffineTransform{get set}
}

class ViewController: UIViewController ,UICollisionBehaviorDelegate{
    
    var animator : UIDynamicAnimator!
    var gravity : UIGravityBehavior!
    var collision : UICollisionBehavior!
    var firstContact = false
    var square : UIView!
    var snap : UISnapBehavior!
    
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        print("boundary contact occured at \(identifier)")
        let collidingView = item as! UIView
        collidingView.backgroundColor = UIColor.yellowColor()
        UIView.animateWithDuration(0.3) {
            collidingView.backgroundColor = UIColor.grayColor()
            
        }
        if(!firstContact){
            firstContact = true
            
            let square = UIView(frame: CGRect(x: 30, y: 0, width: 100, height: 100))
            square.backgroundColor = UIColor.blueColor()
            view.addSubview(square)
            
            collision.addItem(square)
            let attach = UIAttachmentBehavior(item: collidingView, attachedToItem: square)
            animator.addBehavior(attach)
        }
    }

    
        override func viewDidLoad() {
        super.viewDidLoad()
        //collision.collisionDelegate = self
        square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        square.backgroundColor = UIColor.grayColor()
        view.addSubview(square)
        animator = UIDynamicAnimator(referenceView : view)
        let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        barrier.backgroundColor = UIColor.redColor()
        view.addSubview(barrier)        // for gravity
        gravity = UIGravityBehavior(items: [square])
        animator.addBehavior(gravity)
        // for collision
        collision = UICollisionBehavior(items: [square])
        collision.addBoundaryWithIdentifier("barrier", forPath : UIBezierPath(rect: barrier.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        collision.action = {
            print("\(NSStringFromCGAffineTransform(self.square.transform)) \(NSStringFromCGPoint(self.square.center))")
        self.collision.collisionDelegate = self
        let itemBehavior = UIDynamicItemBehavior(items: [self.square])
        itemBehavior.elasticity = 0.6
        self.animator.addBehavior(itemBehavior)
        }
            
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

