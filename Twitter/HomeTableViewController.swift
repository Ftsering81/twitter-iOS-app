//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Fnu Tsering on 3/7/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]() //declares a variable of type array of dictionaries
    var numberOfTweet: Int! //declares a variable of type int
    
    let myRefreshControl = UIRefreshControl() //UI object associated with pulling to refresh
    
    override func viewDidLoad() { //runs when the screen is loaded for the first time.
        //loads all the information we need before showing a screen
        super.viewDidLoad()
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl //this tells the table view to use the Refresh Control named  myRefreshControl
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweet() 
    }
    
    //When this function is called, it sends a request to the Twitter API's statuses/home_timeline endpoint by using its resource url in order to retrieve a list of the most recent tweets posted by the authenticating user and the users they follow in their home timeline.
    @objc func loadTweet(){
        //the resource url which allows us to make request to the statuses/home_timeline endpoint
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 20] //we provided 10 as value for the parameter count. This is the count of the number of tweets the endpoint will return back to the caller.
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            //this code runs if the API endpoint successfully responds or returns data as requested in the call.
            self.tweetArray.removeAll() //empties the entire array
            
            //copies each of the tweets or dictionaries from the array of dictionaries returned from the API to tweetArray, the array of dictionaries variable we created.
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData() //updates the table. This function ensures that everytime a call is made to the API endpoint, we reset our array of dictionaries to make sure to reload the data with the new list of tweets that the API returned.
            self.myRefreshControl.endRefreshing() //the loading/spinning symbol when you pull refresh will stay there forever unless this method is called to end Refreshing.
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
        
    }
    

    //This function is called when a user clicks on the Logout button
    @IBAction func onLogout(_ sender: Any) {
        //call the logout method defined in the TwitterAPICaller swift file in order to logout, which deauthorizes the application from accessing the user's twitter account. Deauthorizing means to end the current session
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil) //the screen will dismiss itself or basically disappear
        
        //When the user clicks the Logout button and the screen goes back to the initial screen or the Login screen, set the value of the key userLoggedIn to false so that when the initial screen appears again after we click Logout and the ViewDidAppear() is called in the LoginViewController.swift file, the if statement evaluates to false and so the loginToHome segue is not performed and the app stays in the Login screen.
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        
    }
    
    
    
    //function to create and customize the cells for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //the idenitifer is the name of the prototype cell you want to reuse. How do we get the identifier for a prototype cell? We have to set it ourselves for that table view cell by clicking on it and settings its reuse identifier in the attribute inspector. Thats the idenitifer we use here to refer to that cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell //the reason why we are declaring this cell variable as type TweetTableViewCell is because the outlets for the objects inside the prototype cell are data members of that class. Meaning that casting cell into type TweetTableViewCell will allow us to access those outlets: profileImageView, tweetContentLabel and userNameLabel.
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary //user is a dictionary with collection of data in key-value pairs about the user
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String
        
        //now to set the profile image. This is one way to set an image in swift or xcode
        let imgUrl = URL(string: (user["profile_image_url_https"] as! String)) //imgUrl stores the https url to download the image
        let data = try? Data(contentsOf: imgUrl!) //data stores the image that is downloaded from the url
        
        if let imageData = data { //sets profileImageView or the UIImage in the cell to the image in data
            cell.profileImageView.image = UIImage(data: imageData)
        }
        return cell
    }
    

    // MARK: - Table view data source

    //how many sections do you want?
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1 //we only have 1 section for this project so return 1
    }

    //How many rows per section do you want?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        // the number of rows will be the count of tweets that are returned to us by the twitter API endpoint statues/home_timeline.
        //for now lets say 5 rows for test
        return tweetArray.count //returns count of the dictionaries or tweets in tweetArray for the number of rows because we want a row for each tweet in that array.
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
