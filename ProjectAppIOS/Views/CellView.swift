//
//  CellView.swift
//  ProjectAppIOS
//
//  Created by Роман on 31.03.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    func makeCustomText (model: TaskList?)  {
        guard let _ = model else {
            return
        }
       
        self.textLabel?.text = model!.name
        self.detailTextLabel?.text = model!.createtime

    }
}
