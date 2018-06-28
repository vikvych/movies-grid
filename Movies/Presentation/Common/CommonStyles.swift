//
//  CommonStyles.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/28/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import Layoutless

struct CommonStyles {
    
    static let navigationTitleLabel = Style<UILabel> {
        $0.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
        $0.textColor = UIColor(red: 147.0 / 255.0, green: 154.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
    }
    
}
