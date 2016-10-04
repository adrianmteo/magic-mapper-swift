//
//  Created by Adrian Mateoaea on 04/10/2016.
//  Copyright © 2016 Magic Mapper. All rights reserved.
//

import UIKit

extension Bool: Mappable {
    
    init?(from: Any) {
        if let value = from as? Bool {
            self.init(value)
            return
        } else if let value = from as? Int, value != 0 {
            self.init(true)
            return
        } else if let value = from as? String {
            self.init(value.lowercased() == "true")
            return
        }
        
        self.init()
    }
}
