//
//  AppError.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

enum AppError: Error {
    
    case api(error: ApiError)
    case generic(error: Error)
    
}
