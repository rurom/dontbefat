//
//  SettingsScene.swift
//  Dont Be Fat
//
//  Created by Roman on 6/20/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import SpriteKit
import FBSDKLoginKit
import Firebase
import UIKit

class SettingsScene: SKScene {
    
    private var fbLogoutBtn:SKSpriteNode?
    private var backToMenu:SKSpriteNode?
    private var highestScoreLbl: SKLabelNode?
    private var playerNameLbl: SKLabelNode?
    private var highestScore:Int = 0
    private var PLAYERNAME:String?
    private var txtHighestScoreLbl:SKLabelNode?
    
    
    override func didMove(to view: SKView) {
        
       //ActivityIndicator for preloading data from Firebase DB
        let activityInd = UIActivityIndicatorView()
        activityInd.color = UIColor.black
        let transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        activityInd.transform = transform
        activityInd.center = CGPoint(x:view.bounds.midX, y:view.bounds.midY)
        activityInd.layer.zPosition = 6
        activityInd.startAnimating()
        scene!.view?.addSubview(activityInd)
        
        
        fbLogoutBtn = childNode(withName: "fbLogoutBtn") as? SKSpriteNode!
        backToMenu = childNode(withName: "backToMenuBtn") as? SKSpriteNode!
        highestScoreLbl = childNode(withName: "highestScoreLbl") as? SKLabelNode!
        playerNameLbl = childNode(withName: "playerNameLbl") as? SKLabelNode!
        txtHighestScoreLbl = childNode(withName: "txtHighestScoreLbl") as? SKLabelNode!
        
        playerNameLbl?.isHidden = true
        highestScoreLbl?.isHidden = true
        playerNameLbl?.isHidden = true
        txtHighestScoreLbl?.isHidden = true
        
        // adding a reference to firebase database
        let ref = FIRDatabase.database().reference(fromURL: "https://dont-be-fat-a6f79.firebaseio.com/")
        // create a child reference - uid will let us wrap each users data in a unique user id for later reference
        let uid = FIRAuth.auth()?.currentUser?.uid
        let usersReference = ref.child("users").child(uid!)
        
        usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String:AnyObject] {
                self.highestScore = (dictionary ["highestScore"] as? Int)!
                self.PLAYERNAME = dictionary ["name"] as? String
                print(self.highestScore)
            }
            //Scaling userName font size depending on length
            let playerLblRect = CGRect(x: -235, y: 265, width:(self.frame.width) - 10, height: 50)
            
            self.highestScoreLbl?.text = String(self.highestScore)
            self.playerNameLbl?.text = self.PLAYERNAME
            self.adjustLabelFontSizeToFit(labelNode: self.playerNameLbl!, rect:playerLblRect)
            
            activityInd.stopAnimating()
            self.playerNameLbl?.isHidden = false
            self.highestScoreLbl?.isHidden = false
            self.playerNameLbl?.isHidden = false
            self.txtHighestScoreLbl?.isHidden = false
        })
    }


    
    //Custom Facebook and Firebase logout
    func customFbFirLogout() {
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        FBSDKLoginManager().logOut()
        print("Successfully logout Facebook!")
        
        do {
        try FIRAuth.auth()?.signOut()
            print("Successfully logout Firebase!")
        } catch let logoutError {
            print(logoutError)
        }
        LoginScene.getUserData.FB_USER_NAME = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "fbLogoutBtn" {
                customFbFirLogout()
                if let scene = LoginScene(fileNamed: "Login") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime)))
                }
                
                
            } else if atPoint(location).name == "backToMenuBtn" {
                
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime))) }
            }
        }
    }
    
    func adjustLabelFontSizeToFit(labelNode:SKLabelNode, rect:CGRect) {
        
        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)
        
        // Change the fontSize.
        labelNode.fontSize *= scalingFactor
        
        // Optionally move the SKLabelNode to the center of the rectangle.
        labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
    }
    
} //class
