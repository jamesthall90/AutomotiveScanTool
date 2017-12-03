//
//  CodeHistoryViewController.swift
//  AutomotiveScanTool
//
//  Created by James Hall on 11/15/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import UIKit
import Firebase
import ParticleSDK


class CodeHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var ref: DatabaseReference!
    var uid: String!
    var vin: String!
    var dateString : String!
    var deviceInfo: ParticleDevice!

    @IBAction func backButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "backToMainMenuFromHistorySegue", sender: self)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    var dates: [String] = []
    var values = [[String: [[String: [[String:String]]]]]]()
//    var values: Dictionary<String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource = self;
        
//        self.values = [["Date" : [["Current" : [["code":"description"]]],
//                                  ["Pending":[["code":"description"],
//                                            ["code":"Description"]]],
//                                  ["Cleared": [["code":"description"]]]]],
//                       ["date2" : [["Current" : [["code":"Description"]]]]]
//                      ]
//        self.values = []
        

        
        self.buildData { (completion:String) in
            print(completion)
            print(self.dates)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    func buildData (completion: @escaping (String) -> Void) {
        self.ref.child("users").child(self.uid).child("vehicles").child("2G1FE1ED7B9118397"/*self.vin*/).child("storedCodes").observe(DataEventType.value, with : {(snapshot) in
//            print("SNAPSHOT: ",snapshot)

            let data = snapshot.value as? NSDictionary
            for date in data! {
                self.dates.append((date.key as? String)!)
//                print("Date: ", date.key, "Value: ", date.value)
            }
        completion("Success")
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.dateString = dates[indexPath.row]
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "readCodeHistorySegue", sender: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dates.count > 0 {
            return dates.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
        cell.dateLabel.text = dates[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView{
        var title: UILabel = UILabel()
        
        title.text = "--DATES--"
        title.textColor = UIColor(red: 77.0/255.0, green: 98.0/255.0, blue: 130.0/255.0, alpha: 1.0)
        title.backgroundColor = UIColor(red: 225.0/255.0, green: 243.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        title.font = UIFont.boldSystemFont(ofSize: 18)
        
        var constraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[label]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["label": title])
        
        title.textAlignment = NSTextAlignment.center
        title.addConstraints(constraint)
        
        return title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if selectedIndexPath != [] {
//            if (indexPath == selectedIndexPath) {
//                if cellExpanded {
//                    return 200
//                } else {
//                    return 50
//                }
//            }
//        }
        return 50
    }
    
}
