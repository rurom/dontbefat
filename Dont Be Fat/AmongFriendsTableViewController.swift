//
//  AmongFriendsTableViewController.swift
//  Dont Be Fat
//
//  Created by Roman on 7/2/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import UIKit
import Firebase

struct firUserData {
    var id: String?
    var name: String?
    var highestScore: Int?
    
    var dictRepresent: [String: Any] {
        return [
            "userId" : id ?? "",
            "name" : name ?? "",
            "highestScore" : highestScore ?? ""
        ]
    }
    
   }

struct fbFriendScore {
    
    var name: String
    var highestScore: Int
    
    var dictRepresent: [String: Any] {
        return [
            "name" : name,
            "highestScore" : highestScore
        ]
    }
    
}

struct fbFriendUserId {
    var id: String
    
    var dictRepresent: [String: Any] {
        return [
            "userId" : id,
        ]
    }
}

let cellId2 = "CellId2"

private var firUserDataDict = [String:Any]()
private var fbFriendIdDict = [String:Any]()
private var fbFriendScoreDict = [String:Any]()
private var firUserDataArr = [[String:Any]]()
private var userFriendsIdArr = [[String:Any]]()
private var fbFriendScoreArr = [[String:Any]]()
private var filtredDict = [String:Int]()
var friendsScoresArr = [FriendScore]()


class AmongFriendsTableViewController: UITableViewController {

    override func viewDidLoad() {
            super.viewDidLoad()
        
            //register class for right solution
            tableView.register(UserCell.self, forCellReuseIdentifier: cellId2)
        
        }
    
    //Display friends scores
    func userfriendsScore() {
        
        //Clear arrays and dict's data to avoid duplication and then rewrite them
        
        //Clear dict and arrays from prepareUserData() to avoid duplication
        firUserDataDict.removeAll()
        firUserDataArr.removeAll()
        fbFriendIdDict.removeAll()
        userFriendsIdArr.removeAll()
        
        //Clear dict and arrays from compareAndMerge() to avoid duplication
        filtredDict.removeAll()
        fbFriendScoreDict.removeAll()
        fbFriendScoreArr.removeAll()
        friendsScoresArr.removeAll()
      
        prepareUserData()
        
        print(firUserDataArr)
        print(userFriendsIdArr)
        
        compareAndMerge()
        }

    
    //In result we get 2 prepared arrays for further comparison: firUserDataArr - with all users data, userFriendsIdArr - with friends id data
    func prepareUserData() {
        
        //Loop through each user in users array and construct new dictionary using firUserData struct firUserDataDict, then append it to firUserDataArr
        for user in users {
            
            let userData = firUserData(id: user.facebookID, name: user.name, highestScore: user.highestScore)
            
            firUserDataDict = userData.dictRepresent
            
            firUserDataArr.append(firUserDataDict)
        }
        
        //Loop through fiends id's in userFriends array and construct new dictionary using fbFriendUserId struct fbFriendIdDict, then append it to userFriendsIdArr
        for userFriend in userFriends {
            
            let friendFbId = fbFriendUserId(id: userFriend.id!)
            
            fbFriendIdDict = friendFbId.dictRepresent
            
            userFriendsIdArr.append(fbFriendIdDict)
        }
        
    }
    
    
    //In result we get constructed array with keys for TableView
    func compareAndMerge() {
        
                //firUserDataArr filtred by "userId", if "userId" matches with user friend "userId", we add it into new filtredDict(!better add it straight away into array with "name" and "highestScore" keys, but for now i have no idea how filter and map it properly!)
                
                firUserDataArr.forEach({ name in
                    userFriendsIdArr.forEach({
                        if name["userId"] as? String == $0["userId"] as? String { filtredDict[name["name"] as! String ] = name["highestScore"] as? Int }
                    })
                })
                print(filtredDict)
                print(USERNAME as Any, HIGHESTSCORE as Any)
        filtredDict.updateValue(HIGHESTSCORE!, forKey: USERNAME!)
        
                print(filtredDict)
        

        //sort the filtredDict
        let keyValueArray = filtredDict.sorted { $0.1 != $1.1 ? $0.1 > $1.1 : $0.0 < $1.0 }
        print(keyValueArray)
    
        
                //Loop trough filtredDict and construct new dictionary (with necessary keys for FriendScore class) using fbFriendScore struct fbFriendScoreDict, then append it to fbFriendScoreArr
                for every in keyValueArray {
                    let data = fbFriendScore(name: every.key, highestScore: every.value)
                    fbFriendScoreDict = data.dictRepresent
                    fbFriendScoreArr.append(fbFriendScoreDict)
                }
                print (fbFriendScoreArr)
                
                //Loop trough fbFriendScoreArr, each element of array make as dictionary, then setValuesForKeys into FriendScore class, then append friendScore to friendsScoresArr and reload tableView data
                for res in fbFriendScoreArr {
                    if let dictionary = res as? [String:Any] {
                        let friendScore = FriendScore()
                        
                        friendScore.setValuesForKeys(dictionary)
                        friendsScoresArr.append(friendScore)
                        
                        (DispatchQueue.main).async(execute: {
                            self.tableView.reloadData()
                        })
                    }
                }
                
            }

    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(friendsScoresArr.count)
            return friendsScoresArr.count
        }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            //right solution
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath)
            
            let fScore = friendsScoresArr[indexPath.row]
            
            //Print user name and highest score
            cell.textLabel?.text = fScore.name
            cell.detailTextLabel?.text = String(describing: fScore.highestScore)
            
            return cell
            
        }
        
    }//class

