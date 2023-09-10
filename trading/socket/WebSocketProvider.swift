//
//  SocketManager.swift
//  osn
//
//  Created by Aleksei Grebenkin on 08.06.2023.
//

import Foundation
import RxSwift
import Starscream

protocol WebSocketProviderDelegate: AnyObject
{
    func webSocketDidConnect(_ webSocket: WebSocketProvider)
    func webSocketDidDisconnect(_ webSocket: WebSocketProvider)
    func webSocket<T: Codable>(_ webSocket: WebSocketProvider, didReceiveMessage msg: WebSocketMessage<T>)
}

enum WebSocketProviderError: Error
{
    case SendingDataEncodeFailure
    case SendingCreatingPointerFailure
    case RecievingingEndEncountered
    case RecievingErrorOccurred
    case RecievingSpaceAvailable
}

class WebSocketProvider
{
    static let getInstance = WebSocketProvider()
    
    private init()
    {
        initTimer()
    }
    
    var callbacks: [String: ((Any?)->Void)?] = [:]
    
    var delegate: WebSocketProviderDelegate?
    
    var socket: WebSocket?
    var connection_id: String? // For identification connection on server side
    
    var isConnected: Bool = false
    var timer: Timer!
    
    var disposeBag: DisposeBag = DisposeBag()

    public func establishConnection()
    {
        if  socket != nil && isConnected  {
            return
        }
        
//        HelperSocket
//            .getWSToken()
//            .subscribe(
//                onNext: { [weak self] response in
//                    if let token = response.value, let self = self {
//
//                        print("**** webrtc websocket get token \(token)")
//
//                        self.connection_id = token
//
//                        if let url = AppSettingsManager.getInstance.settings.appSocketURL,
//                           let port = AppSettingsManager.getInstance.settings.appSocketPort {
//
//                            var request = URLRequest(url: URL(string: url + ":" + String(port) + "?auth-token=" + token)!)
//
//                            request.timeoutInterval = 30
//                            self.socket = WebSocket(request: request, certPinner: nil)
//                            self.socket!.respondToPingWithPong = true
//                            self.socket!.delegate = self
//                            self.socket!.connect()
//                        }
//                    }
//                },
//                onError: { error in
//                    GlobalNetworkHelper.base_error_check(error: error)
//                })
//            .disposed(by: disposeBag)
    }
    
    public func closeConnection()
    {
        isConnected = false
        
        if socket != nil {
            print("**** webrtc websocket is disconnected")
            socket?.forceDisconnect()
            socket = nil
        }
    }
    
    public final func send<MODEL: Codable>(
        type: SocketMessageType,
        userId: Int? = nil,
        model: MODEL,
        backcall: ((Any?)->Void)? = nil,
        message_identificator: String? = nil
    ) throws
    {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateManager.FORMAT_AS_SERVER
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        let socket_message = WebSocketMessage<MODEL>(message_identificator: message_identificator)
        
        socket_message.type = type.rawValue
        
        if userId != nil {
            socket_message.recipient_id = userId
        }
        
        socket_message.data = model
        
        guard let message = try? encoder.encode(socket_message) else {
            throw WebSocketProviderError.SendingDataEncodeFailure
        }
        
        print("**** webrtc websocket client send message - \(message)")

        socket?.write(data: Data(message))
        
        if backcall != nil {
            self.callbacks[socket_message.transport_id!] = backcall
        }
    }
    
    private func initTimer() {
     
      if timer == nil {
        timer = Timer.scheduledTimer(
            timeInterval: 15.0,
            target: self,
            selector: #selector(checkConnection),
            userInfo: nil,
            repeats: true
        )
      }
    }
    
    @objc func checkConnection()
    {
        if socket == nil || !isConnected {
            establishConnection()
        }

        socket?.write(ping: Data())
    }
    
    deinit {
        print("**** webrtc websocket is disconnected")
        socket?.disconnect()
        timer.invalidate()
        timer = nil
    }
}

extension WebSocketProvider: WebSocketDelegate
{
    func didReceive(event: WebSocketEvent, client: WebSocket)
    {
        switch event {
        case .connected(let headers):
            print("**** webrtc websocket is connected: \(headers)")
            self.socket!.write(ping: Data())
        case .disconnected(let reason, let code):
            print("**** webrtc websocket is disconnected: \(reason) with code: \(code)")
            closeConnection()
        case .text(let string):
            print("**** webrtc websocket received text: \(string)")
            if let message = self.decode(data: string.data(using: .utf8)!) {
                process(message: message)
            }
        case .binary(let data):
            print("**** webrtc websocket received data: \(data.count)")
            if let message = self.decode(data: data) {
                process(message: message)
            }
        case .ping(_):
            print("**** webrtc websocket ping")
            break
        case .pong(_):
            print("**** webrtc websocket pong")
            break
        case .viabilityChanged(_):
            print("**** webrtc websocket viability changed")
            break
        case .reconnectSuggested(_):
            print("**** webrtc websocket reconnect suggested")
            break
        case .cancelled:
            print("**** webrtc websocket cancelled")
            closeConnection()
        case .error(let error):
            print("**** webrtc websocket error \(String(describing: error))")
            closeConnection()
//            self.handleError(error)
        }
        
//        switch event {
//        case .connected(_), .binary(_), .text(_), .ping(_), .pong(_), .reconnectSuggested(_):
//            AppDelegate.getInstance.networkReachability = true
//            isConnected = true
//        default:
//            AppDelegate.getInstance.networkReachability = false
//            isConnected = false
//        }
    }
    
    @discardableResult
    private func decode(data: Data) -> WebSocketMessageBase?
    {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateManager.FORMAT_AS_SERVER
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        do {
            if let dic = try? (JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?]) {
                
                var message: WebSocketMessageBase? = nil
                
//                if let type = dic["type"] as? String {
//                    switch SocketMessageType(rawValue: type) {
//                    case .chat_new_message, .chat_message_deleted:
//                        message = try decoder.decode(WebSocketMessage<Model_Chat_Message>.self, from: data)
//                        message = message as? WebSocketMessage<Model_Chat_Message>
//                    case .account_online_status:
//                        message = try decoder.decode(WebSocketMessage<Model_Account_Online_Status>.self, from: data)
//                        message = message as? WebSocketMessage<Model_Account_Online_Status>
//                    case .chat_message_was_read:
//                        message = try decoder.decode(WebSocketMessage<Model_Chat_Message_Was_Read>.self, from: data)
//                        message = message as? WebSocketMessage<Model_Chat_Message_Was_Read>
//                    case .none:
//                        break
//                    }
//                }
            
                print(String(describing: message))
                
                return message
            }
        } catch {
            print("**** webrtc websocket parsing error \(error)")
        }
        
        return nil
    }
    
    private func handleError(_ error: Error?)
    {
//        if let error = error {
//            MessagesManager.showRedAlerter(text: "Ошибка соединения. Обратитесь в тех поддержку.  \(error.localizedDescription)")
//        } else {
//            MessagesManager.showRedAlerter(text: "Ошибка соединения. Обратитесь в тех поддержку.")
//        }
    }
    
    private func process(message: WebSocketMessageBase)
    {
        if let type = message.type {
            
//            switch SocketMessageType(rawValue: type) {
//            case .chat_new_message, .chat_message_deleted:
//
//                let msg = message as! WebSocketMessage<Model_Chat_Message>
//                self.delegate?.webSocket(self, didReceiveMessage: msg)
//            }
        }
    }
}

extension WebSocketProvider: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
