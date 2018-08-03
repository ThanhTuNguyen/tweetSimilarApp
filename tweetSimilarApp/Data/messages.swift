//
//  messages.swift
//  tweetSimilarApp
//
//  Created by Thanh Tu Nguyen on 7/26/18.
//  Copyright © 2018 Thanh Tu Nguyen. All rights reserved.
//

import Foundation

struct listMessages
{
    var list : [messages]
    
    enum CodingKeys: String, CodingKey {
        case list
    }
    
    init()
    {
        self.list = [messages]()
    }
    
    init(firstList: messages)
    {
        self.list = [messages]()
        self.list.append(firstList)
    }
    
    init(allList: [messages])
    {
        self.list = [messages]()
        self.list = allList
    }
    
    mutating func addList(_ newList: messages)
    {
        list.append(newList)
    }
    
    mutating func removeChild(_ child : messages) {
        self.list = self.list.filter( {$0 !== child})
    }
}

extension listMessages: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(list, forKey: .list)
        
    }
}

extension listMessages : Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decode([messages].self, forKey: .list)
    }
}

struct message : Codable {
    var message: String
}

class messages : Codable
{
    var isValid : Bool!
    var content : String
    var parentIndex : Int!
    var errorMessage : String!
    var allMessages : [messages]
    
    init(firstMessage: String, parentIndex: Int)
    {
        self.allMessages = [messages]()
        self.parentIndex = parentIndex
        self.content = ""
        self.isValid = true
        self.errorMessage = ""
        let trimmedString = firstMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        self.initMessage(longMessage: trimmedString)
    }
    
    init(validMessage messageValid: String, parentIndex: Int)
    {
        self.allMessages = [messages]()
        self.content = messageValid
        self.parentIndex = parentIndex
    }
    
    func removeChild(_ child : messages) {
        self.allMessages = self.allMessages.filter( {$0 !== child})
    }
    
    func initMessage(longMessage: String)
    {
        if(longMessage.count <= 50)
        {
            self.allMessages.append(messages(validMessage: longMessage, parentIndex: self.parentIndex))
            return
        }
        let stringArr = longMessage.components(separatedBy: " ")
        let countWord = stringArr.count
        
        var i = 0
        var message = ""
        var nextMesageCount = 0
        var countAllMessages = 1
        var currentIndex = 0
        
        while i < countWord
        {
            if(stringArr[i].count + 2 + countAllMessages + String(currentIndex + 1).count <= 50)
            {
                message = stringArr[i]
                
                i += 1
                if(i >= countWord)
                {
                    self.allMessages.append(messages(validMessage: message, parentIndex: self.parentIndex))
                    currentIndex += 1
                    if(String(currentIndex).count > countAllMessages)
                    {
                        countAllMessages = String(allMessages.count).count
                        // reset process
                        i = 0
                        message = ""
                        nextMesageCount = 0
                        self.allMessages.removeAll()
                        currentIndex = 0
                        
                        //                        print("break 1")
                        if(stringArr[i].count + 2 + countAllMessages + String(currentIndex + 1).count <= 50)
                        {
                            message = stringArr[i]
                            i += 1
                        }
                        else
                        {
                            isValid = false
                            self.errorMessage = stringArr[i]
                            return
                        }
                    }
                    else
                    {
                        break
                    }
                }
                nextMesageCount = message.count + stringArr[i].count + 3 + countAllMessages  + String(currentIndex).count
                
                while nextMesageCount <= 50
                {
                    if(stringArr[i].count + 2 + countAllMessages + String(currentIndex + 1).count <= 50)
                    {
                        message = message + " \(stringArr[i])"
                        //                        print(message)
                        i += 1
                        if(i >= countWord)
                        {
                            break
                        }
                        nextMesageCount = message.count + stringArr[i].count + 3 + countAllMessages  + String(currentIndex).count
                    }
                    else
                    {
                        isValid = false
                        self.errorMessage = stringArr[i]
                        return
                    }
                }
                self.allMessages.append(messages(validMessage: message, parentIndex: self.parentIndex))
                currentIndex += 1
                if(String(currentIndex).count > countAllMessages)
                {
                    countAllMessages = String(allMessages.count).count
                    // reset process
                    i = 0
                    message = ""
                    nextMesageCount = 0
                    self.allMessages.removeAll()
                    currentIndex = 0
                }
            }
            else
            {
                isValid = false
                self.errorMessage = stringArr[i]
                return
            }
        }
        i = 0
        while i < self.allMessages.count
        {
            self.allMessages[i].content = "\(i + 1)" + "\\" + "\(self.allMessages.count) " + self.allMessages[i].content
            i = i + 1
        }
    }
    
}
