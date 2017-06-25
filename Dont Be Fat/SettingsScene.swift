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

class SettingsScene: SKScene {
    
    private var fbLogoutBtn:SKSpriteNode?
    private var backToMenu:SKSpriteNode?
    private var highestScoreLbl: SKLabelNode?
    private var playerNameLbl: SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        fbLogoutBtn = childNode(withName: "fbLogoutBtn") as? SKSpriteNode!
        backToMenu = childNode(withName: "backToMenuBtn") as? SKSpriteNode!
        highestScoreLbl = childNode(withName: "highestScoreLbl") as? SKLabelNode!
        playerNameLbl = childNode(withName: "playerNameLbl") as? SKLabelNode!
        
        highestScoreLbl?.text = String(GameplayScene.playerScoreData.highestPlayerScore)

        //Scaling userName font size depending on length
        let playerLblRect = CGRect(x: -235, y: 265, width:(scene?.frame.width)! - 10, height: 50)
        
        playerNameLbl?.text = String(LoginScene.getUserData.FB_USER_NAME)
        //Test for userName font scale "Abduhalabab El Khadi Khacheridi Ahmedopakistan", "Cho Po"
        
        adjustLabelFontSizeToFit(labelNode: playerNameLbl!, rect:playerLblRect)
    
    }
    
    //Custom Facebook and Firebase logout
    func customFbFirLogout() {
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
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(1)))
                }
                
                
            } else if atPoint(location).name == "backToMenuBtn" {
                
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(1))) }
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
