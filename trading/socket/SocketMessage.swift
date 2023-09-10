//
//  WebSocketMessage.swift
//  osn
//
//  Created by Aleksei Grebenkin on 16.09.2021.
//

import Foundation

enum SocketMessageType: String
{
    case chat_new_message
    case account_online_status = "channel_online_status"
}

class WebSocketMessageBase: Codable
{
    var type: String?
    var transport_id: String?
    var recipient_id: Int? // user_id
    var sender_id: Int? // user_id
    var recipient_channel_id: Int? // user_id
    var sender_channel_id: Int?
    var badge: Int?
    var unread_notifications_number: Int?
    var unread_chat_messages_number: Int?
}

class WebSocketMessage<DATATYPE: Codable>:  WebSocketMessageBase
{
    var data: DATATYPE?
    
    public init(message_identificator: String? = nil)
    {
        super.init()
        
        self.type = nil
        self.transport_id = message_identificator ?? UUID().uuidString
        self.recipient_id = nil
        self.recipient_channel_id = nil
        self.sender_id = nil
        self.sender_channel_id = nil
        self.badge = nil
        self.unread_notifications_number = nil
        self.unread_chat_messages_number = nil
        self.data = nil
    }
    
    override func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(transport_id, forKey: .transport_id)
        try container.encode(recipient_channel_id, forKey: .recipient_channel_id)
        try container.encode(recipient_id, forKey: .recipient_id)
        try container.encode(sender_id, forKey: .sender_id)
        try container.encode(sender_channel_id, forKey: .sender_channel_id)
        try container.encode(badge, forKey: .badge)
        try container.encode(unread_notifications_number, forKey: .unread_notifications_number)
        try container.encode(unread_chat_messages_number, forKey: .unread_chat_messages_number)
        
        let dataEncoder = container.superEncoder(forKey: .data)
        try data.encode(to: dataEncoder)
    }
    
    public required init(from decoder: Decoder) throws
    {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        type = try? container.decodeString(from: .type)
//        transport_id = try? container.decodeString(from: .transport_id)
//        recipient_id = try? container.decodeInt(from: .recipient_id)
//        sender_id = try? container.decodeInt(from: .sender_id)
//        recipient_channel_id = try? container.decodeInt(from: .recipient_channel_id)
//        sender_id = try? container.decodeInt(from: .sender_id)
//        sender_channel_id = try? container.decodeInt(from: .sender_channel_id)
//        badge = try? container.decodeInt(from: .badge)
//        unread_notifications_number = try? container.decodeInt(from: .unread_notifications_number)
//        unread_chat_messages_number = try? container.decodeInt(from: .unread_chat_messages_number)
        
//        let modelDecoder = try container.superDecoder(forKey: .data)
//        data = try? DATATYPE.init(from: modelDecoder)
    }
    
    enum CodingKeys: String, CodingKey
    {
        case type
        case transport_id
        case recipient_id
        case recipient_channel_id
        case sender_id
        case sender_channel_id
        case data
        case badge
        case unread_notifications_number
        case unread_chat_messages_number
    }
}
