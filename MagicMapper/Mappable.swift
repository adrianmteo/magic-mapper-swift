//
//  Created by Adrian Mateoaea on 03/10/2016.
//  Copyright © 2016 MagicMapper. All rights reserved.
//

import Foundation

protocol Mappable {
    typealias KeyValue = [String: Any]
    typealias Mapping = [String: String]
    
    init(_ dictionary: KeyValue)
    func populateFrom(_ dictionary: KeyValue)
    
    var fromDictionaryNameMappings: Mapping { get }
    var toDictionaryNameMappings: Mapping { get }
    
    var excludedPropertiesFromDictionary: [String] { get }
    var dictionary: KeyValue { get }
    
    func convertValue(_ value: Any, fromDictionaryKey key: String) -> Any?
    func convertValue(_ value: Any, forDictionaryKey key: String) -> Any?
}

extension Mappable where Self: NSObject {
    
    init(_ dictionary: KeyValue) {
        self.init()
        self.loadDataFrom(dictionary)
    }
    
    fileprivate func loadDataFrom(_ dictionary: KeyValue) {
        let properties = Mirror(reflecting: self).children.filter { $0.label != nil }
        for property in properties {
            let key = fromDictionaryNameMappings[property.label!] ?? property.label!
            let mirror = Mirror(reflecting: property.value)
            
            var value: Any? = nil
            
            if mirror.subjectType is String.Type {
                value = dictionary.valueForKeyPath(key) as? String
            } else if mirror.subjectType is Int.Type {
                value = dictionary.valueForKeyPath(key) as? Int
            } else if mirror.subjectType is Bool.Type {
                value = dictionary.valueForKeyPath(key) as? Bool
            } else if mirror.subjectType is Double.Type {
                value = dictionary.valueForKeyPath(key) as? Double
            } else if let type = mirror.subjectType as? Mappable.Type {
                if let dictValue = dictionary.valueForKeyPath(key) as? KeyValue {
                    value = type.init(dictValue)
                }
            } else {
                let dictValue = dictionary.valueForKeyPath(key)
                value = convertValue(dictValue, fromDictionaryKey: key)
            }
            
            if let value = value {
                self.setValue(value, forKey: property.label!)
            }
        }
        
        populateFrom(dictionary)
    }
    
    func populateFrom(_ dictionary: KeyValue) {
        //
    }
    
    var fromDictionaryNameMappings: Mapping {
        return [:]
    }
    var toDictionaryNameMappings: Mapping {
        return [:]
    }
    
    var excludedPropertiesFromDictionary: [String] {
        return []
    }
    
    func convertValue(_ value: Any, fromDictionaryKey key: String) -> Any? {
        return nil
    }
    
    func convertValue(_ value: Any, forDictionaryKey key: String) -> Any? {
        return nil
    }
    
    var dictionary: KeyValue {
        let excluded = excludedPropertiesFromDictionary
        let properties = Mirror(reflecting: self).children.flatMap { element -> Mirror.Child? in
            if let label = element.label, !excluded.contains(label) {
                return element
            }
            return nil
        }
        
        var dictionary = KeyValue()
        
        for property in properties {
            let key = toDictionaryNameMappings[property.label!] ?? property.label!
            
            if let value = convertValue(property.value, forDictionaryKey: key) {
                dictionary[key] = value
            } else if let value = property.value as? Mappable {
                dictionary[key] = value.dictionary
            } else if let value = property.value as? [Mappable] {
                dictionary[key] = value.map { $0.dictionary }
            } else {
                dictionary[key] = property.value
            }
        }
        
        return dictionary
    }
}
