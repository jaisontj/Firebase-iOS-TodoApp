//
//  Extension-Date.swift
//  Firebase-iOS
//
//  Created by Jaison on 11/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

extension Date {
    
    var getString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            return dateFormatter.string(from: self)
        }
    }
    
}
