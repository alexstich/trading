//
//  ExtKeyedDecodingContainer.swift
//  trading
//
//  Created by Aleksey Grebenkin on 10.09.23.
//

import Foundation

extension KeyedDecodingContainer where Key: CodingKey
{
    func decodeObject<T:Codable>(type:T.Type, from key: Key) throws -> T?
    {
        let object = try decode(T.self, forKey: key)
        return object
    }
    
    func decodeArray<T:Codable>(type:T.Type, from key: Key) throws -> [T]?
    {
        let arr = try decode([T].self, forKey: key)
        return arr
    }
    
    func decodeInt16(from key: Key) throws -> Int16?
    {
        let num = try? decode(Int16.self, forKey: key)
        
        if num != nil {
            return num
        } else {
            let num_as_str = try? decode(String.self, forKey: key)
            
            if num_as_str != nil {
                return Int16(num_as_str!)
            }
        }
        
        return nil
    }
    
    func decodeInt64(from key: Key) throws -> Int64?
    {
        let num = try? decode(Int64.self, forKey: key)
        
        if num != nil {
            return num
        } else {
            let num_as_str = try? decode(String.self, forKey: key)
            
            if num_as_str != nil {
                return Int64(num_as_str!)
            }
        }
        
        return nil
    }
    
    func decodeInt(from key: Key) throws -> Int?
    {
        let num = try? decode(Int.self, forKey: key)
        
        if num != nil {
            return num
        } else {
            let num_as_str = try? decode(String.self, forKey: key)
            
            if num_as_str != nil {
                return Int(num_as_str!)
            }
        }
        
        return nil
    }
    
    func decodeDouble(from key: Key) throws -> Double?
    {
        let num = try? decode(Double.self, forKey: key)
        
        if num != nil {
            return num
        } else {
            let num_as_str = try? decode(String.self, forKey: key)
            
            if num_as_str != nil {
                return Double(num_as_str!)
            }
        }
        
        return nil
    }
    
    func decodeFloat(from key: Key) throws -> Float?
    {
        let num = try? decode(Float.self, forKey: key)
        
        if num != nil {
            return num
        } else {
            let num_as_str = try? decode(String.self, forKey: key)
            
            if num_as_str != nil {
                return Float(num_as_str!)
            }
        }
        
        return nil
    }
    
    func decodeString(from key: Key) throws -> String?
    {
        return try decode(String.self, forKey: key)
    }
    
    func decodeBool(from key: Key) throws -> Bool?
    {
        return try decode(Bool.self, forKey: key)
    }
}
