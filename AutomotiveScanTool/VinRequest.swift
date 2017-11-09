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

class VinRequest{
    
    //Initialization of instance variables
    var vin : String
    var parameters: Parameters
    var vinPath: String
    var imagePath: String
    var vehicleData : JSON
    
    /*
     * Function processes an HTTP POST request from NHTSA's Vehicle API
     * using the VIN parameter passed through init() and writes the
     * JSON to a file in the application's Documents directory
     */
    class func postRequest(vinPath: String, parameters: Parameters){
        
        Alamofire.request("https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVINValuesBatch/", method: .post, parameters: parameters).responseJSON { (responseData) -> Void in
            
            if((responseData.result.value) != nil) {
                
                let responseDataJSON = JSON(responseData.result.value!)
                
                //Writes the newly-decoded vin information to a file at the vinPath
                do{
                    
                    try responseDataJSON.description.write(toFile: vinPath, atomically: false, encoding: String.Encoding.utf8)
                } catch{
                    
                    print("Could not write to file")
                }
            }
        }
    }
    
    class func vehicleImageCall(path: String, vin: String){
        Alamofire.request("https://api.fuelapi.com/v1/json/vehicle/\(vin)/?api_key=daefd14b-9f2b-4968-9e4d-9d4bb4af01d1&productID=1&shotCode=037").responseJSON { (responseData) -> Void in
            
            if((responseData.result.value) != nil) {
                
                let responseDataJSON = JSON(responseData.result.value!)
                
                //Writes the newly-decoded vin information to a file at the vinPath
                do{
                    
                    try responseDataJSON.description.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
                } catch{
                    
                    print("Could not write to file")
                }
            }
        }
        //Creates url from vinPath
        let imageURL = URL(fileURLWithPath: path)
        
        print(imageURL.absoluteString)
        
        var vehicleData: JSON
        
        //Converts the file at the vinURL into a data object,
        //and then into a JSON object
        do{
            
            vehicleData = JSON(data: try Data(contentsOf: imageURL))
            
        } catch{
            
            vehicleData = JSON.null
            print("Could not create JSON")
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
        self.imagePath = "\(AppDelegate.getAppDelegate().getDocDir())/image.json"
        
        VinRequest.postRequest(vinPath: vinPath, parameters: parameters)
        
        //Creates url from vinPath
        let vinURL = URL(fileURLWithPath: self.vinPath)
        
        print(vinURL.absoluteString)
        
        //Converts the file at the vinURL into a data object,
        //and then into a JSON object
        do{
            
            vehicleData = JSON(data: try Data(contentsOf: vinURL))
            
        } catch{
            
            vehicleData = JSON.null
            print("Could not create JSON")
        }
        
        VinRequest.vehicleImageCall(path: imagePath, vin: self.vin)
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
    
    func getVehicleImages(){
        
    }
}
