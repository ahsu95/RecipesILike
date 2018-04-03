//
//  AddRecipeViewController.swift
//  Recipes
//
//  Created by Osman Balci on 10/8/17.
//  Copyright © 2017 Osman Balci. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController {
    
    // Instance variables holding the object references of the UI objects created in Storyboard
    @IBOutlet var recipeNameTextField: UITextField!
    @IBOutlet var recipeImageUrlTextField: UITextField!
    @IBOutlet var sourceNameTextField: UITextField!
    @IBOutlet var sourceWebsiteUrlTextField: UITextField!
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*
     ---------------------
     MARK: - Keyboard Done
     ---------------------
     */
    
    // This method is invoked when the user taps the Done key on the keyboard
    @IBAction func keyboardDone(_ sender: UITextField) {
        
        // Once the text field is no longer the first responder, the keyboard is removed
        sender.resignFirstResponder()
    }
    
    /*
     ------------------------------
     MARK: - User Tapped Background
     ------------------------------
     */
    @IBAction func userTappedBackground(sender: AnyObject) {
        /*
         "This method looks at the current view and its subview hierarchy for the text field that is
         currently the first responder. If it finds one, it asks that text field to resign as first responder.
         If the force parameter is set to true, the text field is never even asked; it is forced to resign." [Apple]
         */
        view.endEditing(true)
    }
    
}

