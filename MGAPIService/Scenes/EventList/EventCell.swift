//
//  EventCell.swift
//  MGAPIService
//
//  Created by Tuan Truong on 5/27/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable

final class EventCell: UITableViewCell, NibReusable {
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: EventViewModel?) {
        if let viewModel = viewModel {
            typeLabel.text = viewModel.type
        } else {
            typeLabel.text = ""
        }
    }
}
