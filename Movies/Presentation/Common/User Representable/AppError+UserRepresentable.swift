//
//  AppError+UserRepresentable.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/28/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

extension AppError: UserRepresentable {
    
    var userMessage: String {
        switch self {
        case .api(let error):
            return error.userMessage
        case .generic(let error):
            return error.localizedDescription
        }
    }
    
}
