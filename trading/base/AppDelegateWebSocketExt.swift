//
//  AppDelegateWebSocketExt.swift
//  osn
//
//  Created by Aleksei Grebenkin on 08.06.2023.
//

import Foundation
import UserNotifications

//MARK: -Websocket mesages
extension AppDelegate: WebSocketProviderDelegate
{
    func webSocketDidConnect(_ webSocket: WebSocketProvider)
    {
        print("**** websocket call delegate server connected")
    }
    
    func webSocketDidDisconnect(_ webSocket: WebSocketProvider)
    {
        print("**** websocket call delegate server disconnected")
    }
    
    func webSocket<T: Codable>(_ webSocket: WebSocketProvider, didReceiveMessage msg: WebSocketMessage<T>)
    {
        let type = SocketMessageType(rawValue: msg.type!)
        
//        switch type {
//        case .chat_new_message:
//            if let model = msg.data as? Model_Chat_Message {
//                releasePushNotification(
//                    recipient_user_id: msg.recipient_id!,
//                    recipient_channel_id: msg.recipient_channel_id,
//                    type: .chat_new_message,
//                    model: model,
//                    badge: msg.badge ?? 0,
//                    unread_notifications_number: msg.unread_notifications_number ?? 0,
//                    unread_chat_messages_number: msg.unread_chat_messages_number ?? 0
//                )
//            }
//        default:
//            break
//        }
    }
}
