//
//  RecipeDetailsViewController.swift
//  Recipes
//
//  Created by Osman Balci on 10/8/17.
//  Copyright © 2017 Osman Balci. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    // recipeDataPassed is set by RecipesILikeTableViewController
    var recipeDataPassed = [String]()
    
    // Instance variables holding the object references of the UI objects created in Storyboard
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var sourceUrlLabel: UILabel!
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set source name to be the scene title
        self.title = recipeDataPassed[2]
        
        // Set recipe name
        recipeNameLabel.text = recipeDataPassed[0]
        
        // Set recipe image
        let url = URL(string: recipeDataPassed[1])
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            recipeImageView!.image = UIImage(data: imageData)
        } else {
            recipeImageView!.image = UIImage(named: "imageUnavailable")
        }
        
        // Set the source website URL
        sourceUrlLabel.text = recipeDataPassed[3]
    }
    
}

