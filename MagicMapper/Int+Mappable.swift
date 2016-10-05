//
//  Created by Adrian Mateoaea on 04/10/2016.
//  Copyright © 2016 Magic Mapper. All rights reserved.
//

import Foundation

extension Int: Mappable {
    
    public init?(from: Any) {
        if let value = from as? Int {
            self.init(value)
            return
        } else if let value = from as? String {
            self.init(value)
            return
        }
        
        self.init()
    }
}
