//
//  Created by Adrian Mateoaea on 04/10/2016.
//  Copyright © 2016 Magic Mapper. All rights reserved.
//

import Foundation

extension Dictionary: Mappable {
    
    public init?(from: Any) {
        self.init()
        
        guard let dictionary = from as? [Key: Any], let type = Value.self as? Mappable.Type else {
            return
        }
        
        for (key, value) in dictionary {
            if let element = type.init(from: value) as? Value {
                self[key] = element
            }
        }
    }
}
