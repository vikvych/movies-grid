//
//  MoviesViewController.swift
//  Movies
//
//  Created by Ivan Tkachenko on 6/27/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import UIKit
import AlamofireImage
import Layoutless
import ReactiveKit
import Bond

private let offset: CGFloat = 16.0
private let itemMinWidth: CGFloat = 120.0

protocol MoviesFlowCoordinator: class {
    
    func showMovieDetails(movie: Movie)
    
}

class MoviesViewController: UIViewController {

    weak var flowCoordinator: MoviesFlowCoordinator!
    var viewModel: MoviesViewModel!
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = offset
        layout.minimumInteritemSpacing = offset
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func loadView() {
        super.loadView()
        
        collectionView.delegate = self
        collectionView
            .styled(with: Stylesheet.collectionView)
            .fillingParent()
            .layout(in: view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageWidth = Int(itemMinWidth * view.traitCollection.displayScale)
        
        viewModel.movies().diff().bind(to: collectionView, cellType: MovieCell.self) { cell, movie in
            cell.titleLabel.text = movie.title
            cell.posterView.image = nil
            
            if  let path = movie.posterPath,
                let url = ImageManager.imageUrl(for: path, type: .poster, width: imageWidth) {
                cell.posterView.af_setImage(withURL: url, imageTransition: UIImageView.ImageTransition.crossDissolve(0.25))
            }
        }
        
        viewModel.queryMovies().bind(to: self) { me, state in
            switch state {
            case .loading:
//                TODO: Implement loading animation
                break
            case .loaded:
                break
            case .failed(let error):
//                TODO: Implement more user friendly error handling
                me.showError(error) { me.viewModel.requery() }
            }
        }
        
        setupNavigationItem()
    }

    private func setupNavigationItem() {
        let titleLabel = UILabel(style: CommonStyles.navigationTitleLabel)
        titleLabel.text = Strings.Movies.latestMovies
        navigationItem.titleView = titleLabel
    }
    
    private func showError(_ error: AppError, retry: (() -> Void)? = nil) {
        let alert = UIAlertController(title: Strings.Error.errorOccurred, message: error.userMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Strings.Action.cancel, style: .cancel, handler: nil))
        
        if let retry = retry {
            alert.addAction(UIAlertAction(title: Strings.Action.retry, style: .default) { _ in
                retry()
            })
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        flowCoordinator.showMovieDetails(movie: viewModel.items.value[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            viewModel.queryNext()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = floor((collectionView.bounds.width - offset) / (itemMinWidth + offset))
        let width = floor((collectionView.bounds.width - offset) / count - offset)
        let height = floor(width * 3 / 2)
        
        return CGSize(width: width, height: height)
    }
    
}

extension MoviesViewController {
    
    struct Stylesheet {
        
        static let test = Style<UIView> {
            $0.backgroundColor = .blue
        }
        
        static let collectionView = Style<UICollectionView> {
            $0.backgroundColor = .white
            $0.alwaysBounceVertical = true
            $0.contentInset = UIEdgeInsetsMake(offset, offset, offset, offset)
        }
        
    }
    
}
