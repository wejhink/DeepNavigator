//
//  RepoCell.swift
//  DeepNavigator
//
//  Created by Jhink Solutions on 7/12/16.
//  Copyright © 2016 Jhink Solutions. All rights reserved.
//

import UIKit

final class RepoCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
