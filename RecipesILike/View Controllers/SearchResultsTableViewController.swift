//
//  SearchResultsTableViewController.swift
//  Recipes
//
//  Created by Osman Balci on 10/9/17.
//  Copyright © 2017 Osman Balci. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    // apiQueryPassed is set by SearchRecipesViewController
    var apiQueryPassed = ""
    
    // Instance Variables
    var arrayOfSearchedRecipes = [String]()
    var selectedRecipe = ""
    
    // Constant Definitions
    let tableViewRowHeight: CGFloat = 60.0
    
    // Alternate table view rows have a background color of MintCream or OldLace for clarity of display
    
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        /*
         The Edamam Application Programming Interface (API) is a RESTful web service providing
         recipe data in the JSON (JavaScript Object Notation) format.
         
         REST (REpresentational State Transfer) is a client-server architectural style and is typically
         used with the HTTP protocol. It enables the access of Web Services as simple resources using URLs.
         A Web Service is a component software application intended to provide services (functions) to another
         software application over the Internet. The Web Services created for use under the REST architectural
         style are known as RESTful Web Services.
         
         The Edamam API documentation is provided at https://developer.edamam.com/edamam-docs-recipe-api
         
         The apiQueryPassed contains the API query URL, which will return a JSON file
         */
        
        // Create a URL struct data structure from the API query URL string
        let url = URL(string: apiQueryPassed)
        
        /*
         We use the NSData object constructor below to download the JSON data via HTTP in a single thread in this method.
         Downloading large amount of data via HTTP in a single thread would result in poor performance.
         For better performance, NSURLSession can be used.
         
         NSURLSession provides an API for downloading content via HTTP with (a) a rich set of delegate methods for
         supporting authentication, (b) the ability to perform background downloads when your iOS app is suspended,
         and (c) a series of sessions created, each of which coordinates a group of related data transfer tasks. [Apple]
         
         To obtain the best performance:
         (1) Download data in multiple threads including background downloads using multithreading and Grand Central Dispatch.
         (2) Store each image on the device after first download to prevent downloading it repeatedly.
         */
        
        let jsonData: Data?
        
        do {
            /*
             Try getting the JSON data from the URL and map it into virtual memory, if possible and safe.
             Option mappedIfSafe indicates that the file should be mapped into virtual memory, if possible and safe.
             */
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
            
        } catch let error as NSError {
            
            showAlertMessage(messageHeader: "JSON Data", messageBody: "Error in retrieving JSON data: \(error.localizedDescription)")
            return
        }
        
        if let jsonDataFromApiUrl = jsonData {
            
            // The JSON data is successfully obtained from the API
            
            do {
                /*
                 JSONSerialization class is used to convert JSON and Foundation objects (e.g., NSDictionary) into each other.
                 JSONSerialization class method jsonObject returns an NSDictionary object from the given JSON data.
                 */
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                
                // arrayOfRecipesFound is an Array of Dictionaries, where each Dictionary contains data about a recipe
                let arrayOfRecipesFound = dictionaryOfReturnedJsonData["hits"] as! Array<AnyObject>
                
                for index in 0..<arrayOfRecipesFound.count {
                    
                    // Obtain the Dictionary containing the data about the recipe at index
                    let recipeDict = arrayOfRecipesFound[index] as! Dictionary<String, AnyObject>
                    
                    // Obtain the dictionary for the key "recipe"
                    let aRecipeDataDict = recipeDict["recipe"] as! Dictionary<String, AnyObject>
                    
                    //*******************
                    // Obtain Recipe Name
                    //*******************
                    
                    var recipeName = ""
                    /*
                     IF aRecipeDataDict["label"] has a value AND the value is of type String THEN
                     unwrap the value and assign it to local variable recipeName
                     ELSE leave recipeName as set to ""
                     */
                    if let nameOfRecipe = aRecipeDataDict["label"] as! String? {
                        recipeName = nameOfRecipe
                    }
                    
                    //************************
                    // Obtain Recipe Image URL
                    //************************
                    
                    var recipeImageURL = ""
                    /*
                     IF aRecipeDataDict["image"] has a value AND the value is of type String THEN
                     unwrap the value and assign it to local variable recipeImageURL
                     ELSE leave recipeImageURL as set to ""
                     */
                    if let imageURL = aRecipeDataDict["image"] as! String? {
                        recipeImageURL = imageURL
                    }
                    
                    //**************************
                    // Obtain Recipe Source Name
                    //**************************
                    
                    var sourceName = ""
                    /*
                     IF aRecipeDataDict["source"] has a value AND the value is of type String THEN
                     unwrap the value and assign it to local variable sourceName
                     ELSE leave sourceName as set to ""
                     */
                    if let nameOfSource = aRecipeDataDict["source"] as! String? {
                        sourceName = nameOfSource
                    }
                    
                    //*********************************
                    // Obtain Recipe Source Website URL
                    //*********************************
                    
                    var sourceWebsiteURL = ""
                    /*
                     IF aRecipeDataDict["url"] has a value AND the value is of type String THEN
                     unwrap the value and assign it to local variable sourceWebsiteURL
                     ELSE leave sourceWebsiteURL as set to ""
                     */
                    if let websiteURL = aRecipeDataDict["url"] as! String? {
                        sourceWebsiteURL = websiteURL
                    }
                    
                    //**************************
                    // Obtain Recipe Diet Labels
                    //**************************
                    
                    var dietLabels = ""
                    
                    if let dietLabelsArray = aRecipeDataDict["dietLabels"] as! Array<AnyObject>? {
                        
                        // Convert the array of diet labels into comma separated String dietLabels
                        for j in 0..<dietLabelsArray.count {
                            
                            // Concatenate jth value to the previous one
                            dietLabels += dietLabelsArray[j] as! String
                            
                            // Do not add comma after the last value
                            if j != dietLabelsArray.count - 1 {
                                dietLabels += ", "
                            }
                        }
                    }
                    
                    //****************************
                    // Obtain Recipe Health Labels
                    //****************************
                    
                    var healthLabels = ""
                    
                    if let healthLabelsArray = aRecipeDataDict["healthLabels"] as! Array<AnyObject>? {
                        
                        // Convert the array of health labels into comma separated String healthLabels
                        for k in 0..<healthLabelsArray.count {
                            
                            // Concatenate kth value to the previous one
                            healthLabels += healthLabelsArray[k] as! String
                            
                            // Do not add comma after the last value
                            if k != healthLabelsArray.count - 1 {
                                healthLabels += ", "
                            }
                        }
                    }
                    
                    //*******************************
                    // Obtain Recipe Ingredient Lines
                    //*******************************
                    
                    var ingredientLines = ""
                    
                    if let ingredientLinesArray = aRecipeDataDict["ingredientLines"] as! Array<AnyObject>? {
                        
                        // Convert the array of Ingredient Lines into comma separated String ingredientLines
                        for n in 0..<ingredientLinesArray.count {
                            
                            // Concatenate nth value to the previous one
                            ingredientLines += ingredientLinesArray[n] as! String
                            
                            // Do not add comma after the last value
                            if n != ingredientLinesArray.count - 1 {
                                ingredientLines += ", "
                            }
                        }
                    }
                    
                    //******************************
                    // Obtain Recipe Calories Amount
                    //******************************
                    
                    var caloriesAmount = ""
                    
                    if let caloriesFloat = aRecipeDataDict["calories"] as! Float? {
                        
                        // Convert the float value to String with two decimal points
                        caloriesAmount = String(format:"%.2f", caloriesFloat)
                    }
                    
                    //***************************************************************
                    // Compose the recipe string by separting the attributes with "|"
                    //***************************************************************
                    
                    let recipeString = recipeName + "|" + recipeImageURL + "|" + sourceName + "|" + sourceWebsiteURL
                        + "|" + dietLabels + "|" + healthLabels + "|" + ingredientLines + "|" + caloriesAmount
                    
                    //***********************************************************
                    // Add the new recipe string to the array of searched recipes
                    //***********************************************************
                    
                    arrayOfSearchedRecipes.append(recipeString)
                }
                
            } catch let error as NSError {
                
                showAlertMessage(messageHeader: "JSON Data", messageBody: "Error in JSON Data Serialization: \(error.localizedDescription)")
                return
            }
            
        } else {
            showAlertMessage(messageHeader: "JSON Data", messageBody: "Unable to obtain the JSON data file!")
        }
    }
    
    /*
     -------------------------------
     MARK: - Memory Warning Received
     -------------------------------
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        showAlertMessage(messageHeader: "Memory Warning!", messageBody: "Received memory warning!")
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
     --------------------------------------
     MARK: - Table View Data Source Methods
     --------------------------------------
     */
    
    // Asks the data source to return the number of sections in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    // Asks the data source to return the number of rows in a section, the number of which is given
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfSearchedRecipes.count
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Identify the row number
        let rowNumber: Int = (indexPath as NSIndexPath).row
        
        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        // "Search Result Cell", which was specified in the storyboard
        let cell: RecipesILikeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Search Result Cell") as! RecipesILikeTableViewCell
        
        let recipeAtRowNumber = arrayOfSearchedRecipes[rowNumber]
        
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
    
    // Informs the table view delegate that the specified row is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRecipe = arrayOfSearchedRecipes[indexPath.row]
        
        performSegue(withIdentifier: "Searched Recipe Details", sender: self)
    }
    
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegue
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Searched Recipe Details" {
            
            // Obtain the object reference of the destination view controller
            let searchedRecipeDetailsViewController: SearchedRecipeDetailsViewController = segue.destination as! SearchedRecipeDetailsViewController
            
            // Pass the data object to the destination view controller
            searchedRecipeDetailsViewController.selectedRecipePassed = selectedRecipe
        }
    }
    
}

