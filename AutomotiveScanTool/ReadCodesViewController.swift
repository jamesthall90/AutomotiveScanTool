//
//  ReadCodesViewController.swift
//  AutomotiveScanTool
//
//  Created by Stephen Lomangino on 11/15/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import UIKit
import CollapsibleTableSectionViewController
import FirebaseAuth
import FirebaseDatabase
import PromiseKit


public struct codeData {
    public var description: String
    public var googleLink: String
    
    public init(description: String, googleLink: String) {
        self.description = description
        self.googleLink = googleLink
    }
}

public struct Section {
    public var code: String
    public var codeData: [codeData]
    
    public init(code: String, codeData: [codeData]) {
        self.code = code
        self.codeData = codeData
    }
}

class ReadCodesViewController: CollapsibleTableSectionViewController {
    
    var ref: DatabaseReference!
    var uid: String!
    var vin: String!
    var dateString : String!
    var sectionData : [Section] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
//        self.sectionData = buildSectionData()
        
//            [
//            Section(code: "P0000", codeData: [
//                codeData(description: "derp", googleLink: "www.google.com/derp"),
//                codeData(description: "bork", googleLink: "www.google.com/bork")
//
//            ]),
//            Section(code: "P1111", codeData: [
//                codeData(description: "derp", googleLink: "www.google.com/derp"),
//                codeData(description: "bork", googleLink: "www.google.com/bork")
//            ])
//        ]
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.
//    }
    
    func buildSectionData (){
//    self.ref.child("users").child(self.uid).child("vehicles").child(self.vin).child("storedCodes").child(self.dateString).observe(DataEventType.childAdded, with: DataSnapshot.init())
//            let codes = snapshot.value as? [String: AnyObject] ?? [:]
//            print(codes)
//            for d in codes {
////                print("key: ", d.key as? String, " value: ", d.value as? String)
//                self.sectionData.append(Section(code: (d.key as? String)!, codeData: [
//                    codeData(description: (d.value as? String)!, googleLink: "link")
//                ]))
//            }
//
//        })
        
    ref.child(self.uid).child("vehicles").child(self.vin).child("storedCodes").child(self.dateString).observe(DataEventType.value, with: { (snapshot) in
            let codes = snapshot.value as? [String : AnyObject] ?? [:]
            
            print(codes)
            
            for d in codes {
                //                print("key: ", d.key as? String, " value: ", d.value as? String)
                self.sectionData.append(Section(code: (d.key as? String)!, codeData: [
                    codeData(description: (d.value as? String)!, googleLink: "link")
                    ]))
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ReadCodesViewController: CollapsibleTableSectionDelegate {
    
    func numberOfSections(_ tableView: UITableView) -> Int {
        buildSectionData()
        print("sectionData.count is: ",self.sectionData.count)
        return self.sectionData.count
    }
    
    func collapsibleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("sectionData[section].codeData.count is: ",self.sectionData[section].codeData.count)
        return self.sectionData[section].codeData.count
    }
    
    func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell") as UITableViewCell? ?? UITableViewCell(style: .subtitle, reuseIdentifier: "BasicCell")
        
//        buildSectionData()
//        print(sectionData)
        
        let codes: codeData = self.sectionData[indexPath.section].codeData[indexPath.row]
        
        cell.textLabel?.text = codes.description
        cell.detailTextLabel?.text = codes.googleLink
        
        return cell
    }
    
    func collapsibleTableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionData[section].code
    }
}

//extension DatabaseReference {
//    func observeSingleEvent() -> Promise<DatabaseReference> {
//        return PromiseKit.wrap { resolve in
//            observeSingleEvent(of: .value, with: snapshot in))
//        }
//    }
//}


