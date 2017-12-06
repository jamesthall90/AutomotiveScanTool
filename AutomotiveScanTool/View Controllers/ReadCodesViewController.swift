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
import Font_Awesome_Swift

class ReadCodesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var ref: DatabaseReference!
    var uid: String!
    var vin: String!
    var deviceInfo: ParticleDevice!
    var dateString : String!
    var vehicleStruct: Vehicle?
    var values = [String : [[String : [String]]]]()
    var cellExpanded : Bool = false
    var selectedIndexPath : IndexPath = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource = self;
        self.values = ["Pending": [],
                       "Current": [],
                       "Cleared": []
        ]
        
        self.buildData{(completion: String) in
            print(completion)
            DispatchQueue.main.async {
                self.backButtonOutlet.setFAIcon(icon: .FAChevronLeft, iconSize: 25, forState: .normal)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "rcToMainSegue", sender: self)
    }
    
    //build the values array with data from the database
    func buildData(completion: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            
            /*
             Uncomment to use hardcoded values when device is not connected
             Comment the line below it for hardcoded values
             */
       // self.ref.child("users").child(self.uid).child("vehicles").child("2G1FE1ED7B9118397").child("storedCodes").child("11-27-17-04:20").observe(DataEventType.value, with: { (snapshot) in
            self.ref.child("users").child(self.uid).child("vehicles").child(self.vin).child("storedCodes").child(self.dateString).observe(DataEventType.value, with: { (snapshot) in

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
        cell.expandArrow.setFAIconWithName(icon: .FAChevronRight, textColor: astColor)
        cell.googleButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return cell
    }
    
    func getNumberOfRowsForSection(s: Int) -> Int {
        var counter = 0
        for section in self.values{
            if counter == s {
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
        return "Error: Could not load StatusText"
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
        
        let cell = tableView.cellForRow(at: indexPath) as? StatusCell
        
        //expand selected row and collapse any other row that was previously expanded
        cellExpanded = false
        cell?.expandArrow.setFAIconWithName(icon: .FAChevronRight, textColor: astColor)
        if (indexPath != selectedIndexPath) {
            cell?.expandArrow.setFAIconWithName(icon: .FAChevronDown, textColor: astColor)
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
                    return 170
                } else {
                    return 50
                }
            }
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            
            headerTitle.textLabel?.textColor = UIColor.black
            headerTitle.textLabel?.font = UIFont(name: "Copperplate-Bold", size: 20)
            headerTitle.backgroundView?.alpha = 0.4
            
            if (forSection == 0) {
                headerTitle.backgroundView?.backgroundColor = UIColor.yellow
            } else if (forSection == 1){
                headerTitle.backgroundView?.backgroundColor = UIColor.green
            } else {
                headerTitle.backgroundView?.backgroundColor = UIColor.red
            }
        }
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        // Fetch Item
        if let indexPath = self.tableView.indexPathForView(view: sender) {
            let code = self.getCodeText(s: (indexPath.section), r: (indexPath.row))
            
            let car = "https://www.google.com/search?q=\(vehicleStruct?.year as? String ?? "2011")+\(vehicleStruct?.make as? String ?? "CHEVROLET")+\(vehicleStruct?.model as? String ?? "CAMARO")+\(code)"
            
            UIApplication.shared.open(URL(string: car)!)
        }
    }
}
