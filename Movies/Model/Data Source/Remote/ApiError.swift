//
//  ApiError.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

enum ApiError: Error {
    
    case invalidParams
    case emptyResponse
    case networkError(error: Error)
    case failedToParse(error: Error)
    
}
