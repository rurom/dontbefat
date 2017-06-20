//
//  LoginScene.swift
//  Dont Be Fat
//
//  Created by Roman on 6/13/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//
import Foundation
import UIKit
import SpriteKit
import FBSDKLoginKit
import Firebase


class LoginScene: SKScene {
    
    private var loginBg:SKSpriteNode?
    private var fbLoginBtn:SKSpriteNode?
    
    
    override func didMove(to view: SKView) {
        
        loginBg = childNode(withName: "loginBg") as? SKSpriteNode!
        fbLoginBtn = childNode(withName: "fbLoginBtn") as? SKSpriteNode!
        
    }
    
 
    func showEmail() {
        
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else
        {return}
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, err) in
            if err != nil {
                print("Something went wrong with FB user: ",err ?? "")
                return
            }
            print("SUCCESSFULLY login with user: ",user ?? "")
            return
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request: ",err ?? "")
                return
            }
            print(result ?? "")
        }
    }
    
    
    
    //Facebook logout
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton) {
//        print("Did logout of Facebook!")
//    }
    
    //Custom Facebook login
    func customFbLogin() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewController = appDelegate.window!.rootViewController
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from:viewController){ (result, err) in
            if err != nil {
                print("Facebook login failed: ", err!)
                return
            }
            //print(result?.token.tokenString! as Any)
            self.showEmail()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "fbLoginBtn" {
                customFbLogin()
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(1)))
                }
            }
        }
    }
    
} //class

