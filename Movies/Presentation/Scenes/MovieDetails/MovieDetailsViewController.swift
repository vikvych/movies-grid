//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/28/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import UIKit
import AlamofireImage
import Layoutless

private let itemMinWidth: Length = 120.0
private let offset: Length = 16.0

protocol MovieDetailsFlowCoordinator: class {
    
    func back()
    
}

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    static let nibName = String(describing: MovieDetailsViewController.self)
    
    weak var flowCoordinator: MovieDetailsFlowCoordinator!
    var viewModel: MovieDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movie = viewModel.movie
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        scrollView.contentInsetAdjustmentBehavior = .always
        titleLabel.text = movie.title
        reviewLabel.text = movie.overview
        scoreLabel.text = String(format: "%.2f", movie.voteAverage)
        releaseDateLabel.text = formatter.string(from: movie.releaseDate)
        posterView.layer.masksToBounds = true
        posterView.layer.cornerRadius = 4.0
        
        if  let path = movie.posterPath,
            let url = ImageManager.imageUrl(for: path, type: .poster, width: Int(itemMinWidth.cgFloatValue * view.traitCollection.displayScale)) {
            posterView.af_setImage(withURL: url, imageTransition: UIImageView.ImageTransition.crossDissolve(0.25)) { [weak self] result in
                guard let image = result.value else { return }
                
                self?.backgroundImageView.image = image
            }
        }
        
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        let titleLabel = UILabel(style: CommonStyles.navigationTitleLabel)
        titleLabel.text = viewModel.movie.title
        navigationItem.titleView = titleLabel
    }
    
}
