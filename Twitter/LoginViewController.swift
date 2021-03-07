//
//  LoginViewController.swift
//  Twitter
//
//  Created by Fnu Tsering on 3/6/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //code in this function runs when your view appears, meaning when your initial screen shows up.
    override func viewDidAppear(_ animated: Bool) {
        //check for a note or key-value pair in the users default to see if user has logged in already or not.
        
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            //if the value for the key "UserLoggedIn" in User Defaults evaluates to true, then don't ask to log in again, perform the segue to the Home screen right away
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        } 
    }
    
    
    
    
    //This action function is linked to the login button. When a user clicks on that button, this action function executes
    @IBAction func onLoginButton(_ sender: Any) {
        
        let myUrl = "https://api.twitter.com/oauth/request_token" //url from the twitter API
        
        //call the login method in the TwitterAPICaller swift file with that url as argument to log in. It will lead the user to a website where the user can provide login username and password to authorize the application to access their data.
            //If login is successful, then segue to the home screen by performing the loginToHome segue.
            //If login fails, print error message.
        TwitterAPICaller.client?.login(url: myUrl, success: {
            //the code here runs when a login is successful.
         
            //since the user logged in successfully, we want to write a note in memory to say that the user logged in already so we can use that later to say stay logged in and don't ask to login again when the app is closed and reopened.
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            
            //When a user logs in successfully, we want the user to be able to see the home screen, so that's what this code will do.
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            
        }, failure: { (Error) in
            print("Could not log in!") //this code will run when login fails.
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
