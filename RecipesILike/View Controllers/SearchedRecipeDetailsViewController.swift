//
//  SearchedRecipeDetailsViewController.swift
//  Recipes
//
//  Created by Osman Balci on 10/9/17.
//  Copyright © 2017 Osman Balci. All rights reserved.
//

import UIKit

class SearchedRecipeDetailsViewController: UIViewController {
    
    // Instance variables holding the object references of the UI objects created in Storyboard
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var sourceNameLabel: UILabel!
    @IBOutlet var dietLabelsLabel: UILabel!
    @IBOutlet var healthLabelsLabel: UILabel!
    @IBOutlet var ingredientLinesLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    
    // selectedRecipePassed is set by SearchResultsTableViewController
    var selectedRecipePassed = ""
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recipeData: [String] = selectedRecipePassed.components(separatedBy: "|")
        
        /*
         recipeData[0] = recipeName
         recipeData[1] = recipeImageURL
         recipeData[2] = sourceName
         recipeData[3] = sourceURL
         recipeData[4] = dietLabels
         recipeData[5] = healthLabels
         recipeData[6] = ingredientLines
         recipeData[7] = calories
         */
        
        recipeNameLabel.text = recipeData[0]
        
        // Set Recipe Image
        
        let url = URL(string: recipeData[1])
        let recipeImageData = try? Data(contentsOf: url!)
        
        if let imageData = recipeImageData {
            recipeImageView!.image = UIImage(data: imageData)
        } else {
            recipeImageView!.image = UIImage(named: "imageUnavailable.png")
        }
        
        sourceNameLabel.text = recipeData[2]
        dietLabelsLabel.text = recipeData[4]
        healthLabelsLabel.text = recipeData[5]
        ingredientLinesLabel.text = recipeData[6]
        caloriesLabel.text = recipeData[7]
    }
    
}

