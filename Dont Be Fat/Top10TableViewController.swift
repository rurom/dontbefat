//
//  Top10TableViewController.swift
//  Dont Be Fat
//
//  Created by Roman on 7/2/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import UIKit
import Firebase

let cellId = "CellId"
var users = [User]()
var reversedOrderedUsers:Array = users.reversed()
var userFriends = [UserFriend]()
var usersTop10 = reversedOrderedUsers.prefix(10)
var USERNAME:String?
var HIGHESTSCORE:Int?

class Top10TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //register class for right solution
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        
    }
    
 
    //fetch users from FIR DB
    func fetchUser() {
        
        //Clear array data to avoid duplication and then rewrite it
        users.removeAll()
        
        //Ordered list of users by highestScore
        Database.database().reference().child("users").queryOrdered(byChild: "highestScore").observe(.childAdded, with: { (snapshot) in
        
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let user = User()
                
                //if you use this setter,app will crash if User class properties don't exactly match up with the firebase dictionary keys, so they must match up with User class properties
                user.setValuesForKeys(dictionary)
                users.append(user)
                
                reversedOrderedUsers = users.reversed()
                usersTop10 = reversedOrderedUsers.prefix(10)
                
                (DispatchQueue.main).async(execute: {
                    self.tableView.reloadData()
                })
                //                user.name = dictionary["name"] as! String
            }
        }, withCancel: nil)
        
    }//func
    
    //fetch friendlist
    func fetchUserfriends() {
        
        //Clear array data to avoid duplication and then rewrite it
        userFriends.removeAll()
        
        let user = Auth.auth().currentUser
 
    //Ordered list of friends by id
        Database.database().reference().child("users").child((user?.uid)!).child("friends").child("data").queryOrdered(byChild: "id").observe(.childAdded, with: { (snapshot) in

        
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let userFriendId = UserFriend()
                    
                    //if you use this setter,app will crash if User class properties don't exactly match up with the firebase dictionary keys, so they must match up with User class properties
                    userFriendId.setValuesForKeys(dictionary)
                    userFriends.append(userFriendId)
                    
                
                    (DispatchQueue.main).async(execute: {
                        self.tableView.reloadData()
                    })
                    }
            }, withCancel: nil)

    }//func
    
        //prepare user data (USERNAME and HIGHESTSCORE) for filtredDict in AmongFriends
        func getUserData() {
    
            // adding a reference to firebase database
            let ref = Database.database().reference(fromURL: "https://dont-be-fat-a6f79.firebaseio.com/")
    
            // create a child reference - uid will let us wrap each users data in a unique user id for later reference
            let uid = Auth.auth().currentUser?.uid
            let usersReference = ref.child("users").child(uid!)
    
            usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
    
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    HIGHESTSCORE = (dictionary ["highestScore"] as? Int)!
                    USERNAME = dictionary ["name"] as? String
                }
            })
        }


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersTop10.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //right solution
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        //Children sorted in ascending order, so we need to reverse for descending order
        reversedOrderedUsers = users.reversed()
        
        let user = usersTop10[indexPath.row]
        
        //Print user name and highest score
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = String(user.highestScore)
        
        return cell
    }
    

}//class

//custom cell for right solution
class UserCell:UITableViewCell {
    
    override init(style:UITableViewCellStyle, reuseIdentifier:String?){
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
