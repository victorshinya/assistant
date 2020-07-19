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
import MessageKit
import InputBarAccessoryView
import AssistantV2
import IBMSwiftSDKCore

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    // MARK: - Global vars
    
    let currentUser = Sender(senderId: UUID().uuidString, displayName: "Victor Shinya")
    let assistantUser = Sender(senderId: UUID().uuidString, displayName: "Watson")
    var messages = [MessageType]()
    
    let assistant = Assistant(version: Constants.ASSISTANT_VERSION, authenticator: WatsonIAMAuthenticator(apiKey: Constants.ASSISTANT_APIKEY))
    var sessionID = ""
    
    // MARK: - Lifecycle events

    override func viewDidLoad() {
        super.viewDidLoad()
     
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        assistant.serviceURL = Constants.ASSISTANT_URL
        assistant.createSession(assistantID: Constants.ASSISTANT_ID) { response, error in
            guard let session = response?.result else {
                return
            }
            self.sessionID = session.sessionID
            self.send(message: "")
        }
        
    }
    
    // MARK: - MessagesDataSource
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    // MARK: - MessagesDisplayDelegate
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    // MARK: - InputBarAccessoryViewDelegate
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if let textMessage = inputBar.inputTextView.text {
            inputBar.inputTextView.text = String()
            inputBar.invalidatePlugins()
            DispatchQueue.main.async {
                self.messages.append(Message(sender: self.currentUser, messageId: UUID().uuidString, sentDate: Date(), kind: .text(textMessage.trimmingCharacters(in: .whitespacesAndNewlines))))
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom()
                self.send(message: textMessage.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
    
    private func send(message: String) {
        let input = MessageInput(messageType: "text", text: message)
        assistant.message(assistantID: Constants.ASSISTANT_ID, sessionID: sessionID, input: input) { response, error in
            guard let message = response?.result else {
                return
            }
            if let generic = message.output.generic {
                for runtimeResponse in generic {
                    if let text = runtimeResponse.text {
                        self.messages.append(Message(sender: self.assistantUser, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text)))
                    }
                }
            }
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom()
            }
        }
    }
}
