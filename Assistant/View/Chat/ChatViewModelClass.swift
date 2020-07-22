//
//  ChatViewModelClass.swift
//  Assistant
//
//  Created by Victor Shinya on 23/07/20.
//  Copyright © 2020 Victor Shinya. All rights reserved.
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
