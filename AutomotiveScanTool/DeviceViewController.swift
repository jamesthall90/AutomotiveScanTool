import UIKit
import QuartzCore
import ParticleSDK
import ZAlertView
import FirebaseAuth
import Hero

class DeviceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ParticleDeviceDelegate {
    
    @IBOutlet weak var deviceTable: UITableView!
    var particleDevices:[ParticleDevice]? = []
    var selectedDeviceIndex: Int!
    var deviceImage: UIImage!
    var deviceType: String!
    var dialog: ZAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let astColor = UIColor(red:0.00, green:0.20, blue:0.40, alpha:1.0)
        ZAlertView.blurredBackground = true
        ZAlertView.showAnimation = .bounceBottom
        ZAlertView.hideAnimation = .bounceRight
        ZAlertView.alertTitleFont = UIFont(name: "Copperplate", size: 19)!
        ZAlertView.positiveColor = astColor
        ZAlertView.titleColor = astColor
        
        deviceTable.delegate = self
        deviceTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func back(_ sender: Any) {
        
        //dismiss your viewController
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.register(DeviceTableViewCell.self, forCellReuseIdentifier: "deviceCell")
        
        return (particleDevices != nil) ? particleDevices!.count+1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath)
        
        if cell == nil {
            cell = DeviceTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "deviceCell")
        }
        
        self.getParticleDevices(indexPath: indexPath as NSIndexPath, cell: cell)
        
        return cell
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        
        ParticleCloud.sharedInstance().logout()

        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

        //Once the user is logged out, segue switches views to Login
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
        
//        UIApplication.shared.openURL(URL(string: "http://www.google.com/#q=2012+kia+optima+p0303")!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedDeviceIndex = (indexPath as NSIndexPath).row
        
        dialog = ZAlertView(title: "Device Not Connected",
                            message: "The device is not connected to the vehicle! \n\nPlug the device into your vehicle's OBDII port, turn the ignition to the \"ON\" position, and try again.",
                            closeButtonText: "OK",
                            closeButtonHandler: { (alertView) -> () in
                                alertView.dismissAlertView()
        })
        
        dialog.allowTouchOutsideToDismiss = false
        
        if(particleDevices![selectedDeviceIndex].connected){
            
            performSegue(withIdentifier: "idSeguePresentMainMenu", sender: self)
        } else{
            
            dialog.show()
        }
    }
    
    func getParticleDevices(indexPath: NSIndexPath, cell: UITableViewCell){
        LoadingHud.showHud(self.view, label: "Loading Devices...")
        ParticleCloud.sharedInstance().getDevices { (devices:[ParticleDevice]?, error:Error?) -> Void in
            if let _ = error {
                print("Check your internet connectivity")
            }
            else {
                if let d = devices {
                    for device in d {
                        
                        self.particleDevices?.append(device)
                        
                        if let name = self.particleDevices![(indexPath as NSIndexPath).row].name
                        {
                            cell.textLabel?.text = name.uppercased()
                        }
                        else
                        {
                            cell.textLabel?.text = "<no name>"
                        }
                    }
                }
            }
        }
        LoadingHud.hideHud(self.view)
    }
}
    

