//
//  UserCell.swift
//  DeepNavigator
//
//  Created by Jhink Solutions on 7/13/16.
//  Copyright © 2016 Jhink Solutions. All rights reserved.
//

import UIKit

final class UserCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

