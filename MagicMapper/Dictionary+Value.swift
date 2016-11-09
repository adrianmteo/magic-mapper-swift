//
//  Created by Adrian Mateoaea on 03/10/2016.
//  Copyright © 2016 MagicMapper. All rights reserved.
//

import Foundation

extension Dictionary {
    /**
     Extract the value from dictionary using a _keyPath_.
     - parameter keyPath: A string that represents how the algorithm should pass through the dictionary structure in order to return the value.
     - returns: The actual object value from the dictionary. It returns _nil_ if there is no value or the _keyPath_ parameter does not coincide with the dictionary structure.
     */
    public func valueForKeyPath(_ keyPath: String) -> Any? {
        var keys = keyPath.components(separatedBy: ".")
        
        guard let key = keys.first as? Key else {
            print("Unable to use string as key on type: \(Key.self)")
            return nil
        }
        
        guard var value = self[key] else { return nil }
        
        keys.remove(at: 0)
        
        if !keys.isEmpty {
            while
                let key = keys.first,
                let index = Int(key),
                let arr = value as? [Value],
                index >= 0 && index < arr.count {
                    value = arr[index]
                    keys.remove(at: 0)
            }
            
            guard let dict = value as? Dictionary else {
                return nil
            }
            
            let rejoined = keys.joined(separator: ".")
            return dict.valueForKeyPath(rejoined)
        }
        
        return value
    }
}
