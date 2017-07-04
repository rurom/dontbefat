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
var usersTop10:Array = users.reversed()

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
        
        //sort data by users highestScore, only first top 10
        FIRDatabase.database().reference().child("users").queryOrdered(byChild: "highestScore").queryLimited(toFirst: 10).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let user = User()
                
                //if you use this setter,app will crash if User class properties don't exactly match up with the firebase dictionary keys
                user.setValuesForKeys(dictionary)
                users.append(user)
                
                (DispatchQueue.main).async(execute: {
                    self.tableView.reloadData()
                })
                //                user.name = dictionary["name"] as! String
            }
        }, withCancel: nil)
        
    }//func
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //lets use a trick for now, we actually need to dequeue or cells for memory efficiency --->
//        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        
        //right solution
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        //Children sorted in ascending order, so we need to reverse for descending order
        usersTop10 = users.reversed()
        
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
