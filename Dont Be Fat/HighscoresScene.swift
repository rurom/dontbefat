//
//  HighscoresScene.swift
//  Dont Be Fat
//
//  Created by Roman on 6/10/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import SpriteKit
import UIKit

private var backToMenu: SKSpriteNode?
private var shareApp: SKSpriteNode?
private let top10View = Top10TableViewController()
private let amongFriendsView = AmongFriendsTableViewController()
private var noFriendsImgView = UIImageView()

let topScoresSegmentedControl:UISegmentedControl = {
    let sc = UISegmentedControl(items:["Top 10", "Among friends"])
    sc.translatesAutoresizingMaskIntoConstraints = false
    sc.selectedSegmentIndex = 0
    sc.layer.cornerRadius = 5.0
    sc.backgroundColor = UIColor.black
    sc.tintColor = UIColor.white
    
    sc.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Phosphate-Inline", size: 14.0)! ], for: .normal)
    
    return sc
}()

class HighscoresScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        backToMenu = childNode(withName: "backToMenuBtn") as? SKSpriteNode
        
        view.addSubview(topScoresSegmentedControl)
        topScoresSegmentedControl.isHidden = false
        top10View.view.isHidden = false
        
        topScoresSegmentedControl.selectedSegmentIndex = 0
        if topScoresSegmentedControl.selectedSegmentIndex == 0 {
            
            handleTop10 ()
        }
  
        setupScConstraints()
        
        // Add target action method
        topScoresSegmentedControl.addTarget(self, action: #selector(scChanged), for: .valueChanged)
    }
    
    // x, y, width, height constraints for all iPhone's
    func setupScConstraints() {
        let horizontalConstraint = NSLayoutConstraint(item: topScoresSegmentedControl, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: (view?.frame.width)! * 0.11)
        let verticalConstraint = NSLayoutConstraint(item: topScoresSegmentedControl, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: (((view?.frame.height)!/2)-22) * -1)
        let widthConstraint = NSLayoutConstraint(item: topScoresSegmentedControl, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (view?.frame.width)! * 0.75)
        let heightConstraint = NSLayoutConstraint(item: topScoresSegmentedControl, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 37)
        
        view?.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    
    //Handler for Segmented Control
    @objc func scChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 1:
            print("2 screen")
            handleAmongFriends()
            top10View.view.isHidden = true
            amongFriendsView.view.isHidden = false
//        case 2:
//            print("3 screen")
        default:
            print("1 screen")
            handleTop10 ()
            top10View.view.isHidden = false
            amongFriendsView.view.isHidden = true
            noFriendsImgView.isHidden = true
            break
        }
    }
    
    
    //set rect and add subview for top10TableViewController
    func handleTop10 () {
        
        top10View.fetchUser()
        top10View.fetchUserfriends()
        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let smallerRect = CGRect(x: 0, y: 47, width: (view?.frame.width)!, height:(view?.frame.height)! * 0.8 )
        top10View.view.frame = smallerRect
        view?.addSubview(top10View.view)
        top10View.getUserData()
    }
    
    //set rect and add subview for AmongFriendsTableViewController
    func handleAmongFriends() {
    
        amongFriendsView.userfriendsScore()
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let smallerRect = CGRect(x: 0, y: 47, width: (view?.frame.width)!, height:(view?.frame.height)! * 0.8 )
        amongFriendsView.view.frame = smallerRect
        
        noFriendsImgView = UIImageView(frame:smallerRect)
        noFriendsImgView.image = UIImage(named: "noFriends.png")
        
        
        if let friendsCount = friendsScoresArr.count as? Int {
            if friendsCount > 0 {
                view?.addSubview(amongFriendsView.view)
//                view?.addSubview(invFriendsView.view)
            } else {
                view?.addSubview(noFriendsImgView)
            }
        }
    }
    
   func backBtnHandler() {
    
    noFriendsImgView.isHidden = true
    top10View.view.isHidden = true
    amongFriendsView.view.isHidden = true
    topScoresSegmentedControl.isHidden = true

}
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "backToMenuBtn" {
                
                backBtnHandler()
                
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(0.2)))
                }
            } else if atPoint(location).name == "shareAppBtn" {
                
//                if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)) {
//                    let socialController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//                    //            socialController.setInitialText("Hello World!")
//                    //            socialController.addImage(someUIImageInstance)
//                    //            socialController.addURL(someNSURLInstance)
//                    
//                    self.presentViewController(socialController, animated: true, completion: nil)
//                }
            }
        }
    }

} // class
