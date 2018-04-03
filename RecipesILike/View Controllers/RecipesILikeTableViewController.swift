//
//  RecipesILikeTableViewController.swift
//  Recipes
//
//  Created by Osman Balci on 10/8/17.
//  Copyright © 2017 Osman Balci. All rights reserved.
//

import UIKit

class RecipesILikeTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    // Obtain the object reference of the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // These two instance variables are used for Search Bar functionality
    var searchResults = [String]()
    var searchResultsController = UISearchController()
    
    let tableViewRowHeight: CGFloat = 60.0
    
    // Alternate table view rows have a background color of MintCream or OldLace for clarity of display
    
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    //---------- Create and Initialize the Arrays ---------------------
    
    var dataOfSelectedRecipe = [String]()
    
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Set up the Edit button on the left of the navigation bar to enable editing of the table view rows
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Set up the Add button on the right of the navigation bar to call the addCity method when tapped
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(RecipesILikeTableViewController.addRecipe(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        // Create a Search Results Controller object for the Search Bar
        createSearchResultsController()
        print(applicationDelegate.arrayOfRecipesILike)
    }
    
    /*
     -------------------------
     MARK: - Add Recipe Method
     -------------------------
     */
    
    // The addRecipe method is invoked when the user taps the Add (+) button
    @objc func addRecipe(_ sender: AnyObject) {
        
        // Perform the segue named Add New Recipe
        performSegue(withIdentifier: "Add New Recipe", sender: self)
    }
    
    /*
     ---------------------------
     MARK: - Unwind Segue Method
     ---------------------------
     */
    @IBAction func unwindToRecipesILikeTableViewController (segue : UIStoryboardSegue) {
        
        if segue.identifier == "AddRecipe-Save" {
            
            // Obtain the object reference of the source view controller
            let addRecipeViewController: AddRecipeViewController = segue.source as! AddRecipeViewController
            
            // Get the recipe name entered by the user on the AddRecipeViewController's UI
            let recipeNameEntered:          String = addRecipeViewController.recipeNameTextField.text!
            let recipeImageUrlEntered:      String = addRecipeViewController.recipeImageUrlTextField.text!
            let sourceNameEntered:          String = addRecipeViewController.sourceNameTextField.text!
            let sourceWebsiteUrlEntered:    String = addRecipeViewController.sourceWebsiteUrlTextField.text!
            
            // Input Data Validation
            if recipeNameEntered.isEmpty || recipeImageUrlEntered.isEmpty  || sourceNameEntered.isEmpty  || sourceWebsiteUrlEntered.isEmpty  {
                
                showAlertMessage(messageHeader: "Missing Data!", messageBody: "Please enter all values required!")
                return
            }
            
            // Remove the first and last spaces from the entered values
            let newRecipe = recipeNameEntered.trimmingCharacters(in: .whitespacesAndNewlines) + "|" +
                recipeImageUrlEntered.trimmingCharacters(in: .whitespacesAndNewlines) + "|" +
                sourceNameEntered.trimmingCharacters(in: .whitespacesAndNewlines) + "|" +
                sourceWebsiteUrlEntered.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Add the new recipe to the arrayOfRecipesILike
            applicationDelegate.arrayOfRecipesILike.add(newRecipe)
            
            // Reload the table view to include the newly added recipe
            self.tableView.reloadData()
        }
    }
    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertControllerStyle.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     ---------------------------------------------
     MARK: - Creation of Search Results Controller
     ---------------------------------------------
     */
    func createSearchResultsController() {
        /*
         Instantiate a UISearchController object and store its object reference into local variable: controller.
         Setting the parameter searchResultsController to nil implies that the search results will be displayed
         in the same view used for searching (under the same UITableViewController object).
         */
        let controller = UISearchController(searchResultsController: nil)
        
        /*
         We use the same table view controller (self) to also display the search results. Therefore,
         set self to be the object responsible for listing and updating the search results.
         Note that we made self to conform to UISearchResultsUpdating protocol.
         */
        controller.searchResultsUpdater = self
        
        /*
         The property dimsBackgroundDuringPresentation determines if the underlying content is dimmed during
         presentation. We set this property to false since we are presenting the search results in the same
         view that is used for searching. The "false" option displays the search results without dimming.
         */
        controller.dimsBackgroundDuringPresentation = false
        
        // Resize the search bar object based on screen size and device orientation.
        controller.searchBar.sizeToFit()
        
        /***************************************************************************
         No need to create the search bar in the Interface Builder (storyboard file).
         The statement below creates it at runtime.
         ***************************************************************************/
        
        // Set the tableHeaderView's accessory view displayed above the table view to display the search bar.
        self.tableView.tableHeaderView = controller.searchBar
        
        /*
         Set self (Table View Controller) define the presentation context so that the Search Bar subview
         does not show up on top of the view (scene) displayed by a downstream view controller.
         */
        self.definesPresentationContext = true
        
        /*
         Set the object reference (controller) of the newly created and dressed up UISearchController
         object to be the value of the instance variable searchResultsController.
         */
        searchResultsController = controller
    }
    
    /*
     -----------------------------------------------
     MARK: - UISearchResultsUpdating Protocol Method
     -----------------------------------------------
     
     This UISearchResultsUpdating protocol required method is automatically called whenever the search
     bar becomes the first responder or changes are made to the text or scope of the search bar.
     You must perform all required filtering and updating operations inside this method.
     */
    func updateSearchResults(for searchController: UISearchController)
    {
        // Empty the instance variable searchResults array without keeping its capacity
        searchResults.removeAll(keepingCapacity: false)
        
        // Set searchPredicate to search for any character(s) the user enters into the search bar.
        // [c] indicates that the search is case insensitive.
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        // Obtain the recipes that contain the character(s) the user types into the Search Bar.
        let listOfRecipesFound = applicationDelegate.arrayOfRecipesILike.filtered(using: searchPredicate)
        
        // Obtain the search results as an array of type String
        searchResults = listOfRecipesFound as! [String]
        
        // Reload the table view to display the search results
        self.tableView.reloadData()
    }
    
    /*
     --------------------------------------
     MARK: - Table View Data Source Methods
     --------------------------------------
     */
    
    /*
     A Table View object (UITableView) consists of Sections.
     A Section consists of Rows.
     A Row contains one Cell object (UITableViewCell).
     A Cell object is configured with the UI objects (e.g., image, text, accessory icon) to create the look of a row.
     */
    
    // Asks the data source to return the number of sections in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    // Asks the data source to return the number of rows in a section, the number of which is given
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Use the Ternary Conditional Operator to concisely represent the IF statement below.
        return searchResultsController.isActive ? searchResults.count : applicationDelegate.arrayOfRecipesILike.count
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowNumber: Int = (indexPath as NSIndexPath).row    // Identify the row number
        
        if (searchResultsController.isActive) {
            
            /********************************
             The user is using the Search Bar
             *******************************/
            
            // Obtain the object reference of a reusable table view cell object instantiated under the identifier
            // "Recipe Cell", which was specified in the storyboard
            let cell: RecipesILikeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Recipe Cell") as! RecipesILikeTableViewCell
            
            let recipeAtRowNumber = searchResults[rowNumber]
            
            let recipeData: [String] = (recipeAtRowNumber as AnyObject).components(separatedBy: "|")
            
            /*
             recipeData[0] = Recipe Name
             recipeData[1] = Recipe Image File URL
             recipeData[2] = Source Name
             recipeData[3] = Source Name URL
             */
            
            // Set Recipe Name
            cell.recipeNameLabel!.text = recipeData[0]
            
            // Set Recipe Image
            
            let url = URL(string: recipeData[1])
            let recipeImageData = try? Data(contentsOf: url!)
            
            if let imageData = recipeImageData {
                cell.recipeImageView!.image = UIImage(data: imageData)
            } else {
                cell.recipeImageView!.image = UIImage(named: "imageUnavailable.png")
            }
            
            // Set Source Name
            cell.sourceNameLabel!.text = recipeData[2]
            
            return cell
        }
        else {
            
            /********************************
             The user is using the Table View
             *******************************/
            
            // Obtain the object reference of a reusable table view cell object instantiated under the identifier
            // "Recipe Cell", which was specified in the storyboard
            let cell: RecipesILikeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Recipe Cell") as! RecipesILikeTableViewCell
            
            let recipeAtRowNumber = applicationDelegate.arrayOfRecipesILike[rowNumber]
            
            let recipeData: [String] = (recipeAtRowNumber as AnyObject).components(separatedBy: "|")
            
            /*
             recipeData[0] = Recipe Name
             recipeData[1] = Recipe Image File URL
             recipeData[2] = Source Name
             recipeData[3] = Source Name URL
             */
            
            // Set Recipe Name
            cell.recipeNameLabel!.text = recipeData[0]
            
            // Set Recipe Image
            
            let url = URL(string: recipeData[1])
            let recipeImageData = try? Data(contentsOf: url!)
            
            if let imageData = recipeImageData {
                cell.recipeImageView!.image = UIImage(data: imageData)
            } else {
                cell.recipeImageView!.image = UIImage(named: "imageUnavailable.png")
            }
            
            // Set Source Name
            cell.sourceNameLabel!.text = recipeData[2]
            
            return cell
        }
        
    }
    
    /*
     -----------------------------------
     MARK: - Table View Delegate Methods
     -----------------------------------
     */
    
    // Asks the table view delegate to return the height of a given row.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableViewRowHeight
    }
    
    /*
     Informs the table view delegate that the table view is about to display a cell for a particular row.
     Just before the cell is displayed, we change the cell's background color as MINT_CREAM for even-numbered rows
     and OLD_LACE for odd-numbered rows to improve the table view's readability.
     */
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (searchResultsController.isActive) {
            // The user is using the search bar
            return
        }
        else {
            // The user is NOT using the search bar
            
            /*
             The remainder operator (RowNumber % 2) computes how many multiples of 2 will fit inside RowNumber
             and returns the value, either 0 or 1, that is left over (known as the remainder).
             Remainder 0 implies even-numbered rows; Remainder 1 implies odd-numbered rows.
             */
            if indexPath.row % 2 == 0 {
                // Set even-numbered row's background color to MintCream, #F5FFFA 245,255,250
                cell.backgroundColor = MINT_CREAM
                
            } else {
                // Set odd-numbered row's background color to OldLace, #FDF5E6 253,245,230
                cell.backgroundColor = OLD_LACE
            }
        }
    }
    
    // Informs the table view delegate that the specified row is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (searchResultsController.isActive) {
            
            //*********************************
            // The user is using the search bar
            //*********************************
            
            let currentCell = tableView.cellForRow(at: indexPath as IndexPath) as! RecipesILikeTableViewCell!
            
            let recipeNameSelected = currentCell?.recipeNameLabel.text
            let sourceNameSelected = currentCell?.sourceNameLabel.text
            
            var recipeIndexFound = -1
            
            for index in 0..<applicationDelegate.arrayOfRecipesILike.count {
                
                let recipeAtIndex = applicationDelegate.arrayOfRecipesILike[index]
                
                let recipeDataAtIndex: [String] = (recipeAtIndex as AnyObject).components(separatedBy: "|")
                
                // Set Recipe Name
                let recipeNameAtIndex = recipeDataAtIndex[0]
                
                // Set Source Name
                let sourceNameAtIndex = recipeDataAtIndex[2]
                
                if recipeNameAtIndex == recipeNameSelected && sourceNameAtIndex == sourceNameSelected {
                    recipeIndexFound = index
                    break
                }
            }
            
            if recipeIndexFound == -1 {
                print("Selected recipe not found!")
                return
            }
            
            let selectedRecipe = applicationDelegate.arrayOfRecipesILike[recipeIndexFound]
            let selectedRecipeData = (selectedRecipe as AnyObject).components(separatedBy: "|")
            
            dataOfSelectedRecipe = [selectedRecipeData[0], selectedRecipeData[1], selectedRecipeData[2], selectedRecipeData[3]]
        }
        else {
            //*********************************
            // The user is using the table view
            //*********************************
            
            let currentCell = tableView.cellForRow(at: indexPath as IndexPath) as! RecipesILikeTableViewCell!
            
            let recipeNameSelected = currentCell?.recipeNameLabel.text
            let sourceNameSelected = currentCell?.sourceNameLabel.text
            
            var recipeIndexFound = -1
            
            for index in 0..<applicationDelegate.arrayOfRecipesILike.count {
                
                let recipeAtIndex = applicationDelegate.arrayOfRecipesILike[index]
                
                let recipeDataAtIndex: [String] = (recipeAtIndex as AnyObject).components(separatedBy: "|")
                
                // Set Recipe Name
                let recipeNameAtIndex = recipeDataAtIndex[0]
                
                // Set Source Name
                let sourceNameAtIndex = recipeDataAtIndex[2]
                
                if recipeNameAtIndex == recipeNameSelected && sourceNameAtIndex == sourceNameSelected {
                    recipeIndexFound = index
                    break
                }
            }
            
            if recipeIndexFound == -1 {
                print("Selected recipe not found!")
                return
            }
            
            let selectedRecipe = applicationDelegate.arrayOfRecipesILike[recipeIndexFound]
            let selectedRecipeData = (selectedRecipe as AnyObject).components(separatedBy: "|")
            
            dataOfSelectedRecipe = [selectedRecipeData[0], selectedRecipeData[1], selectedRecipeData[2], selectedRecipeData[3]]
        }
        
        tableView.cellForRow(at: indexPath as IndexPath)?.setSelected(false, animated: false)
        
        performSegue(withIdentifier: "Show Source Website", sender: self)
    }
    
    // Informs the table view delegate that the user tapped the Detail Disclosure button
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        if (searchResultsController.isActive) {
            
            //*********************************
            // The user is using the search bar
            //*********************************
            
            let currentCell = tableView.cellForRow(at: indexPath as IndexPath) as! RecipesILikeTableViewCell!
            
            let recipeNameSelected = currentCell?.recipeNameLabel.text
            let sourceNameSelected = currentCell?.sourceNameLabel.text
            
            var recipeIndexFound = -1
            
            for index in 0..<applicationDelegate.arrayOfRecipesILike.count {
                
                let recipeAtIndex = applicationDelegate.arrayOfRecipesILike[index]
                
                let recipeDataAtIndex: [String] = (recipeAtIndex as AnyObject).components(separatedBy: "|")
                
                // Set Recipe Name
                let recipeNameAtIndex = recipeDataAtIndex[0]
                
                // Set Source Name
                let sourceNameAtIndex = recipeDataAtIndex[2]
                
                if recipeNameAtIndex == recipeNameSelected && sourceNameAtIndex == sourceNameSelected {
                    recipeIndexFound = index
                    break
                }
            }
            
            if recipeIndexFound == -1 {
                print("Selected recipe not found!")
                return
            }
            
            let selectedRecipe = applicationDelegate.arrayOfRecipesILike[recipeIndexFound]
            let selectedRecipeData = (selectedRecipe as AnyObject).components(separatedBy: "|")
            
            dataOfSelectedRecipe = [selectedRecipeData[0], selectedRecipeData[1], selectedRecipeData[2], selectedRecipeData[3]]
            
        }
        else {
            //*********************************
            // The user is using the table view
            //*********************************
            
            let currentCell = tableView.cellForRow(at: indexPath as IndexPath) as! RecipesILikeTableViewCell!
            
            let recipeNameSelected = currentCell?.recipeNameLabel.text
            let sourceNameSelected = currentCell?.sourceNameLabel.text
            
            var recipeIndexFound = -1
            
            for index in 0..<applicationDelegate.arrayOfRecipesILike.count {
                
                let recipeAtIndex = applicationDelegate.arrayOfRecipesILike[index]
                
                let recipeDataAtIndex: [String] = (recipeAtIndex as AnyObject).components(separatedBy: "|")
                
                // Set Recipe Name
                let recipeNameAtIndex = recipeDataAtIndex[0]
                
                // Set Source Name
                let sourceNameAtIndex = recipeDataAtIndex[2]
                
                if recipeNameAtIndex == recipeNameSelected && sourceNameAtIndex == sourceNameSelected {
                    recipeIndexFound = index
                    break
                }
            }
            
            if recipeIndexFound == -1 {
                print("Selected recipe not found!")
                return
            }
            
            let selectedRecipe = applicationDelegate.arrayOfRecipesILike[recipeIndexFound]
            let selectedRecipeData = (selectedRecipe as AnyObject).components(separatedBy: "|")
            
            dataOfSelectedRecipe = [selectedRecipeData[0], selectedRecipeData[1], selectedRecipeData[2], selectedRecipeData[3]]
        }
        
        tableView.cellForRow(at: indexPath as IndexPath)?.setSelected(false, animated: false)
        
        performSegue(withIdentifier: "Show Recipe Details", sender: self)
    }
    
    //-------------------------------
    // Allow Editing of Rows (Cities)
    //-------------------------------
    
    // We allow each row (recipe) of the table view to be editable, i.e., deletable or movable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    //---------------------
    // Delete Button Tapped
    //---------------------
    
    // This is the method invoked when the user taps the Delete button in the Edit mode
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {   // Handle the Delete action
            
            // Delete the selected recipe
            applicationDelegate.arrayOfRecipesILike.removeObject(at: indexPath.row)
            
            // Reload the table view to reflect the deletion
            self.tableView.reloadData()
        }
    }
    
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Show Source Website" {
            
            // Obtain the object reference of the destination view controller
            let sourceWebsiteViewController: SourceWebsiteViewController = segue.destination as! SourceWebsiteViewController
            
            // Pass the data object to the destination view controller
            sourceWebsiteViewController.recipeDataPassed = dataOfSelectedRecipe
            
        } else if segue.identifier == "Show Recipe Details" {
            
            // Obtain the object reference of the destination view controller
            let recipeDetailsViewController: RecipeDetailsViewController = segue.destination as! RecipeDetailsViewController
            
            // Pass the data object to the destination view controller
            recipeDetailsViewController.recipeDataPassed = dataOfSelectedRecipe
            
        } else if segue.identifier == "Add New Recipe" {
            // Take no action since there is nothing to pass to the downstream view controller
        }
    }
}


