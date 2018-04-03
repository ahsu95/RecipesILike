//
//  SearchRecipesViewController.swift
//  Recipes
//
//  Created by Osman Balci on 10/8/17.
//  Copyright © 2017 Osman Balci. All rights reserved.
//

import UIKit

class SearchRecipesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Instance variables holding the object references of the UI objects created in Storyboard
    @IBOutlet var searchQueryTextField: UITextField!
    @IBOutlet var dietLabelPickerView: UIPickerView!
    @IBOutlet var healthLabelPickerView: UIPickerView!
    @IBOutlet var maxNumberSegmentedControl: UISegmentedControl!
    
    // Arrays holding constant Picker View data
    let dietLabelPickerData = ["balanced","high-fiber", "high-protein", "low-carb", "low-fat", "low-sodium"]
    let healthLabelPickerData = ["dairy-free","egg-free", "fat-free", "fish-free", "gluten-free", "low-sugar", "paleo",
                                 "peanut-free", "shellfish-free", "soy-free", "tree-nut-free", "vegan", "vegetarian", "wheat-free"]
    
    /*
     Dr. Balci's App ID and App Key. Do NOT use!
     Register as a developer for Recipe Search API at https://developer.edamam.com/,
     obtain your own App ID and App Key, and use them in your app.
     */
    let edamamAppID = "f077da94"
    let edamamAppKey = "d444c85f2d375f21f154e04c41e3b47a"
    
    var apiQuery = ""
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search Recipes"
        
        // Show Diet Label Picker View middle row as the selected one
        dietLabelPickerView.selectRow(Int(dietLabelPickerData.count / 2), inComponent: 0, animated: false)
        
        // Show Health Label Picker View middle row as the selected one
        healthLabelPickerView.selectRow(Int(healthLabelPickerData.count / 2), inComponent: 0, animated: false)
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
    
    /*
     ----------------------------
     MARK: - Search Button Tapped
     ----------------------------
     */
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        
        // Obtain the search query entered by the user
        let searchQueryEntered = searchQueryTextField.text
        
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let searchQueryTrimmed = searchQueryEntered?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Replace all occurrences of space within the search query with +
        let searchQuery = searchQueryTrimmed?.replacingOccurrences(of: " ", with: "+")
        
        // Obtain Diet Label Picker View's selected row number
        let dietRowNumber = dietLabelPickerView.selectedRow(inComponent: 0)
        
        // Obtain the diet label selected by the user
        let dietLabel = dietLabelPickerData[dietRowNumber]
        
        // Obtain Health Label Picker View's selected row number
        let healthRowNumber = healthLabelPickerView.selectedRow(inComponent: 0)
        
        // Obtain the health label selected by the user
        let healthLabel = healthLabelPickerData[healthRowNumber]
        
        // User selects the maximum number of recipes to be returned from the Edamam API
        var maximumNumber: String?
        
        switch maxNumberSegmentedControl.selectedSegmentIndex {
        case 0:
            maximumNumber = "10"
        case 1:
            maximumNumber = "20"
        case 2:
            maximumNumber = "30"
        case 3:
            maximumNumber = "40"
        case 4:
            maximumNumber = "50"
        default:
            print("Segmented Control is out of range!")
        }
        
        // Compose the Edamam API Query string
        apiQuery = "https://api.edamam.com/search?q=\(searchQuery!)&appid=\(edamamAppID)&app_key=\(edamamAppKey)&from=0&to=\(maximumNumber!)&diet=\(dietLabel)&health=\(healthLabel)"
        
        performSegue(withIdentifier: "Search Results", sender: self)
    }
    
    /*
     ---------------------------------------
     MARK: - Picker View Data Source Methods
     ---------------------------------------
     */
    
    // Specifies how many components in the Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Specifies how many rows in the Picker View component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // Tag number is set in the Storyboard: 1 for dietLabelPickerView and 2 for healthLabelPickerView
        // We use Swift's ternary conditional operator:
        
        return pickerView.tag == 1 ? dietLabelPickerData.count : healthLabelPickerData.count
    }
    
    /*
     -----------------------------------
     MARK: - Picker View Delegate Method
     -----------------------------------
     */
    
    // Specifies title for a row in the Picker View component
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // Tag number is set in the Storyboard: 1 for dietLabelPickerView and 2 for healthLabelPickerView
        // We use Swift's ternary conditional operator:
        
        return pickerView.tag == 1 ? dietLabelPickerData[row] : healthLabelPickerData[row]
    }
    
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegue
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Search Results" {
            
            // Obtain the object reference of the destination view controller
            let searchResultsTableViewController: SearchResultsTableViewController = segue.destination as! SearchResultsTableViewController
            
            // Pass the data object to the destination view controller
            searchResultsTableViewController.apiQueryPassed = apiQuery
        }
    }
    
}

