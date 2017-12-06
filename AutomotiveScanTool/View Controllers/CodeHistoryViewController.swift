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
    var dates: [String] = []
    var vehicleStruct: Vehicle?
    var values = [[String: [[String: [[String:String]]]]]]()
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    @IBAction func backButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "backToMainMenuFromHistorySegue", sender: self)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.buildData { (completion:String) in
            DispatchQueue.main.async {
                self.backButtonOutlet.setFAIcon(icon: .FAChevronLeft, iconSize: 25, forState: .normal)
                self.tableView.reloadData()
            }
        }
    }
    
    func buildData (completion: @escaping (String) -> Void) {
        
        /* ***Uncomment to use hard coded values*** */
//        self.ref.child("users").child(self.uid).child("vehicles").child("2G1FE1ED7B9118397"/*self.vin*/).child("storedCodes").observe(DataEventType.value, with : {(snapshot) in
        self.ref.child("users").child(self.uid).child("vehicles").child(self.vin).child("storedCodes").observe(DataEventType.value, with : {(snapshot) in

            let data = snapshot.value as? NSDictionary
            for date in data! {
                self.dates.append((date.key as? String)!)
            }
            self.dates.sort()
            self.dates.reverse()
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
        title.textColor = astColor
        title.backgroundColor = UIColor(red: 225.0/255.0, green: 243.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        title.font = UIFont(name: "Copperplate-Bold", size: 20)
        
        var constraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[label]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["label": title])
        
        title.textAlignment = NSTextAlignment.center
        title.addConstraints(constraint)
        return title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
