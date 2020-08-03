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

class ConfigurationViewController: UITableViewController, ConfigurationTableViewCellDelegate {
    
    // MARK: - Global vars
    
    let viewModel = ConfigurationViewModelClass(with: "cellIdentifier")
    
    // MARK: - Lifecycle events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.systemGreen
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ConfigurationTableViewCell", bundle: nil), forCellReuseIdentifier: viewModel.cellIdentifier)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Watson Assistant"
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableStructure[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tableStructure.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier, for: indexPath) as! ConfigurationTableViewCell
        cell.title?.text = viewModel.cellLabel[indexPath.row]
        let id = viewModel.tableStructure[0][indexPath.row]
        cell.inputText.text = viewModel.get(credential: id)
        cell.identifier = id
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    // MARK: - ConfigurationTableViewCellDelegate
    
    func configurationTableViewCellDidEnd(from identifier: ServiceCredential, newValue: String) {
        viewModel.save(data: newValue, from: identifier)
    }
}
