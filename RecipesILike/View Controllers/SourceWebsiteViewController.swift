//
//  SourceWebsiteViewController.swift
//  Recipes
//
//  Created by Osman Balci on 10/8/17.
//  Copyright © 2017 Osman Balci. All rights reserved.
//

import UIKit
import WebKit

class SourceWebsiteViewController: UIViewController, WKNavigationDelegate {
    
    // Instance variable holding the object reference of the UI object created in Storyboard
    @IBOutlet var webView: WKWebView!
    
    // recipeDataPassed is set by the upstream view controller
    var recipeDataPassed = [String]()
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        // Display the selected country name on the navigation bar
        self.title = recipeDataPassed[2]
        
        // Obtain the URL structure instance from the given source website URL
        let url = URL(string: recipeDataPassed[3])
        
        // Obtain the URLRequest structure instance from the given url
        let request = URLRequest(url: url!)
        
        // Ask the web view object to display the web page for the requested URL
        webView.load(request)
    }
    
    /*
     ---------------------------------------------
     MARK: - WKNavigationDelegate Protocol Methods
     ---------------------------------------------
     */
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Starting to load the web page. Show the animated activity indicator in the status bar
        // to indicate to the user that the UIWebVIew object is busy loading the web page.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Finished loading the web page. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        /*
         Ignore this error if the page is instantly redirected via JavaScript or in another way.
         NSURLErrorCancelled is returned when an asynchronous load is cancelled, which happens
         when the page is instantly redirected via JavaScript or in another way.
         */
        
        if (error as NSError).code == NSURLErrorCancelled  {
            return
        }
        
        // An error occurred during the web page load. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Create the error message in HTML as a character string and store it into the local constant errorString
        let errorString = "<html><font size=+4 color='red'><p>Unable to Display Webpage: <br />Possible Causes:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>" + error.localizedDescription
        
        // Display the error message within the UIWebView object
        // self. is required here since this method has a parameter with the same name.
        webView.loadHTMLString(errorString, baseURL: nil)
    }
    
}



