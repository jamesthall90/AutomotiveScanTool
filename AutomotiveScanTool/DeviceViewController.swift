import UIKit
import QuartzCore
import ParticleSDK

class DeviceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ParticleDeviceDelegate {
    
    @IBOutlet weak var deviceTable: UITableView!
    
    var particleDevices:[ParticleDevice]? = []
    var selectedDeviceIndex: Int!
    var deviceImage: UIImage!
    var deviceType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            
            if identifier == "idSeguePresentMainMenu" {
                
                let mainMenu = segue.destination as! MainMenuViewController
                
                if let deviceObject = self.particleDevices?[selectedDeviceIndex] {
                    
                    mainMenu.deviceInfo = deviceObject
                    
                } else {
                    //handle the case of 'deviceObject' being 'nil'
                }
            }
        }
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
        
        ParticleCloud.sharedInstance().getDevices { (devices:[ParticleDevice]?, error:Error?) -> Void in
            if let _ = error {
                print("Check your internet connectivity")
            }
            else {
                if let d = devices {
                    for device in d {
                        
                        self.particleDevices?.append(device)
                        cell.textLabel?.text = device.name
                    }
                }
            }
        }
      return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedDeviceIndex = (indexPath as NSIndexPath).row
        performSegue(withIdentifier: "idSeguePresentMainMenu", sender: self)
    }

}
