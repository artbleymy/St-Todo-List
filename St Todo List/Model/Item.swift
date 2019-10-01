//
//  Item.swift
//  St Todo List
//
//  Created by Stanislav on 01/10/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    let name: String 
    var checked: Bool = false
    
    init(name: String, checked: Bool) {
        self.name = name
        self.checked = checked
        
    }
    init(name: String) {
        self.name = name
    }
}
