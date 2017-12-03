//
//  ReadCodeHistoryViewController.swift
//  AutomotiveScanTool
//
//  Created by Stephen Lomangino on 12/1/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import PromiseKit
import ParticleSDK

class ReadCodeHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var ref: DatabaseReference!
    var uid: String!
    var vin: String!
    var deviceInfo: ParticleDevice!
    var dateString : String!
    
    var values = [String : [[String : [String]]]]()
    var cellExpanded : Bool = false
    var selectedIndexPath : IndexPath = []
    
    @IBOutlet weak var titleBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "backToCodeHistorySegue", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource = self;
        self.values = ["Pending": [],
                       "Current" :[],
                       "Cleared":[]
        ]

        self.buildData{(completion: String) in
            print(completion)
            DispatchQueue.main.async {
                self.titleBar.topItem?.title = self.dateString
                self.tableView.reloadData()
            }
        }
    }
    
    func buildData(completion: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            self.ref.child("users").child(self.uid).child("vehicles").child("2G1FE1ED7B9118397"/*self.vin*/).child("storedCodes").child(self.dateString).observe(DataEventType.value, with: { (snapshot) in
                
                let fbSnapshot = snapshot.value as? NSDictionary
                for status in fbSnapshot! {
                    var codeItems = status.value as? NSDictionary
                    for codeItem in codeItems! {
                        self.values[(status.key as? String)!]?.append([(codeItem.key as? String)! : [(codeItem.value as? String)!, "Google Link"]])
                    }
                }
                
                for items in self.values {
                    print(items.key, "  ", items.value)
                }
                print("VALUES IN BUILDDATA()", self.values)
                completion("Success")
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRowsForSection(s: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! StatusCell
        cell.descriptionLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        cell.descriptionLabel?.numberOfLines = 0;
        cell.codeLabel.text = getCodeText(s: indexPath.section, r: indexPath.row)
        cell.descriptionLabel.text = getCodeDescription(s: indexPath.section, r: indexPath.row)
        
        return cell
    }
    
    func getNumberOfRowsForSection(s: Int) -> Int {
        var counter = 0
        for section in self.values{
            if counter == s {
                //                    print("Section.value: ", section.value)
                return section.value.count
            }
            counter += 1
        }
        return 0
    }
    
    func getCodeDescription (s: Int, r:Int) -> String {
        var counter = 0
        for section in self.values {
            for i in 0...section.value.count {
                if i < section.value.count {
                    let row = section.value[i]
                    if (i == r && s == counter) {
                        return(row.first?.value[0])!
                    }
                }
            }
            counter += 1
        }
        return ""
    }
    
    func getCodeText(s: Int, r: Int) -> String {
        var counter = 0
        for section in self.values {
            for i in 0...section.value.count {
                //
                print("Section.value: ", section.value)
                print("r: ", r, "s: ", s ,"i: ", i)
                if i < section.value.count {
                    let row = section.value[i]
                    if (i == r && s == counter) {
                        return(row.first?.key)!
                    }
                }
            }
            counter += 1
        }
        return ""
    }
    
    func getStatusText (index : Int) -> String {
        var counter = 0
        for section in self.values {
            if counter == index {
                return section.key
            }
            counter += 1
            
        }
        return "Didnt Work"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
