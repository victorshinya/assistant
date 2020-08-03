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
import AssistantV2
import IBMSwiftSDKCore

class WatsonAssistant {
    
    var assistant: Assistant? = nil
    var apiKey: String = ""
    var assistantID: String = ""
    var sessionID: String = ""
    
    init() {
        self.newAssistant()
    }
    
    func newAssistant() {
        let preferences = UserDefaults.standard
        apiKey = preferences.string(forKey: Constants.KEY_ASSISTANT_APIKEY) ?? ""
        assistantID = preferences.string(forKey: Constants.KEY_ASSISTANT_ID) ?? ""
        assistant = Assistant(version: Constants.ASSISTANT_VERSION, authenticator: WatsonIAMAuthenticator(apiKey: self.apiKey))
        assistant?.serviceURL = Constants.ASSISTANT_URL
        newSession { sessionID in
            self.sessionID = sessionID
        }
    }
    
    private func newSession(completion: @escaping (String) -> Void) {
        assistant?.createSession(assistantID: self.assistantID) { response, error in
            guard let session = response?.result else {
                return
            }
            completion(session.sessionID)
        }
    }
    
    func send(_ message: String, completion: @escaping (String) -> Void) {
        let input = MessageInput(messageType: "text", text: message)
        assistant?.message(assistantID: assistantID, sessionID: sessionID, input: input) { response, error in
            guard let message = response?.result else {
                return
            }
            if let generic = message.output.generic {
                for runtimeResponse in generic {
                    if let text = runtimeResponse.text {
                        completion(text)
                    }
                }
            }
        }
    }
}
