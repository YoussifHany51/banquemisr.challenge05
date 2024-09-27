//
//  NowPlayingViewController.swift
//  banquemisr.challenge05
//
//  Created by Youssif Hany on 26/09/2024.
//

import UIKit

class NowPlayingViewController: UIViewController {

    @IBOutlet weak var nowPlayingTableView: UITableView!
    let viewModel = MoviesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        
    }
    private func setUpData(){
        nowPlayingTableView.dataSource = self
        nowPlayingTableView.delegate = self
        navigationItem.title = "Now Playing"
        setupCell()
        loadData()
    }
    private func loadData(){
        viewModel.fetchData(movieType: .nowPlaying){ [weak self] in
            DispatchQueue.main.async {
                self?.nowPlayingTableView.reloadData()
            }
        }
    }
    private func setupCell(){
        let nowPlayingCellNib = UINib(nibName: "MoviesTableViewCell", bundle: nil)
        nowPlayingTableView.register(nowPlayingCellNib, forCellReuseIdentifier: "moviesCell")
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

extension NowPlayingViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! MoviesTableViewCell
        cell.titleLabel.text = viewModel.movies[indexPath.row].title
        cell.releaseDateLabel.text = "Release Date : \(viewModel.movies[indexPath.row].release_date)"
        
        let posterPath = viewModel.movies[indexPath.row].poster_path
        let imageUrl = "https://image.tmdb.org/t/p/w500\(posterPath)"
        loadImage(from: URL(string: imageUrl)!) { image in
            if let image = image {
                cell.imageLabel?.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
