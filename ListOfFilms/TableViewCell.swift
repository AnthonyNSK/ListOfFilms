//
//  TableViewCell.swift
//  ListOfFilms
//
//  Created by Kuzhelev Anton on 01.02.2020.
//  Copyright © 2020 Kuzhelev Anton. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var localizedNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var filmInfo : FilmInfo! { didSet {
        localizedNameLabel.text = filmInfo.localizedName
        let rating = filmInfo.rating
        if rating != nil {
            ratingLabel.text = String(rating!)
            ratingLabel.textColor =  checkRating(rating: rating!)
        } else { ratingLabel.text = "" }
        nameLabel.text = filmInfo.name
        
        }
    }
    
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
