//
//  CodeHistoryViewController.swift
//  AutomotiveScanTool
//
//  Created by James Hall on 11/15/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import UIKit
import Firebase
import CollapsibleTableSectionViewController

class CodeHistoryViewController: CollapsibleTableSectionViewController {

    @IBOutlet weak var cHTableView: UITableView!
    var uid: String!
    var vin: String!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cHTableView.delegate = self
        cHTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func pullHistoryCodes(){
        
        self.ref.child("users").child(self.uid).child("vehicles").child(self.vin as!
            String).child("storedCodes").observeSingleEvent(of: .value, with: { (snapshot) in
                
                
        })
    }
    
    @IBAction func cHBack(_ sender: Any) {
    
        performSegue(withIdentifier: "cHBackSegue", sender: self)
    }
}

extension CodeHistoryViewController: CollapsibleTableSectionDelegate{
    
    func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell? ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Cell Text"
        return cell
    }
    
    func numberOfSections(_ tableView: UITableView) -> Int {
        return 10
    }
    
    func collapsibleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
