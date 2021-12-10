//
//  EndPoints.swift
//  OMDB
//
//  Created by user193869 on 05/12/21.
//

import Foundation

enum EndPoints {
    case Search
}

extension EndPoints {
    var path:String {
        let baseURL = "http://www.omdbapi.com"
        
        struct Section {
            static let search = "/?"
        }
        
        switch(self) {
        case .Search:
            return "\(baseURL)\(Section.search)"

        }
        
    }
    
}
