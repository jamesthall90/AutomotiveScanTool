//
//  VinRequest.swift
//  AST
//
//  Created by James Hall on 8/29/17.
//  Copyright © 2017 OP. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AwaitKit
import PromiseKit

class VinRequest{
    
    //Initialization of instance variables
    var vin : String
    var parameters: Parameters?
    var vinPath: String
    var vehicleData : JSON
    
    class func request( URL: URL, method: HTTPMethod, parameters: Parameters?, vinPath: String) -> Promise<NSData> {
        return Promise{ resolve, reject in
            Alamofire.request(URL, method: method, parameters: parameters).responseJSON { responseData in
               
                switch responseData.result {
                    case .success(let value):
                        
                        let json = JSON(value)
                        print("JSON: \(json)")
                        
                        do{
                            try json.description.write(toFile: vinPath, atomically: true, encoding: String.Encoding.utf8)
                        } catch let error as NSError {
                            
                            print("Could not write to file")
                            print(error.localizedDescription)
                            print("")
                        }
                    
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }

    class func getContentsOfDirectory(dir: String){
        
        let filemgr = FileManager.default
        
        do {
            let filelist = try filemgr.contentsOfDirectory(atPath: dir)
            print("------------------------")
            print("")
            for filename in filelist {
                print(filename)
            }
            print("")
            print("------------------------")
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    //Specifies how parameters are handled upon object initialization
    init(VIN : String) {
        
        self.vin = VIN
        
        //Sets passed-in VIN as parameter data to be used in POST / decode request
        parameters = [
            "data":"\(vin);",
            "format":"json"
        ]
        
        self.vinPath = "\(AppDelegate.getAppDelegate().getDocDir())/decoded-vin.json"
        
        let apiURL = URL(string:"https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVINValuesBatch/")
        
        do{
            try! await(VinRequest.request(URL: apiURL!, method: .post, parameters: parameters, vinPath: self.vinPath))
        
        } catch let error as NSError{
            print(error.localizedDescription)
            print("something bad happened!")
        }
        
        VinRequest.getContentsOfDirectory(dir: AppDelegate.getAppDelegate().getDocDir())
        
        //Creates url from vinPath
        let vinURL = URL(fileURLWithPath: self.vinPath)
        
//        print(vinURL.absoluteString)
        
        //Converts the file at the vinURL into a data object,
        //and then into a JSON object
        do{
           try vehicleData = JSON(data: try Data(contentsOf: vinURL))
            
        } catch let error as NSError{
            
            vehicleData = JSON.null
            print("**********************************")
            print("Could not open JSON")
            print(error.localizedDescription)
            print("**********************************")
        }
    }
    
    func getVehicleYear() -> String{
        
        //Pulls the vehicle year from the JSON file
        var vehicleYear =  vehicleData["Results"].arrayValue.map({$0["ModelYear"].stringValue}).first
        
        //Returns a default string if the vehicle Year is empty
        if (vehicleYear == ""){
            vehicleYear = "Year Not Specified".uppercased()
        }
        
        return(vehicleYear?.uppercased())!
    }
    
    func getVehicleMake() -> String{
        
        var vehicleMake =  vehicleData["Results"].arrayValue.map({$0["Make"].stringValue}).first
        
        //Returns a default string if the vehicle Make is empty
        if (vehicleMake == ""){
            vehicleMake = "Make Not Specified".uppercased()
        }
        
        return(vehicleMake?.uppercased())!
    }
    
    func getVehicleModel() -> String{
        
        var vehicleModel =  vehicleData["Results"].arrayValue.map({$0["Model"].stringValue}).first
        
        //Returns a default string if the vehicle Model is empty
        if (vehicleModel == ""){
            vehicleModel = "Model Not Specified".uppercased()
        }
        
        return(vehicleModel?.uppercased())!
    }
    
    func getVehicleVIN() -> String{
        
        var vehicleVIN =  vehicleData["Results"].arrayValue.map({$0["VIN"].stringValue}).first
        
        //Returns a default string if the vehicle's VIN is empty
        if (vehicleVIN == ""){
            vehicleVIN = "VIN Not Specified".uppercased()
        }
        
        return (vehicleVIN?.uppercased())!
    }
    
    func getVehicleType() -> String{
        
        var vehicleType =  vehicleData["Results"].arrayValue.map({$0["VehicleType"].stringValue}).first
        
        //Returns a default string if the vehicle type is empty
        if (vehicleType == ""){
            vehicleType = "Vehicle Type Not Specified".uppercased()
        }
        
        return (vehicleType?.uppercased())!
    }
    
    func getVehicleDriveType() -> String{
        
        var vehicleDriveType =  vehicleData["Results"].arrayValue.map({$0["DriveType"].stringValue}).first
        
        //Returns a default string if the vehicle's Engine Displacement field is empty
        if (vehicleDriveType == ""){
            vehicleDriveType = "Drive Type Not Specified".uppercased()
        }
        
        return (vehicleDriveType?.uppercased())!
    }
    
    func getVehicleEngineSize() -> String{
        
        var engineDisplacement =  vehicleData["Results"].arrayValue.map({$0["DisplacementL"].stringValue}).first
        
        //Returns a default string if the vehicle's Engine Displacement field is empty
        if (engineDisplacement == ""){
            engineDisplacement = "Engine Size Not Specified".uppercased()
        }
        
        return (engineDisplacement?.uppercased())!
    }
    
    func getVehicleTransmission() -> String{
        
        var vehicleTransmission =  vehicleData["Results"].arrayValue.map({$0["TransmissionStyle"].stringValue}).first
        
        //Returns a default string if the vehicle's Transmission Type is empty
        if (vehicleTransmission == ""){
            vehicleTransmission = "Transmission Not Specified".uppercased()
        }
        
        return (vehicleTransmission?.uppercased())!
    }
    
    func getVehicleAssemblyPlant() -> String{
        
        var vehicleAssemblyPlant =  "\(vehicleData["Results"].arrayValue.map({$0["PlantCity"].stringValue}).first ?? ""), \(vehicleData["Results"].arrayValue.map({$0["PlantCountry"].stringValue}).first ?? "")"
        
        //Returns a default string if the vehicle's Assembly Plant value is empty
        if (vehicleAssemblyPlant == ","){
            vehicleAssemblyPlant = "Assembly Plant Not Given".uppercased()
        }
        
        return (vehicleAssemblyPlant.uppercased())
    }
    
    func getVehicleFuelType() -> String{
        
        var vehicleFuelType =  vehicleData["Results"].arrayValue.map({$0["FuelInjectionType"].stringValue}).first
        
        //Returns the vehicle's Transmission Type or a default string (if nil)
        if (vehicleFuelType == ""){
            vehicleFuelType = "Fuel Type Not Specified".uppercased()
        }
        
        return (vehicleFuelType!.uppercased())
    }
}
