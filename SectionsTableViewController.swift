//
//  SectionsTableViewController.swift
//  NEA4
//
//  Created by Chris Wang on 1/21/17.
//  Copyright © 2017 Chris Wang. All rights reserved.
//

import UIKit
import Firebase

var sections: [Section] = SectionsData().getSectionsFromData()

class SectionsData {
    
    func getSectionsFromData() -> [Section] {
        
        // Will be replaced with a database fetch request
        var sectionsArray = [Section]()
        let friends = Section(title: "Friends", objects: ["Alice", "Bob", "Carol", "Dan", "Eve"])
        let otherUsers = Section(title: "Other Users", objects: ["User X", "User Y", "User Z"])
        
        sectionsArray.append(friends)
        sectionsArray.append(otherUsers)
        
        return sectionsArray
    }
}

class SectionsTableViewController: UITableViewController {
    
    // Initialize Firebase Database
    var ref = FIRDatabase.database().reference(withPath: "dining-hall-app")
    
    @IBAction func checkIn(_ sender: Any) {
        print("Checkeddin")
        
        // Retreive this person's name

        
        ref.child("users").child(Constants.currentUserID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let nameOfUser = value?["name"] as? String ?? "1"
            
            // Add this person to a list of all the people at a certain dining hall
            self.ref.child(Constants.eatingEstablishmentThatWasSelected).child(Constants.currentUserID!).setValue(["name" : nameOfUser])
        })
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Constants.eatingEstablishmentThatWasSelected
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].heading
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        //cell.textLabel?.text = Friends[indexPath.row]
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
        return cell
    }
}
