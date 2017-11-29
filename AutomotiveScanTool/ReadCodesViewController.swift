//
//  ReadCodesViewController.swift
//  AutomotiveScanTool
//
//  Created by Stephen Lomangino on 11/15/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import PromiseKit
import ParticleSDK



class ReadCodesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var ref: DatabaseReference!
    var uid: String!
    var vin: String!
    var deviceInfo: ParticleDevice!
    var dateString : String!
    
    var values = [String : [[String : [String]]]]()
    var cellExpanded : Bool = false
    var selectedIndexPath : IndexPath = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            values = ["Pending" : [["P1008" : ["Description", "link"]], ["P0101" : ["Description", "Link"]]],
                      "Current" : [["P2008" : ["Description", "link"]], ["P0101" : ["Description", "Link"]]],
                      "Stored" : [["P3008" : ["Description", "link"]], ["P0101" : ["Description", "Link"]]]]
            
            values["Pending"]?.append(["P2222" : ["Code Desc", "Google Link"]])
            values["Stored"]?.append(["P2222" : ["Code Desc", "Google Link"]])
            
            print("*****PRESET VALUES*****\n", values)
//            values = [String : [[String : [String]]]]()
            buildData()
            
        }
    
    func buildData() {
        self.ref.child("users").child(self.uid).child("vehicles").child(self.vin).child("storedCodes").child("11-28-17-08:11"/*self.dateString*/).observe(DataEventType.value, with: { (snapshot) in
            print("SNAPSHOT: ",snapshot)
            
            let fbSnapshot = snapshot.value as? NSDictionary
            print("fbSnapshot: ",fbSnapshot)
            
            for status in fbSnapshot! {
                print("fbsnapshot.key", status.key)
                print("fbsnapshot.value", status.value)
                var codeItems = status.value as? NSDictionary
                print("codeItems: ", codeItems)
            }
        })
    }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return getNumberOfRowsForSection(s: section)
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! StatusCell
            //        print("*****GETTING CODE TEXT***** SECTION: ", indexPath.section, "ROW: ", indexPath.row)
            cell.codeLabel.text = getCodeText(s: indexPath.section, r: indexPath.row)
            
            return cell
        }
        
        func getNumberOfRowsForSection(s: Int) -> Int {
            var counter = 0
            for section in values{
                if counter == s {
                    return section.value.count
                }
                counter += 1
            }
            return 0
        }
        
        func getCodeText(s: Int, r: Int) -> String {
            var counter = 0
            for section in values {
                for i in 0...section.value.count {
                    let row = section.value[r]
                    if (i == r && s == counter) {
                        return(row.first?.key)!
                    }
                }
                counter += 1
            }
            return ""
        }
        
        func getStatusText (index : Int) -> String {
            var counter = 0
            for section in values {
                if counter == index {
                    return section.key
                }
                counter += 1
                
            }
            return "Didnt Work"
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            //        print(values.count)
            return values.count
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return getStatusText(index: section)
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44.0;
        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
            return 0;
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            print("****SELECTED A ROW!****   ", indexPath.row)
            
            //expand selected row and collapse any other row that was previously expanded
            cellExpanded = false
            
            if (indexPath != selectedIndexPath) {
                cellExpanded = true
                selectedIndexPath = indexPath
            } else {
                selectedIndexPath = []
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if selectedIndexPath != [] {
                if (indexPath == selectedIndexPath) {
                    if cellExpanded {
                        return 200
                    } else {
                        return 50
                    }
                }
            }
            return 50
        }
}




