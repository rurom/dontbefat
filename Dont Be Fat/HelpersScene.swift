//
//  User.swift
//  Dont Be Fat
//
//  Created by Roman on 6/23/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//
import SpriteKit
import UIKit
import FBSDKLoginKit
import Firebase

class HelpersScene:SKScene {
    

    struct getValues {
        
        func firebaseValues() {
            
            // adding a reference to our firebase database
            let ref = FIRDatabase.database().reference(fromURL: "https://dont-be-fat-a6f79.firebaseio.com/")
            
            if let user = FIRAuth.auth()?.currentUser {
                let uid = user.uid
                //                    let name = user.displayName
                //                    let email = user.email
                //                    let photoUrl = user.photoURL
                
                // create a child reference - uid will let us wrap each users data in a unique user id for later reference
                let usersReference = ref.child("users").child(uid)
                
                // performing the Facebook graph request to get the user data that just logged in so we can assign this stuff to our Firebase database:
                
                FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, err) in
                    
                    if err != nil {
                        print("Failed to start graph request: ",err ?? "")
                        return
                    }
                    print(result!)
                    
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
                            print(err)
                            return
                        }
                        // no error, so it means we've saved the user into our firebase database successfully
                        print("Save the user successfully into Firebase database")
                        
                        //The url is nested 3 layers deep into the result so it's pretty messy
                        //           if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        //Download image from imageURL
                        
                        //          }
                    })
                }
            }
        }

   }//struct

}//class





