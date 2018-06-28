//
//  Strings.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

struct Strings {
    
    struct Action {
        
        static let cancel = "Cancel"
        static let retry = "Retry"
        
    }
    
    struct Error {
        
        static let errorOccurred = "An error occurred"
        
        static let invalidDateFormat = "Invalid date format"
        
        static let apiNetworkErrorFormat = "Network request failed cause: %@"
        static let apiInvalidParams = "Invalid params"
        static let apiEmptyResponse = "Server returned empty response"
        static let apiFailedToParse = "Failed to to parse network response: %@"

        
    }
    
    struct Movies {
        
        static let latestMovies = "Latest Movies"
        
    }
    
}
