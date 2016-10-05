//
//  Created by Adrian Mateoaea on 03/10/2016.
//  Copyright © 2016 MagicMapper. All rights reserved.
//

import Foundation

public typealias KeyValue = [String: Any]

public protocol Mappable {
    init?(from: Any)
    var mapFromDictionary: [String: String] { get }
    var mapFromDictionaryTypes: [String: Mappable.Type] { get }
    var dictionaryValue: Any { get }
}

public extension Mappable {
    
    var mapFromDictionary: [String: String] {
        return [:]
    }
    
    var mapFromDictionaryTypes: [String: Mappable.Type] {
        return [:]
    }
    
    var dictionaryValue: Any {
        return self
    }
}

public extension Mappable where Self: NSObject {
    
    fileprivate func unwrap(_ any: Any) -> Any? {
        let mirror = Mirror(reflecting: any)
        
        if mirror.displayStyle != .optional { return any }
        guard let child = mirror.children.first else { return nil }
        
        return child.value
    }
    
    init?(from: Any) {
        guard let dictionary = from as? KeyValue else {
            self.init()
            return
        }
        self.init(dictionary)
    }
    
    init(_ dictionary: KeyValue) {
        self.init()
        
        let properties = Mirror(reflecting: self).children.filter { $0.label != nil }
        
        for property in properties {
            let classKey = property.label!
            let dictKey = mapFromDictionary[classKey] ?? classKey
            guard let value = dictionary.valueForKeyPath(dictKey) else { continue }
            
            let mirror = Mirror(reflecting: property.value)
            
            if let type = mapFromDictionaryTypes[classKey] {
                if let valueToBeSet = type.init(from: value) {
                    self.setValue(valueToBeSet, forKey: classKey)
                }
            } else if let type = mirror.subjectType as? Mappable.Type {
                if let valueToBeSet = type.init(from: value) {
                    self.setValue(valueToBeSet, forKey: classKey)
                }
            } else if mirror.displayStyle == .optional {
                // Try to set value based on the dictionary type
                if let value = value as? Mappable {
                    self.setValue(value, forKey: classKey)
                }
            }
        }
    }
    
    var dictionaryValue: Any {
        return self.dictionary
    }
    
    var dictionary: KeyValue {
        var result = KeyValue()
        let properties = Mirror(reflecting: self).children.filter { $0.label != nil }
        
        for property in properties {
            let key = property.label!
            if let type = unwrap(property.value) as? Mappable {
                result[key] = type.dictionaryValue
            }
        }
        
        return result
    }
}
