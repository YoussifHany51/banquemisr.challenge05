//
//  MoviesListViewController.swift
//  banquemisr.challenge05
//
//  Created by Youssif Hany on 29/09/2024.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var moviesTableView: UITableView!
    let viewModel = MoviesViewModel()
    var movieType : NetworkManager.MovieType!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        
    }
    private func setUpData(){
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        navigationItem.title = setUpNavigationTitle(movieTypeRawValue: movieType.rawValue)
        setupCell()
        loadData()
    }
    private func loadData(){
        viewModel.fetchData(movieType: movieType){ [weak self] in
            DispatchQueue.main.async {
                self?.moviesTableView.reloadData()
            }
        }
    }
    private func setupCell(){
        let moviesCellNib = UINib(nibName: "MoviesTableViewCell", bundle: nil)
        moviesTableView.register(moviesCellNib, forCellReuseIdentifier: "moviesCell")
    }
    private func setUpNavigationTitle(movieTypeRawValue:String) -> String{
        switch movieTypeRawValue {
        case "now_playing":
            return "Now Playing"
        case "popular":
            return "Popular"
        default:
            return "Upcoming"
        }
    }
    private func updateImageView(with url: URL, imageView: UIImageView) {
        viewModel.loadImageData(from: url) { data in
            if let data = data, let image = UIImage(data: data) {
                imageView.image = image
            }
        }
    }
}

extension MoviesListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! MoviesTableViewCell
        cell.titleLabel.text = viewModel.movies[indexPath.row].title
        cell.releaseDateLabel.text = "Release Date : \(viewModel.movies[indexPath.row].release_date)"
        
        let posterPath = viewModel.movies[indexPath.row].poster_path
        let imageUrl = "https://image.tmdb.org/t/p/w500\(posterPath)"
        updateImageView(with:  URL(string: imageUrl)!, imageView: cell.imageLabel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        vc.movie = movie
        vc.viewModel = MovieDetailViewModel()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
