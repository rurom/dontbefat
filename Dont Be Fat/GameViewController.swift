//
//  GameViewController.swift
//  Dont Be Fat
//
//  Created by Roman on 5/7/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import FBSDKCoreKit


class GameViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let view = self.view as! SKView? {
            
            if(FBSDKAccessToken.current() != nil) {
                //User are logged in so show another view
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    // Present the scene
                    view.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime)))}
            } else {
                //User need to log in
                
                // Load the SKScene from 'GameScene.sks'
                if let scene = LoginScene(fileNamed: "Login") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
            }
            
            }
            view.ignoresSiblingOrder = true
            
            view.showsPhysics = false
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
