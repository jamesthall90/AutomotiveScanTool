////
////  RCViewController.swift
////  AutomotiveScanTool
////
////  Created by James Hall on 11/15/17.
////  Copyright © 2017 James Hall. All rights reserved.
////
//
//import UIKit
//import FirebaseAuth
//import FirebaseDatabase
//import PromiseKit
//import ParticleSDK
//
//class RCViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    public struct Section{
//        public var code: String
//        public var codeItems: [String]
//
//        public init(code: String, codeItems: [String]) {
//            self.code = code
//            self.codeItems = codeItems
//        }
//    }
//
////    public struct Section{
////        public var status : String
////        public var innerSection : [InnerSection]
////
////        public init(_ status: String, _ innerSection: [InnerSection]) {
////            self.status = status
////            self.innerSection = innerSection
////        }
////    }
////
////    public struct InnerSection{
////        public var code: String
////        public var codeItems: [String]
////
////        public init(_ code: String, _ codeItems: [String]) {
////            self.code = code
////            self.codeItems = codeItems
////        }
////    }
////
////        to add:
////    var section : Section = Section("Pending", [InnerSection("P0008", ["Description Pending","Google Link"])])
//
//    var ref: DatabaseReference!
//    var uid: String!
//    var vin: String!
//    var deviceInfo: ParticleDevice!
//    var dateString : String!
//    private var cellExpanded : Bool = false
//
//    let kHeaderSectionTag: Int = 6900;
//
//    @IBOutlet weak var tableView: UITableView!
//
//    var expandedSectionHeaderNumber: Int = -1
//    var expandedSectionHeader: UITableViewHeaderFooterView!
//    var sections : [Section] = []
//    var codeItems : [String] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("-----loading screen closing-----")
//        LoadingHud.hideHud(self.view)
//            DispatchQueue.main.async {
//                self.dateString = "
//
//            //query firebase for codes with a specific date .datestring).observe(...)
//            self.ref.child("users").child(self.uid).child("vehicles").child(self.vin).child("storedCodes").child(self.dateString).observe(DataEventType.value, with: { (snapshot) in
//                print("SNAPSHOT: ",snapshot)
//
//                let values = snapshot.value as? NSDictionary
////                print("VALUES: ",values)
//                //add Sections to the sections array for each code that was in the snapshot.
//                for items in values! {
//                    var k = items.key
////                    print("k = ", k)
//                    var v = items.value as! [String : String]
////                    print("v = ", v)
//                    for (a , b) in v {
////                        print("key value pairs: ")
////                        print("\(a) : \(b)")
//                        let link = "https://www.google.com/search?q=" + (a as? String)!
//
//                        let newSection : Section  = (Section(code: (a as? String)!, codeItems: [(b as? String)!, link]))
//                        self.sections.append(newSection)
//                    }
////                    for k in items {
////
////                        let link = "https://www.google.com/search?q=" + (k.key as? String)!
////                        let newSection: Section = (Section(code: (k.key as? String)!, codeItems: [
////                            (k.value as? String)!, link]))
////                        self.sections.append(newSection)
////                    }//end for
//                }
////                print("Sections: ", self.sections)
////                print("Sections Count: ", self.sections.count)
//
//                DispatchQueue.main.async {
//                    print("reloading inside query")
//                    print("reloading inside")
//                    self.tableView.reloadData()
//                }
//            })//end firebase query
//        }//end DispatchQueue
////        print("reloading outside")
////        self.tableView.reloadData()
//        self.tableView!.tableFooterView = UIView()
//    }//end viewDidLoad
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    @IBAction func tcBackButton(_ sender: Any) {
//
//        self.performSegue(withIdentifier: "troubleCodeBackSegue", sender: self)
//    }
//
//    // MARK: - Tableview Methods
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        print("Sections in numberOfSetions: ", self.sections)
//        print("Sections Count in numberOfSetions: ", self.sections.count)
//
//        if self.sections.count > 0 {
//            tableView.backgroundView = nil
//            return self.sections.count
//        } else {
//            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
//            messageLabel.text = "Retrieving data.\nPlease wait."
//            messageLabel.numberOfLines = 0;
//            messageLabel.textAlignment = .center;
//            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
//            messageLabel.sizeToFit()
//            self.tableView.backgroundView = messageLabel;
//        }
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (self.expandedSectionHeaderNumber == section) {
//            let arrayOfItems = self.sections[section].codeItems as! NSArray
//            return arrayOfItems.count;
//        } else {
//            return 0;
//        }
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if (self.sections.count != 0) {
//            return self.sections[section].code as? String
//        }
//        return ""
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44.0;
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
//        return 0;
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        //recast your view as a UITableViewHeaderFooterView
//        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//        header.contentView.backgroundColor = UIColor.blue
//
//
//        //        colorWithHexString(hexStr: "#408000")
//
//        header.textLabel?.textColor = UIColor.white
//        header.textLabel?.font = UIFont(name: "Copperplate-Bold", size: 17)
//
//        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
//            viewWithTag.removeFromSuperview()
//        }
//        let headerFrame = self.view.frame.size
//        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
//        theImageView.image = UIImage(named: "Chevron-Dn-Wht")
//        theImageView.tag = kHeaderSectionTag + section
//        header.addSubview(theImageView)
//
//        // make headers touchable
//        header.tag = section
//        let headerTapGesture = UITapGestureRecognizer()
//        headerTapGesture.addTarget(self, action: #selector(RCViewController.sectionHeaderWasTouched(_:)))
//        header.addGestureRecognizer(headerTapGesture)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "codeCell", for: indexPath) as! CodesTableViewCell
//        let section = self.sections[indexPath.section].codeItems
//
//        //line wrapping
//        cell.rowDescription?.lineBreakMode = NSLineBreakMode.byWordWrapping;
//        cell.rowDescription?.numberOfLines = 0;
//
//        cell.rowDescription.font = UIFont(name: "Copperplate-Bold", size: 13)
//
//        //there will only ever be two items in each section. First is Code Description
//        //second is the google search link
//        if (indexPath[1] == 0) { //code
//            cell.title?.text = "Code Description: "
//        } else if (indexPath[1] == 1) { //link
//            cell.title?.text = "Search Google: "
//        }
//        cell.rowDescription?.text = section[indexPath[1]]
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        print("*********selected a row!**********")
//        if (indexPath.row == 0) {
//            if cellExpanded {
//                cellExpanded = false
//            } else {
//                cellExpanded = true
//
//            }
//            tableView.beginUpdates()
//            tableView.endUpdates()
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (indexPath.row == 0) {
//            if cellExpanded {
//                return 250
//            } else {
//                return 50
//            }
//        }
//        return 50
//    }
//
//    // MARK: - Expand / Collapse Methods
//
//    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
//        let headerView = sender.view as! UITableViewHeaderFooterView
//        let section    = headerView.tag
//        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
//
//        if (self.expandedSectionHeaderNumber == -1) {
//            self.expandedSectionHeaderNumber = section
//            tableViewExpandSection(section, imageView: eImageView!)
//        } else {
//            if (self.expandedSectionHeaderNumber == section) {
//                tableViewCollapeSection(section, imageView: eImageView!)
//            } else {
//                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
//                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
//                tableViewExpandSection(section, imageView: eImageView!)
//            }
//        }
//    }
//
//    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
//        let sectionData = self.sections[section].codeItems as! NSArray
//
//        self.expandedSectionHeaderNumber = -1;
//        if (sectionData.count == 0) {
//            return;
//        } else {
//            UIView.animate(withDuration: 0.4, animations: {
//                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
//            })
//            var indexesPath = [IndexPath]()
//            for i in 0 ..< sectionData.count {
//                let index = IndexPath(row: i, section: section)
//                indexesPath.append(index)
//            }
//            self.tableView!.beginUpdates()
//            self.tableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
//            self.tableView!.endUpdates()
//        }
//    }
//
//    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
//        let sectionData = self.sections[section].codeItems as! NSArray
//
//        if (sectionData.count == 0) {
//            self.expandedSectionHeaderNumber = -1;
//            return;
//        } else {
//            UIView.animate(withDuration: 0.4, animations: {
//                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
//            })
//            var indexesPath = [IndexPath]()
//            for i in 0 ..< sectionData.count {
//                let index = IndexPath(row: i, section: section)
//                indexesPath.append(index)
//            }
//            self.expandedSectionHeaderNumber = section
//            self.tableView!.beginUpdates()
//            self.tableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
//            self.tableView!.endUpdates()
//        }
//    }
//}
//
//
//
