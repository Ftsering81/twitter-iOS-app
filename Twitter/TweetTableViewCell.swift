//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Fnu Tsering on 3/7/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!    
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favButton: UIButton!
    
  
    @IBAction func retweet(_ sender: Any) {
    }
    
    
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFavorited = !favorited //true if favorited is false and false if favorited is true
        if (toBeFavorited) { //if toBeFavorited is true meaning that favorited is false (tweet has not been favorited yet)
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true) //when the tweet is successfully favorited, change the icon button image  to the red fav image
            }, failure: { (Error) in
                print("Favorite did not succeed: \(Error)")
            })
        }
        else { //toBeFavorited evaluates to False meaning that tweet has been favorited already. If a user clicks on the fav button when the tweet was already favorited, it will unfavorite the tweet or remove/destroy it from user's favorite list
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (Error) in
                print("Unfavorite did not succeed: \(Error)")
            })
        }
            
    }
    
    //lets use the outlet for the favorite button to change its image to the red favorite icon when a user clicks on it.
    var favorited: Bool = false
    var tweetId: Int = -1 //variable tweetID will store the tweet ids of the tweets. Different tweet id with each row/cell
    
    func setFavorite(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal) //if user clicks the favorite button, then the button is set to the red fav icon image
        }
        else {
            favButton.setImage(UIImage(named: "favor-icon-1"), for: UIControl.State.normal) //sets favButon to the default grey favor icon image
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
