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
    
    struct getUserName {
        static var FB_USER_NAME = "???"
    }
    
    private var loginBg:SKSpriteNode?
    private var fbLoginBtn:SKSpriteNode?
    
    
    override func didMove(to view: SKView) {
        
        loginBg = childNode(withName: "loginBg") as? SKSpriteNode!
        fbLoginBtn = childNode(withName: "fbLoginBtn") as? SKSpriteNode!
        
    }
    
 
    func getFbUserData() {
        
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else
        {return}
        
        //Firebase auth
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, err) in
            if err != nil {
                print("Something went wrong with FB user: ",err ?? "")
                return
            }
            print("SUCCESSFULLY login with user: ",user ?? "")
            return
        })
        
        //Facebook auth
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request: ",err ?? "")
                return
            }
            print(result!)
            guard let data = result as? [String:Any] else { return }
            
            getUserName.FB_USER_NAME = data["name"] as! String
            //let facebookID:String? = data["id"]! as? String
            //let userEmail:String? = data["email"]! as? String
        }
    }
    
    //Custom Facebook login
    func customFbLogin() {
        
        //Implemented through rootViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewController = appDelegate.window!.rootViewController
        

        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from:viewController){ (result, err) in
            if err != nil {
                print("Facebook login failed: ", err!)
                return
            }
            //print(result?.token.tokenString! as Any)
            self.getFbUserData()
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "fbLoginBtn" {
                
                customFbLogin()
                
                //Load MainMenu with small delay
                Timer.scheduledTimer(timeInterval: TimeInterval(0.9), target: self, selector: #selector(goToMainMenu), userInfo: nil, repeats: false)
               
                
            }
        }
    }
    
    //Transition to Menu Screen
    func goToMainMenu() {
        if let scene = MainMenuScene(fileNamed: "MainMenu") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(0.1)))
            
        }

    }
    
} //class

