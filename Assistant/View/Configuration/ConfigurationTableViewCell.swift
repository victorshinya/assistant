//
//  Copyright 2020 Victor Shinya
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

protocol ConfigurationTableViewCellDelegate {
    func configurationTableViewCellDidEnd(from identifier: ServiceCredential, newValue: String)
}

class ConfigurationTableViewCell: UITableViewCell {
    
    // MARK: - IBoutlets
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var inputText: UITextField!
    
    // MARK: - Variables
    
    var identifier: ServiceCredential?
    var delegate: ConfigurationTableViewCellDelegate?
    
    // MARK: - IBActions
    
    @IBAction func updateField(_ sender: UITextField) {
        if let text = sender.text, let credential = identifier {
            delegate?.configurationTableViewCellDidEnd(from: credential, newValue: text)
        }
    }
}
