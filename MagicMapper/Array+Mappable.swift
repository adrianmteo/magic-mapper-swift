//
//  Created by Adrian Mateoaea on 04/10/2016.
//  Copyright © 2016 Magic Mapper. All rights reserved.
//

import UIKit

extension Array: Mappable {
    
    init?(from: Any) {
        guard let array = from as? [Any], let type = Element.self as? Mappable.Type else {
            self.init()
            return
        }
        
        let values = array.flatMap { type.init(from: $0) as? Element }
        self.init(values)
    }
}
