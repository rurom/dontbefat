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
    private var profilePictureURL:String?
    private var loadingLbl:SKLabelNode?
    private let top10View = Top10TableViewController()
    
    override func didMove(to view: SKView) {
        
        loginBg = childNode(withName: "loginBg") as? SKSpriteNode!
        fbLoginBtn = childNode(withName: "fbLoginBtn") as? SKSpriteNode!
        loadingLbl = childNode(withName: "loadingLbl") as? SKLabelNode!
        loadingLbl?.isHidden = true
        
    }
    
    func customFbLoginSaveUserIntoFIB() {
        
        //Implemented through rootViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewController = appDelegate.window!.rootViewController
            
            FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from:viewController){ (result, err) in
                if err != nil {
                    print("Facebook login failed:", err ?? "")
                    
                    self.goToLoginScene()
                    
                    //Alert Pop-up - An error happened
                    let alertController = UIAlertController(title: "", message: "Facebook login canceled!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                    
                } else if (result?.isCancelled)! {
                    print("The user cancelled login!")
                    
                    self.goToLoginScene()
                    
                    //Alert Pop-up - user cancelled login
                    let alertController = UIAlertController(title: "", message: "The user cancelled login!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                } else {
                    
                    print(result ?? "")
                    
       
                    //Preloader, activity indicator and label
                    let activityInd = UIActivityIndicatorView()
                    activityInd.color = UIColor.black
                    let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    activityInd.transform = transform
                    activityInd.center = CGPoint(x:(self.view?.bounds.midX)!, y:(self.view?.bounds.midY)!)
                    activityInd.layer.zPosition = 6
                    activityInd.startAnimating()
                    self.view?.addSubview(activityInd)
                    self.loadingLbl?.isHidden = false

        
                    // No error, No cancelling:
                    // using the FBAccessToken, we get a Firebase token
                    let accessToken = FBSDKAccessToken.current()
                    guard let accessTokenString = accessToken?.tokenString else
                    {return}
                    let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
                    
                    // using the credentials above, sign in to FIREBASE to create a user session
                    Auth.auth().signIn(with: credentials, completion: { (user, error) in
                        if error != nil {
                            print("Something went wrong with FB user: ", error ?? "")
                            return
                        } else { //succesfully Auth Firebase without error
                            
                            // adding a reference to firebase database
                            let ref = Database.database().reference(fromURL: "https://dont-be-fat-a6f79.firebaseio.com/")
                            
                            // create a child reference - uid will let us wrap each users data in a unique user id for later reference
                            let uid = Auth.auth().currentUser?.uid
                            let usersReference = ref.child("users").child(uid!)
                            
                            // checking for existing user
                            ref.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                                //print(snapshot)
                                
                                if Auth.auth().currentUser == nil {
                                    print("no user logged in")
                                } else if Auth.auth().currentUser!.uid == nil {
                                    print("no user id value")
                                } else if snapshot.hasChild((Auth.auth().currentUser!.uid)){
                                    
                                    print("This user already exist")
                                    
                                    //Rewrite users data
                                    FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"name, email, picture.width(150).height(150), friends.limit(5000)"]).start { (connection, result, err) in
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
                                        
                                        //Fb friends of user in app
                                        let userFriends = userInfo["friends"] as? NSDictionary
                                        print("User friend list: \(userFriends)")
                                        
                                        //User profile picture
                                        let userPicUrl = userInfo["picture"] as! NSDictionary!
                                        print("User profile picture URL: \(userPicUrl)")
                                        
                                        
                                        
                                        if let dict = userPicUrl {
                                            if let data = dict["data"] as? [String:Any] {
                                                if let urlData = data["url"] as? String {
                                                    print("The FCKNG URL is:\(urlData)")
                                                    self.profilePictureURL = urlData
                                                    
                                                    if let picUrl = NSURL(string: urlData as String) {
                                                        if let data = NSData(contentsOf: picUrl as URL) {
                                                            //Set the user profile picture for Settings scene
                                                            SettingsScene.profilePic = UIImage(data: data as Data)
                                                            print(SettingsScene.profilePic)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        let values = ["name": userName, "email": userEmail, "friends": userFriends, "profilePictureURL":self.profilePictureURL] as [String : Any]
                                        
                                        // update our databse by using the child database reference above called usersReference
                                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                            // if there's an error in saving to our firebase database
                                            if err != nil {
                                                print(err ?? "")
                                                return
                                            }
                                            // no error, so it means we've saved the user into our firebase database successfully
                                            print("SUCCESSFULLY login with user: ", user ?? "")
                                            print("Successfully rewrited user data in Firebase database")
                                        })
                                    } //FBSDKGraphRequest
                                    
                                    
                                } else {
                                    
                                    
                                    // performing the Facebook graph request to get the user data that just logged in so we can assign this stuff to Firebase database
                                    
                                    //For field 'picture': type must be one of the following values: small, normal, album, large, square"
                                    
                                    FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email, picture.width(150).height(150), friends.limit(5000)"]).start { (connection, result, err) in
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
                                        let bestScore:Int = GameplayScene.playerScoreData.highestPlayerScore
                                        print("Users best score is: \(bestScore)")
                                        
                                        //Fb friends of user in app
                                        let userFriends = userInfo["friends"] as? NSDictionary
                                        print("User friend list: \(userFriends)")
                                        
                                        //User profile picture
                                        let userPicUrl = userInfo["picture"] as? NSDictionary
                                        print("User profile picture URL: \(userPicUrl)")
                                        
                                        if let dict = userPicUrl {
                                            if let data = dict["data"] as? [String:Any] {
                                                if let urlData = data["url"] as? String {
                                                    print("The FCKNG URL is:\(urlData)")
                                                    self.profilePictureURL = urlData
                                                    
                                                    if let picUrl = NSURL(string: urlData as String) {
                                                        if let data = NSData(contentsOf: picUrl as URL) {
                                                            //Set the user profile picture for Settings scene
                                                            SettingsScene.profilePic = UIImage(data: data as Data)
                                                            print(SettingsScene.profilePic)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        let values = ["name": userName, "email": userEmail, "facebookID": fbUserID, "highestScore":bestScore, "friends": userFriends, "profilePictureURL": self.profilePictureURL] as [String : Any]
                                        
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
                                    } //FBSDKGraphRequest
                                }
                            })
                            //preparing data for top10 highescores table
                            self.top10View.fetchUser()
                            
                            self.loadingLbl?.isHidden = true
                            activityInd.stopAnimating()
                            self.goToMainMenu()
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
            self.fbLoginBtn?.isHidden = true
            internetReachability()
                            }
                        }
                    }
    
//Transition to Menu Screen
    func goToMainMenu() {
        self.fbLoginBtn?.isHidden = true
        
        if let scene = MainMenuScene(fileNamed: "MainMenu") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime)))}
    }
    
    //Check the internet reachability for login
    func internetReachability () {
        
        let reachability =  InternetReachability()!
                //reachability.isReachable is deprecated, right solution --> connection != .none
                if reachability.connection != .none {
                    //reachability.isReachableViaWiFi is deprecated, right solution --> connection == .wifi
                    if reachability.connection == .wifi {
                        DispatchQueue.main.async {
                            
                            print("Internet via WIFI is OK!")
                            self.customFbLoginSaveUserIntoFIB()
                        }
        
                    } else {
                        DispatchQueue.main.async {
            
                            print("Internet via Cellular is OK!")
                            self.customFbLoginSaveUserIntoFIB()
                        }
                    }
                } else {
                    self.fbLoginBtn?.isHidden = false
                    print("Please check your Internet connection!")
                    inetAlert()
        }
    }
        
        func inetAlert() {
            //Alert Pop-up no internet connection
            let alertController = UIAlertController(title: "", message: "Please, check your internet connection", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            
        }
    
    func goToLoginScene() {
        if let scene = LoginScene(fileNamed: "Login") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            self.view!.presentScene(scene, transition:SKTransition.crossFade(withDuration: TimeInterval(transitionTime))) }
    }
    
    
} //class
