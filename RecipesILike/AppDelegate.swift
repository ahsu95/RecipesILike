//
//  AppDelegate.swift
//  Recipes
//
//  Created by Osman Balci on 10/8/17.
//  Copyright © 2017 Osman Balci. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // Instance variable to hold the object reference of a Dictionary object, the content of which is modifiable at runtime
    var arrayOfRecipesILike: NSMutableArray = NSMutableArray()
    
    /*
     ------------------------------
     MARK: - Read the Recipes Array
     ------------------------------
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        /*
         All application-specific and user data must be written to files that reside in the iOS device's
         Document directory. Nothing can be written into application's main bundle (project folder) because
         it is locked for writing after your app is published.
         
         The contents of the iOS device's Document directory are backed up by iTunes during backup of an iOS device.
         Therefore, the user can recover the data written by your app from an earlier device backup.
         
         The Document directory path on an iOS device is different from the one used for the iOS Simulator.
         
         To obtain the Document directory path, you use the NSSearchPathForDirectoriesInDomains function.
         However, this function was created originally for Mac OS X, where multiple such directories could exist.
         Therefore, it returns an array of paths rather than a single path.
         
         For iOS, the resulting array's first element (index=0) contains the path to the Document directory.
         */
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/RecipesILike.plist"
        //print(plistFilePathInDocumentDirectory)
        
        /*
         Instantiate an NSMutableArray object and initialize it with the contents of the
         RecipesILike.plist file from the Document directory on the user's iOS device.
         */
        let arrayFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: plistFilePathInDocumentDirectory)
        print(arrayFromFile)
        
        /*
         IF the optional variable arrayFromFile has a value, THEN
         RecipesILike.plist exists in the Document directory and the array is successfully created
         ELSE
         read RecipesILike.plist from the application's main bundle.
         */
        if let arrayFromFileInDocumentDirectory = arrayFromFile {
            
            // RecipesILike.plist exists in the Document directory
            arrayOfRecipesILike = arrayFromFileInDocumentDirectory
            //print(arrayOfRecipesILike)
            
        } else {
            /******************************************************************************************
             RecipesILike.plist does not exist in the Document directory; Read it from the main bundle.
             
             This will be the case only when the app is launched for the very first time. Thereafter,
             RecipesILike.plist will be written to and read from the iOS device's Document directory.
             
             For readability purposes, the plist file contains " | " to separate the data values.
             Since URLs cannot have spaces and names should not begin or end with a space,
             we clean the RecipesILike.plist data by replacing all occurrences of " | " with "|"
             *****************************************************************************************/
            
            // Obtain the file path to the plist file in the main bundle (project folder)
            let plistFilePathInMainBundle: String? = Bundle.main.path(forResource: "RecipesILike", ofType: "plist")
            print(plistFilePathInMainBundle!)
            
            let arrayFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: plistFilePathInMainBundle!)
            
            if let arrayForPlistFile = arrayFromFile {
                
                // Typecast the created array as a Swift array of Strings
                let arrayOfRecipesUncleanedData = arrayForPlistFile as! [String]
                
                for index in 0..<arrayOfRecipesUncleanedData.count {
                    
                    // Clean the data by replacing all occurrences of " | " with "|"
                    let recipeDataCleaned = arrayOfRecipesUncleanedData[index].replacingOccurrences(of: " | ", with: "|", options: [], range: nil)
                    arrayOfRecipesILike.add(recipeDataCleaned)
                    print(arrayOfRecipesILike)
                }
                
            } else {
                print("RecipesILike.plist does not reside in the application's main bundle!")
            }
        }
        
        return true
    }
    
    /*
     -------------------------------
     MARK: - Write the Recipes Array
     -------------------------------
     */
    func applicationWillResignActive(_ application: UIApplication) {
        /*
         "UIApplicationWillResignActiveNotification is posted when the app is no longer active and loses focus.
         An app is active when it is receiving events. An active app can be said to have focus.
         It gains focus after being launched, loses focus when an overlay window pops up or when the device is
         locked, and gains focus when the device is unlocked." [Apple]
         */
        
        // Define the file path to the RecipesILike.plist file in the Document directory
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/RecipesILike.plist"
        
        // Write the NSMutableArray to the RecipesILike.plist file in the Document directory on the user's iOS device
        arrayOfRecipesILike.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
        
        /*
         The flag "atomically" specifies whether the file should be written atomically or not.
         
         If flag atomically is TRUE, the array is first written to an auxiliary file, and
         then the auxiliary file is renamed to path plistFilePathInDocumentDirectory.
         
         If flag atomically is FALSE, the array is written directly to path plistFilePathInDocumentDirectory.
         This is a bad idea since the file can be corrupted if the system crashes during writing.
         
         The TRUE option guarantees that the file will not be corrupted even if the system crashes during writing.
         */
    }
    
}


