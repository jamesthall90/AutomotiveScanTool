//
//  history.swift
//  AutomotiveScanTool
//
//  Created by Stephen Lomangino on 12/1/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import Foundation

struct history {
    let date:String
    let code:String
    let codeDescription:String
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String,Any)
    }
    
    init(json:[String:Any]) throws {
        guard let date = json["storedCodes"] as? String else {throw SerializationError.missing("missing date")}
        guard let code = json["code"] as? String else {
            throw SerializationError.missing("missing code")
        }
        guard let codeDescription = json["codeDescription"] as? String else {
            throw SerializationError.missing("missing code description")
        }
        self.date = date
        self.code = code
        self.codeDescription = codeDescription
    }
}
