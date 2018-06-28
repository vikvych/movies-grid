//
//  MovieCell.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import UIKit
import Layoutless

private let offset: Length = 12.0

class MovieCell: CollectionViewCell {
    
    let titleLabel = UILabel(style: Stylesheet.titleLabel)
    let posterView = UIImageView(style: Stylesheet.posterView)
    
    override var subviewsLayout: AnyLayout {
        return UIView(style: Stylesheet.shadowView)
            .addingLayout(
                UIView(style: Stylesheet.contentView)
                    .addingLayout(titleLabel.stickingToParentEdges(left: offset, right: offset, bottom: offset))
                    .addingLayout(posterView.fillingParent())
                    .fillingParent()
            )
            .fillingParent()
    }
    
}

extension MovieCell {
    
    struct Stylesheet {
        
        static let shadowView = Style<UIView> {
            $0.layer.masksToBounds = false
            $0.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            $0.layer.shadowRadius = 4.0
            $0.layer.shadowOpacity = 0.5
        }
        
        static let contentView = Style<UIView> {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 4.0
            $0.backgroundColor = .groupTableViewBackground
        }
        
        static let titleLabel = Style<UILabel> {
            $0.numberOfLines = 3
            $0.font = .systemFont(ofSize: 18.0, weight: .medium)
            $0.textColor = .darkGray
        }
        
        static let posterView = Style<UIImageView> {
            $0.contentMode = .scaleAspectFill
        }
        
    }
    
}
