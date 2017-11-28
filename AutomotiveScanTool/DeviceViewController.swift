import UIKit
import QuartzCore
import ParticleSDK
import ZAlertView
import FirebaseAuth
import Hero
import Font_Awesome_Swift

class DeviceViewController: UIViewController, ParticleDeviceDelegate {
    
    var particleDevices:[ParticleDevice]? = []
    var selectedDeviceIndex: Int!
    var dialog: ZAlertView!
    var astColor: UIColor!
    @IBOutlet weak var deviceTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        astColor = UIColor(red:0.00, green:0.20, blue:0.40, alpha:1.0)
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
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        
        //Logs out of the Particle Cloud instance
        ParticleCloud.sharedInstance().logout()
        
        //Creates a Firebase Auth reference
        let firebaseAuth = Auth.auth()
        
        do {
            //Signs out of Firebase
            try firebaseAuth.signOut()
          
          //Catches any errors in signing out and writes a warning to the console
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

        //Once the user is logged out, segue switches views to Login
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    @IBAction func cellButtonTapped(_ sender: UIButton) {
        
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        let indexPath = deviceTable.indexPath(for: cell)
        
        selectedDeviceIndex = (deviceTable.indexPath(for: cell) as! NSIndexPath).row
        
        //Logic to ensure that the device is connected before segue-ing
        if(!particleDevices![selectedDeviceIndex].connected){
            
            dialog = ZAlertView(title: "Device Not Connected",
                                message: "The device is not connected to the vehicle! \n\nPlug the device into your vehicle's OBDII port, turn the ignition to the \"ON\" position, and try again.",
                                closeButtonText: "OK",
                                closeButtonHandler: { (alertView) -> () in
                                    alertView.dismissAlertView()
            })
            
            dialog.allowTouchOutsideToDismiss = false
            
            dialog.show()
            
        //Logic to ensure that the selected device has the required firmware installed
        } else if (!particleDevices![selectedDeviceIndex].functions.contains("getFirmware")){
            
            let noFirmware =  ZAlertView(title: "Firmware Not Installed!",
                                         message: "The device does not have the appropriate firmware installed!.",
                                         closeButtonText: "OK",
                                         closeButtonHandler: { (alertView) -> () in
                                            alertView.dismissAlertView()
            })
            
            noFirmware.allowTouchOutsideToDismiss = false
            
            noFirmware.show()
          
          //If the device is connected and has the required firmware installed, perform segue
        } else{
            
            performSegue(withIdentifier: "idSeguePresentMainMenu", sender: self)
            
        }
    }
}

extension DeviceViewController {
    
    //Gets a list of all devices and populates the TableView with them
    func getParticleDevices(indexPath: NSIndexPath, cell: DeviceTableViewCell){
        
        //Shows a loading HUD while devices are being loaded
        LoadingHud.showHud(self.view, label: "Loading Devices...")
        
        //Particle Cloud function which returns an array of devices
        ParticleCloud.sharedInstance().getDevices { (devices:[ParticleDevice]?, error:Error?) -> Void in
            
            //Prints a message to the console if an error is detected
            if let _ = error {
                
                print("Check your internet connectivity")
            }
            else { //No errors detected
                
                if let d = devices {
                    
                    //Loops through the array of devices that is returned
                    for device in d {
                        
                        //Adds the current device to the TableView's data source
                        self.particleDevices?.append(device)
                        
                        //Class method which selects device type and a device image based on device
                        var info = ASTInfo.getDeviceTypeAndImage(device)
                        
                        //Sets the current device's image
                        cell.deviceImageView.image = info.deviceImage
                        
                        //Sets the current device's type label
                        cell.deviceTypeLabel?.text = info.deviceType
                        
                        //Logic to make sure that name has been stored
                        if let name = self.particleDevices![(indexPath as NSIndexPath).row].name {
                            
                            //Sets the device's name label
                            cell.deviceNameLabel?.text = name.uppercased()
                            
                        } else {
                            
                            //Sets the device's name label
                            cell.deviceNameLabel?.text = "<no name>"
                        }
                        
                        //Sets the device button with a Font-Awesome chevron icon
                        cell.deviceCellButton.setFAIcon(icon: .FAChevronRight, iconSize: 35, forState: .normal)
                        
                        //Changes the button icon's color to match the app's theme
                        cell.deviceCellButton.setFATitleColor(color: self.astColor)
                    }
                }
            }
        }
        //Closes the HUD once TableView has been populated with devices
        LoadingHud.hideHud(self.view)
    }
}

extension DeviceViewController: UITableViewDelegate {
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath) as! DeviceTableViewCell
        
        //
        self.getParticleDevices(indexPath: indexPath as NSIndexPath, cell: cell)
        
        return cell
    }
    
    //Sets the height for each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    //Ensures that the cell is not selected when tapped
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return nil
    }
}

extension DeviceViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (particleDevices != nil) ? particleDevices!.count+1 : 0
    }
}
    

