//
//  Created by Adrian Mateoaea on 03/10/2016.
//  Copyright © 2016 MagicMapper. All rights reserved.
//

import Foundation

extension Dictionary {
    
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
                    keys.remove(at: 0)
                    value = arr[index]
            }
            if let dict = value as? Dictionary {
                let rejoined = keys.joined(separator: ".")
                return dict.valueForKeyPath(rejoined)
            }
        }
        
        return value
    }
}
