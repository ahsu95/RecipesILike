//
//  RecipesILikeTableViewCell.swift
//  Recipes
//
//  Created by Osman Balci on 10/8/17.
//  Copyright © 2017 Osman Balci. All rights reserved.
//

import UIKit

class RecipesILikeTableViewCell: UITableViewCell {
    
    // Instance variables holding the object references of the Table View Cell UI objects created in Storyboard
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var sourceNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

