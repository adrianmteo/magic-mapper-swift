//
//  Created by Adrian Mateoaea on 03/10/2016.
//  Copyright © 2016 MagicMapper. All rights reserved.
//

import Foundation

extension Dictionary {
    
    public func valueForKeyPath(_ keyPath: String) -> Any? {
        var keys = keyPath.components(separatedBy: ".")
        guard let first = keys.first as? Key else {
            print("Unable to use string as key on type: \(Key.self)")
            return nil
        }
        
        guard let value = self[first] else { return nil }
        keys.remove(at: 0)
        
        if !keys.isEmpty, let subDict = value as? Dictionary {
            let rejoined = keys.joined(separator: ".")
            return subDict.valueForKeyPath(rejoined)
        }
        
        return value
    }
}
