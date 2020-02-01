//
//  Model.swift
//  ListOfFilms
//
//  Created by Kuzhelev Anton on 31.01.2020.
//  Copyright © 2020 Kuzhelev Anton. All rights reserved.
//

import UIKit

class Model: NSObject {
    
    
    
    func loadData(completionHandler:  ((_ fullSortedArray: [[FilmInfo]]?, _ error: String?) -> Void)?) {
        guard let url = URL(string: "https://s3-eu-west-1.amazonaws.com/sequeniatesttask/films.json") else { return }
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, responce, error) in
            
            if let responce = responce {
                print(responce)
            }
            guard error == nil else { completionHandler?(nil, error?.localizedDescription)
                return }
            guard let data = data else { return }
   
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard let results = json as? [String : AnyObject],
                    let filmsArray = results["films"] as? [[String: AnyObject]] else {return}
                var filmsInfoArray : [FilmInfo] = []
                
                for film in filmsArray {
                    guard let filmName = film["name"] as? String,
                     let filmYear = film["year"] as? Int else {break}
                    
                        let filmLocalizedName = film["localized_name"] as? String
                        let filmRating = film["rating"] as? Double
                        let filmDescription = film["description"] as? String
                        let filmImageUrl = film["image_url"] as? String
                    let filmInfo = FilmInfo(localizedName: filmLocalizedName, name: filmName, rating: filmRating, year: filmYear, imageUrl: filmImageUrl, description: filmDescription)
                    filmsInfoArray.append(filmInfo)
                }
               let fullSortedArray  = self.sortFilms(filmsArray: filmsInfoArray)
                print(fullSortedArray)
                completionHandler?(fullSortedArray, nil)
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    func sortFilms(filmsArray: [FilmInfo]) -> [[FilmInfo]] {

        let dividedByYearFilmsArray = sortFilmsByYear(filmsArray: filmsArray)
        let fullSortedArray = sortFilmsByRating(dividedByYearFilmsArray: dividedByYearFilmsArray)
        
        return fullSortedArray
    }
    
    func sortFilmsByYear(filmsArray: [FilmInfo]) -> [[FilmInfo]] {
        var sortedArrayOfFilms = filmsArray.sorted(by: {$0.year < $1.year})
        var dividedByYearFilmsArray : [[FilmInfo]] = []
        
        var currentYear = sortedArrayOfFilms[0].year
        var arrayOfFilmsOfOneYear : [FilmInfo] = []
        
        for film in sortedArrayOfFilms {
            if film.year == currentYear {
              let element = sortedArrayOfFilms.removeFirst()
                arrayOfFilmsOfOneYear.append(element)
            } else {
                dividedByYearFilmsArray.append(arrayOfFilmsOfOneYear)
                arrayOfFilmsOfOneYear.removeAll()
                currentYear = film.year
                let element = sortedArrayOfFilms.removeFirst()
                arrayOfFilmsOfOneYear.append(element)
            }
        }
        dividedByYearFilmsArray.append(arrayOfFilmsOfOneYear)
        
        return dividedByYearFilmsArray
    }
    
    func sortFilmsByRating(dividedByYearFilmsArray: [[FilmInfo]]) -> [[FilmInfo]] {
        var fullSortedArray = dividedByYearFilmsArray
        var i = 0
        for arrayOfFilmsOfOneYear in dividedByYearFilmsArray {
           let newArray = arrayOfFilmsOfOneYear.sorted{ (film1, film2) -> Bool in
                guard let rating1 = film1.rating,
                    let rating2 = film2.rating else {return false}
                return rating1 > rating2 }
            fullSortedArray.remove(at: i)
            fullSortedArray.insert(newArray, at: i)
            i+=1
        }
        return fullSortedArray
    }
    
}
