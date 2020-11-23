//
//  ExampleChatViewController.swift
//  SwiftyChatExample
//
//  Created by Hussein Jaber on 23/11/2020.
//  Copyright © 2020 Hussein Jaber. All rights reserved.
//

import UIKit
import SwiftyChat

// We are mocking an api call here. You would be using your own API client/service instead. This is here for the sake of the example only
class FakeApiClient {
    static func getMessages(completion: @escaping ([Message]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            var messages = [Message]()
            for i in 0...4 {
                let message = Message(text: "Message \(i)", isSender: Bool.random())
                messages.append(message)
            }
            completion(messages)
        }
    }
}

class ExampleChatViewController: ChatViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.style.textAreaBackgroundColor = .red
        getMessagesFromServer()
    }
    
    private func getMessagesFromServer() {
        FakeApiClient.getMessages { [weak self] (messages) in
            for message in messages {
                self?.addMessage(message)
            }

        }
    }
   
}
