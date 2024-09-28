//
//  MovieDetailViewModel.swift
//  banquemisr.challenge05
//
//  Created by Youssif Hany on 28/09/2024.
//

import Foundation

class MovieDetailViewModel{
    func stringToDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // Convert the string to a Date object
        if let date = dateFormatter.date(from: dateString) {
            // Create a new DateFormatter to extract only the year
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            
            // Get the year as a string
            let yearString = yearFormatter.string(from: date)
            return yearString  // Output: "2024"
        } else {
            print("Invalid date format")
        }
        return ""
    }
    func formatPercentage(from value: Double) -> String {
        // Create a NumberFormatter to format the percentage
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 0 // No decimal places

        // Convert the integer value to a percentage string
        let percentageValue = Double(value) / 100
        if let percentageString = numberFormatter.string(from: NSNumber(value: percentageValue)) {
            return "\(percentageString) match"
        } else {
            return "Invalid Value"
        }
    }
    func loadImageData(from url: URL, completion: @escaping (Data?) -> Void) {
           DispatchQueue.global().async {
               if let data = try? Data(contentsOf: url) {
                   DispatchQueue.main.async {
                       completion(data)
                   }
               } else {
                   DispatchQueue.main.async {
                       completion(nil)
                   }
               }
           }
       }
}
