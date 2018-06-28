//
//  Movie.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation

struct Movie: Decodable, Equatable {
    
    let id: ID
    let title: String
    let posterPath: String?
    let releaseDate: Date
    let voteAverage: Double
    let overview: String?
    
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }

}
