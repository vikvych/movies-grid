//
//  ImageManager.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/28/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

private let imageWidthOriginal = "original"

enum ImageType {
    case poster
}

struct ImageManager {
    
    static var availableWidths = [
        ImageType.poster: [45, 92, 154, 185, 300, 500]
    ]
    
    static func imageUrl(for path: String, type: ImageType, width: Int?) -> URL? {
        guard let url = URL(string: ApiConfig.imageEndpoint) else { return nil }
        
        return url
            .appendingPathComponent(queryWidth(for: width, type: type))
            .appendingPathComponent(path)
    }
    
    private static func queryWidth(for width: Int?, type: ImageType) -> String {
        guard
            let width = width,
            let available = ImageManager.availableWidths[type]
            else { return imageWidthOriginal }
        
        for w in available {
            if width < w {
                return "w\(w)"
            }
        }
        
        return imageWidthOriginal
    }
    
}
