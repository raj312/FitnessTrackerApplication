//
//  MyWorkoutsCustomTableViewCell.swift
//  FitnessTrackerApplication
//
//  Created by DeJoun Robinson on 2018-04-05.
//  Copyright © 2018 RADS. All rights reserved.
//

import UIKit

class MyWorkoutsCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var bulletImage: UIImageView!
    @IBOutlet weak var lblWorkoutName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
