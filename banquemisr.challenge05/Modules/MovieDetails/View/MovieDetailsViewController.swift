//
//  MovieDetailsViewController.swift
//  banquemisr.challenge05
//
//  Created by Youssif Hany on 28/09/2024.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movie : Movie?
    var viewModel : MovieDetailViewModel?
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var backbuttonRef: UIButton!
    
    @IBOutlet weak var movieVote: UILabel!
    
    @IBOutlet weak var movieDate: UILabel!
    
    @IBOutlet weak var movieLang: UILabel!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieDesc: UILabel!
    
    @IBOutlet weak var movieAdult: UILabel!
    
    @IBOutlet weak var movieDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movie?.original_title
        navigationItem.hidesBackButton = true
        setupData()
        
    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupData(){
        let vote = (movie!.vote_average / 10 ) * 100
        movieVote.text = viewModel?.formatPercentage(from: vote)
        movieVote.textColor = .systemGreen
        movieDate.text = viewModel?.stringToDate(movie!.release_date)
        movieDescription.text = movie?.overview
        movieLang.text = movie!.original_language
        movieTitle.text = movie?.title
        movieAdult.text = movie!.adult ? "+18" : "R"
        backbuttonRef.tintColor = .lightGray
        

        guard let imagePath = movie?.poster_path else{return}
        let imageUrl = "https://image.tmdb.org/t/p/w500\(imagePath)"
        setupImageView(with: URL(string: imageUrl)!, imageView: movieImage)
        
    }
    
    func setupImageView(with url: URL, imageView: UIImageView) {
        viewModel?.loadImageData(from: url) { data in
                if let data = data, let image = UIImage(data: data) {
                    imageView.image = image
                }
            }
        }
}
