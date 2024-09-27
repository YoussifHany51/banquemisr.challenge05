//
//  Movie.swift
//  banquemisr.challenge05
//
//  Created by Youssif Hany on 26/09/2024.
//

import Foundation

struct Movie : Codable{
    let id : Int
    let title : String
    let overview : String
    let release_date : String
    let poster_path : String
    let genre_ids : [Int]
    
}
