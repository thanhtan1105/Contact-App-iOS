//
//  AboutTableViewCell.swift
//  Contact
//
//  Created by Le Thanh Tan on 7/11/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imagesView: UIImageView!
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

  func configure(imageName: String, titleLabel: String) {
    self.titleLabel.text = titleLabel
    self.imagesView.image = UIImage(named: imageName)
  }
}
