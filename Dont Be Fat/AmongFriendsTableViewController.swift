//
//  AmongFriendsTableViewController.swift
//  Dont Be Fat
//
//  Created by Roman on 7/2/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import UIKit
import Firebase

let cell2Id = "Cell2Id"

class AmongFriendsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

            }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //lets use a trick for now, we actually need to dequeue or cells for memory efficiency
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cell2Id)
        
        cell.textLabel?.text = "Dummy FRIENDS"
        
        return cell
    }

}//class
