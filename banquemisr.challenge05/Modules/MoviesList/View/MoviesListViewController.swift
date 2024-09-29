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
    var refresh = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        refresh.tintColor = .gray
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        moviesTableView.addSubview(refresh)
    }
    private func setUpData(){
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        navigationItem.title = viewModel.setUpNavigationTitle(movieTypeRawValue: movieType.rawValue)
        setupCell()
        loadData()
    }
    @objc private func loadData(){
        moviesTableView.isHidden = true
        viewModel.fetchData(movieType: movieType){ [weak self] in
            DispatchQueue.main.async {
                self?.moviesTableView.isHidden = false
                self?.refresh.endRefreshing()
                self?.moviesTableView.reloadData()
            }
        }
    }
    private func setupCell(){
        let moviesCellNib = UINib(nibName: "MoviesTableViewCell", bundle: nil)
        moviesTableView.register(moviesCellNib, forCellReuseIdentifier: "moviesCell")
    }
    
    private func updateImageView(with url: URL, for indexPath: IndexPath) {
            viewModel.loadImageData(from: url) { [weak self] data in
                DispatchQueue.main.async {
                    // Ensure the cell is still visible and hasn't been reused
                    if let visibleCell = self?.moviesTableView.cellForRow(at: indexPath) as? MoviesTableViewCell,
                       let data = data, let image = UIImage(data: data) {
                        visibleCell.imageLabel.image = image
                    }
                }
            }
        }

}

extension MoviesListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! MoviesTableViewCell
        let movie = viewModel.movies[indexPath.row]
        cell.titleLabel.text = viewModel.movies[indexPath.row].title
        cell.releaseDateLabel.text = "Release Date : \(viewModel.movies[indexPath.row].release_date)"
        
        cell.imageLabel.image = UIImage(named: "placeholder")
        
        if let cachedMovieEntity = CoreDataManager.shared.fetchCachedMovie(by: movie.id),
           let imageData = cachedMovieEntity.posterImage {
            cell.imageLabel.image = UIImage(data: imageData)
        } else {
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)") {
                updateImageView(with: imageUrl, for: indexPath)
            }
        }
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
