//
//  WebSocketProvider.swift
//  trading
//
//  Created by Aleksey Grebenkin on 10.09.23.
//

import Foundation
import RxSwift
import Starscream

protocol WebSocketProviderDelegate: AnyObject
{
    func webSocketDidConnect(_ webSocket: WebSocketProvider)
    func webSocketDidDisconnect(_ webSocket: WebSocketProvider)
    func webSocket(_ webSocket: WebSocketProvider, didReceiveMessage msg: WebSocketMessage)
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
        
    var delegate: WebSocketProviderDelegate?
    
    var socket: WebSocket?
    
    var isConnected: Bool = false
    var timer: Timer!
    
    var disposeBag: DisposeBag = DisposeBag()

    public func establishConnection()
    {
        if  socket != nil && isConnected {
            return
        }
        
        let request = URLRequest(url: URL(string: "wss://wss.tradernet.ru")!)
        
        self.socket = WebSocket(request: request, certPinner: nil)
        self.socket!.respondToPingWithPong = true
        self.socket!.delegate = self
        self.socket!.connect()
    }
    
    public func closeConnection()
    {
        isConnected = false
        
        if socket != nil {
            print("**** websocket is disconnected")
            socket?.forceDisconnect()
            socket = nil
        }
    }
    
    public final func send<T: Codable>(
        type: SocketMessageType,
        data: T
    ) throws
    {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateManager.FORMAT_LONG
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        let socket_message = WebSocketMessage(type: type, data: data)
        
        guard let message = try? encoder.encode(socket_message) else {
            throw WebSocketProviderError.SendingDataEncodeFailure
        }
        
        print("**** websocket client send message - " + (String(data: message, encoding: .utf8) ?? ""))
        print("**** websocket client send message - \(message)")

        socket?.write(data: Data(message))
    }
    
    private func initTimer() {
     
      if timer == nil {
        timer = Timer.scheduledTimer(
            timeInterval: 30.0,
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
        print("**** websocket is disconnected")
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
            print("**** websocket is connected: \(headers)")
            self.socket!.write(ping: Data())
        case .disconnected(let reason, let code):
            print("**** websocket is disconnected: \(reason) with code: \(code)")
            closeConnection()
        case .text(let string):
            print("**** websocket received text: \(string)")
            if let message = self.decode(data: string.data(using: .utf8)!) {
                process(message: message)
            }
        case .binary(let data):
            print("**** websocket received data: \(data.count)")
            if let message = self.decode(data: data) {
                process(message: message)
            }
        case .ping(_):
            print("**** websocket ping")
            break
        case .pong(_):
            print("**** websocket pong")
            break
        case .viabilityChanged(_):
            print("**** websocket viability changed")
            break
        case .reconnectSuggested(_):
            print("**** websocket reconnect suggested")
            break
        case .cancelled:
            print("**** websocket cancelled")
            closeConnection()
        case .error(let error):
            print("**** websocket error \(String(describing: error))")
            closeConnection()
//            self.handleError(error)
        }
        
        switch event {
        case .connected(_), .binary(_), .text(_), .ping(_), .pong(_), .reconnectSuggested(_):
            isConnected = true
        default:
            isConnected = false
        }
    }
    
    @discardableResult
    private func decode(data: Data) -> WebSocketMessage?
    {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateManager.FORMAT_LONG
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        if let message = try? decoder.decode(WebSocketMessage.self, from: data) {
            print(String(describing: message))
            return message
        }

        return nil
    }
    
    private func handleError(_ error: Error?)
    {
        if let error = error {
            print("Ошибка соединения. Обратитесь в тех поддержку.  \(error.localizedDescription)")
        } else {
            print("Ошибка соединения. Обратитесь в тех поддержку.")
        }
    }
    
    private func process(message: WebSocketMessage)
    {
        let type = message.type
            
        switch SocketMessageType(rawValue: type) {
        case .q:
            self.delegate?.webSocket(self, didReceiveMessage: message)
        default:
            break
        }
    }
}

extension WebSocketProvider: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
