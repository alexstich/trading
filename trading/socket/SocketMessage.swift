//
//  WebSocketMessage.swift
//  trading
//
//  Created by Aleksey Grebenkin on 10.09.23.
//

import Foundation

enum SocketMessageType: String
{
    case quotes
    case q
}

struct WebSocketMessage: Codable
{
    var type: String
    var quotes: [String]?
    var quoteData: QuoteData?
    
    init(type: SocketMessageType, data: Any)
    {
        self.type = type.rawValue
        
        if type == .quotes {
            self.quotes = data as? [String]
        }
        if type == .q {
            self.quoteData = data as? QuoteData
        }
    }

    init(from decoder: Decoder) throws
    {
        var container = try decoder.unkeyedContainer()
        type = try container.decode(String.self)

        switch type {
        case SocketMessageType.quotes.rawValue:
            quotes = try container.decode([String].self)
        case SocketMessageType.q.rawValue:
            quoteData = try container.decode(QuoteData.self)
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid message type")
        }
    }

    func encode(to encoder: Encoder) throws
    {
        var container = encoder.unkeyedContainer()
        try container.encode(type)

        switch type {
        case SocketMessageType.quotes.rawValue:
            try container.encode(quotes)
        case SocketMessageType.q.rawValue:
            try container.encode(quoteData)
        default:
            throw EncodingError.invalidValue(type, EncodingError.Context(codingPath: [], debugDescription: "Invalid message type"))
        }
    }
}

struct QuoteData: Codable
{
    let c: String?          // Тикер
    let chg: Double?        // Изменение цены последней сделки в пунктах относительно цены закрытия предыдущей торговой сессии
    let ltp: Double?        // Цена последней сделки
    let ltr: String?        // Биржа последней сделки
    let name: String?       // Название бумаги
    let min_step: Double?   // Минимальный шаг цены
    let pcp: Double?        // Изменение в процентах относительно цены закрытия предыдущей торговой сессии
}
