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
import MessageKit

class ChatViewModelClass: NSObject, ChatViewModel {
    
    var user: Sender
    
    var assistant: Sender
    
    var messages: [MessageType]
    
    var watson: WatsonAssistant
    
    init(user name: String, assistant nickname: String) {
        self.user = Sender(senderId: UUID().uuidString, displayName: name)
        self.assistant = Sender(senderId: UUID().uuidString, displayName: nickname)
        self.messages = [Message]()
        self.watson = WatsonAssistant()
    }
    
    func send(message: String, completion: @escaping () -> Void) {
        watson.send(message) { text in
            let newMessage = Message(sender: self.assistant, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
            self.messages.append(newMessage)
            completion()
        }
    }
}
