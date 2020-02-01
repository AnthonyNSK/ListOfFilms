//
//  DetailsViewController.swift
//  ListOfFilms
//
//  Created by Kuzhelev Anton on 31.01.2020.
//  Copyright © 2020 Kuzhelev Anton. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingStringLabel: UILabel!
    
    
    var filmInfo : FilmInfo!

    func checkRating(rating: Double) -> UIColor? {
        if rating >= 7 {
            return UIColor(hexString: "#007b00")
        } else if (rating <= 6) && (rating >= 5) {
            return UIColor(hexString: "#5f5f5f")
        } else if rating < 5 {
            return UIColor(hexString: "#ff0b0b")
        }
        return UIColor.black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetails()
  
    }
    
    func showDetails() {
        navigationItem.title = filmInfo.localizedName
        
        let rating = filmInfo.rating
        if rating != nil {
            ratingLabel.text = String(rating!)
            ratingLabel.textColor =  checkRating(rating: rating!)
        } else {
            ratingLabel.text = ""
            ratingStringLabel.isHidden = true
        }
        nameLabel.text = filmInfo.name
        yearLabel.text = String(filmInfo.year)
        descriptionLabel.text = filmInfo.description
        
        DispatchQueue.main.async {
            guard let urlString = self.filmInfo.imageUrl,
            let url = URL(string: urlString),
            let data = try? Data(contentsOf: url) else {return}
            self.imageView.image = UIImage(data: data)
        }
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

