//
//  Extensions.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 9/29/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation


// MARK: - Mixed string utils and helpers
extension String {
    
    
    /**
     Encode a String to Base64
     
     :returns:
     */
    public func toBase64()->String{
        
        let data = self.data(using: String.Encoding.utf8)
        
        return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
    }
    
}
