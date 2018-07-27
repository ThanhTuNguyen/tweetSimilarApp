//
//  FirstTweetLevelCell.swift
//  tweetSimilarApp
//
//  Created by Thanh Tu Nguyen on 7/26/18.
//  Copyright © 2018 Thanh Tu Nguyen. All rights reserved.
//

import UIKit

class FirstTweetLevelCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var countInfo: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
