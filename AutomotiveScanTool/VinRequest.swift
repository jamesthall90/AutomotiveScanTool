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
    
    //Specifies how parameters are handled upon object initialization
    init(VIN : String) {
        
        self.vin = VIN
        
        //Sets passed-in VIN as parameter data to be used in POST / decode request
        parameters = [
            "data":"\(vin);",
            "format":"json"
        ]
        
        
        vinPath = "\(AppDelegate.getAppDelegate().getDocDir())/decoded-vin.json"
        
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
    }
    
    
    func getVehicleYear() -> String{
        
        //Pulls the vehicle year from the JSON file
        let vehicleYear =  vehicleData["Results"].arrayValue.map({$0["ModelYear"].stringValue}).first
        
        //Returns the vehicle year or a default string (if nil)
        return (vehicleYear ?? "Vehicle Year Not Specified")
    }
    
    
    func getVehicleMake() -> String{
        
        let vehicleMake =  vehicleData["Results"].arrayValue.map({$0["Make"].stringValue}).first
        
        //Returns the vehicle make or a default string (if nil)
        return (vehicleMake?.uppercased() ?? "Vehicle Make Not Specified")
    }
    
    
    func getVehicleModel() -> String{
        
        let vehicleModel =  vehicleData["Results"].arrayValue.map({$0["Model"].stringValue}).first
        
        //Returns the vehicle model or a default string (if nil)
        return (vehicleModel?.uppercased() ?? "Vehicle Model Not Specified")
    }
    
    
    func getVehicleVIN() -> String{
        
        let vehicleVIN =  vehicleData["Results"].arrayValue.map({$0["VIN"].stringValue}).first
        
        //Returns the vehicle's VIN or a default string (if nil)
        return (vehicleVIN?.uppercased() ?? "")
    }
    
    
    func getVehicleType() -> String{
        
        let vehicleType =  vehicleData["Results"].arrayValue.map({$0["VehicleType"].stringValue}).first
        
        //Returns the vehicle's VIN or a default string (if nil)
        return (vehicleType?.uppercased() ?? "Vehicle Type Not Specified")
    }
    
    
    func getVehicleDriveType() -> String{
        
        let vehicleDriveType =  vehicleData["Results"].arrayValue.map({$0["DriveType"].stringValue}).first
        
        //Returns the vehicle's Drive Type or a default string (if nil)
        return (vehicleDriveType?.uppercased() ?? "Vehicle Drive Type Not Specified")
    }
    
    
    func getEngineSize() -> String{
        
        let engineDisplacement =  vehicleData["Results"].arrayValue.map({$0["DisplacementL"].stringValue}).first
        
        //Returns the vehicle's Engine Size / Displacement or a default string (if nil)
        return(engineDisplacement?.uppercased() ?? "Engine Displacement Not Specified".uppercased())
    }
}
