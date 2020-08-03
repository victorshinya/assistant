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

import Foundation

enum ServiceCredential {
    case AssistantApiKey
    case AssistantID
}

class ConfigurationViewModelClass: ConfigurationViewModel {
    
    var tableStructure: [[ServiceCredential]] = [[.AssistantApiKey, .AssistantID]]
    var cellLabel: [String] = ["API Key", "Assistant ID"]
    var cellIdentifier: String
    
    init(with cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
    }
    
    func save(data: String, from credential: ServiceCredential) {
        let preferences = UserDefaults.standard
        switch credential {
        case .AssistantApiKey:
            preferences.set(data, forKey: Constants.KEY_ASSISTANT_APIKEY)
        case .AssistantID:
            preferences.set(data, forKey: Constants.KEY_ASSISTANT_ID)
        }
    }
    
    func get(credential: ServiceCredential) -> String {
        let preferences = UserDefaults.standard
        switch credential {
        case .AssistantApiKey:
            return preferences.string(forKey: Constants.KEY_ASSISTANT_APIKEY) ?? ""
        case .AssistantID:
            return preferences.string(forKey: Constants.KEY_ASSISTANT_ID) ?? ""
        }
    }
}
