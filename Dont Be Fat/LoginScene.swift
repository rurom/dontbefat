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
import FirebaseAuth
import FirebaseDatabase


class LoginScene: SKScene {
    
    struct getUserData {
        static var FB_USER_NAME = ""
    }
    
    private var loginBg:SKSpriteNode?
    private var fbLoginBtn:SKSpriteNode?

    
    override func didMove(to view: SKView) {
        
        loginBg = childNode(withName: "loginBg") as? SKSpriteNode!
        fbLoginBtn = childNode(withName: "fbLoginBtn") as? SKSpriteNode!
        
    }
    
    func customFbLoginSaveUserIntoFIB() {
        
        //Implemented through rootViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewController = appDelegate.window!.rootViewController
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from:viewController){ (result, err) in
            if err != nil {
                print("Facebook login failed:", err ?? "")
            } else if (result?.isCancelled)! {
                print("The user cancelled login")
            } else {
                print(result ?? "")
                
                // No error, No cancelling:
                // using the FBAccessToken, we get a Firebase token
                let accessToken = FBSDKAccessToken.current()
                guard let accessTokenString = accessToken?.tokenString else
                {return}
                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
                
                // using the credentials above, sign in to FIREBASE to create a user session
                FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
                    if error != nil {
                        print("Something went wrong with FB user: ", error ?? "")
                        return
                    } else { //succesfully Auth Firebase without error
                        
                        // adding a reference to firebase database
                        let ref = FIRDatabase.database().reference(fromURL: "https://dont-be-fat-a6f79.firebaseio.com/")
                        
                        // create a child reference - uid will let us wrap each users data in a unique user id for later reference
                        let uid = FIRAuth.auth()?.currentUser?.uid
                        let usersReference = ref.child("users").child(uid!)
                        
                        // checking for existing user
                        ref.child("users").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                            print(snapshot)
                            
                            if FIRAuth.auth()?.currentUser == nil {
                                print("no user logged in")
                            } else if FIRAuth.auth()?.currentUser!.uid == nil {
                                print("no user id value")
                            } else if snapshot.hasChild((FIRAuth.auth()!.currentUser!.uid)){
                                
                                print("This user already exist")

                                    print("SUCCESSFULLY login with user: ", user ?? "")

                            } else  {
                                
                                // performing the Facebook graph request to get the user data that just logged in so we can assign this stuff to Firebase database
                                FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, err) in
                                    if err != nil {
                                        print("Failed to start graph request: ",err ?? "")
                                        return
                                    }
                            
                                    guard let userInfo = result as? [String:Any] else { return }
                                    
                                    // Facebook user name:
                                    let userName = userInfo["name"] as! String
                                    LoginScene.getUserData.FB_USER_NAME = userName
                                    print("User Name is: \(userName)")
                                    
                                    // Facebook user email:
                                    let userEmail:String? = userInfo["email"] as? String
                                    print("User Email is: ", userEmail ?? "noEmail")
                                    
                                    // Facebook user ID:
                                    let fbUserID:String? = userInfo["id"]! as? String
                                    print("Users Facebook ID is:", fbUserID ?? "noId")
                                    
                                    //Best score of current user
                                    let bestScore:String = (String(GameplayScene.playerScoreData.highestPlayerScore))
                                    print("Users best score is: \(bestScore)")
                                    
                                    let values = ["name": userName, "email": userEmail, "facebookID": fbUserID, "highestScore":bestScore]
                                    
                                    // update our databse by using the child database reference above called usersReference
                                    usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                        // if there's an error in saving to our firebase database
                                        if err != nil {
                                            print(err ?? "")
                                            return
                                        }
                                        // no error, so it means we've saved the user into our firebase database successfully
                                        print("SUCCESSFULLY login with user: ", user ?? "")
                                        print("Save the user successfully into Firebase database")
                                    })
                                }
                            }
                        })
                        return //succesfully Auth Firebase without error
                    
                    }
                })
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    for touch in touches {
        let location = touch.location(in: self)
        if atPoint(location).name == "fbLoginBtn" {
            customFbLoginSaveUserIntoFIB()
            //Load MainMenu with small delay
            Timer.scheduledTimer(timeInterval: TimeInterval(0.9), target: self, selector: #selector(goToMainMenu), userInfo: nil, repeats: false)
                fbLoginBtn?.isHidden = true
                            }
                        }
                    }
//Transition to Menu Screen
    func goToMainMenu() {
        if let scene = MainMenuScene(fileNamed: "MainMenu") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(0.1)))}
    }
                    
} //class
