//
//  MagicMapper_Tests.swift
//  MagicMapper-Tests
//
//  Created by Adrian Mateoaea on 09/11/2016.
//  Copyright © 2016 Magic Mapper. All rights reserved.
//

import XCTest
import MagicMapper

class MagicMapper_Tests: XCTestCase {
    
    class Profile: NSObject, Mappable {
        var firstName : String = ""
        var lastName  : String = ""
        
        var mapFromDictionary: [String : String] {
            return [
                "firstName" : "first_name",
                "lastName"  : "last_name"
            ]
        }
    }
    
    class Message: NSObject, Mappable {
        var id    : String = ""
        var title : String = ""
    }
    
    class Model: NSObject, Mappable {
        var profile: Profile?
        var messages: [Message] = []
        
        var mapFromDictionaryTypes: [String : Mappable.Type] {
            return [
                "profile"  : Profile.self
            ]
        }
    }
    
    fileprivate let example1: [String: Any] = [
        "profile": [
            "first_name": "John",
            "last_name": "Snow"
        ],
        "messages": [
            [
                "id": 1
            ],
            [
                "id": 2
            ]
        ]
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValueForKeyPath() {
        XCTAssertEqual(example1.valueForKeyPath("profile.first_name") as? String, "John", "Should return the first name from the `profile` dictionary")
        XCTAssertNil(example1.valueForKeyPath("profile.username"), "Should return nil because the `username` key is not found in the `profile` dictionary")
        XCTAssertEqual(example1.valueForKeyPath("messages.0.id") as? Int, 1, "Should return the `id` from the first `message` element")
        XCTAssertNil(example1.valueForKeyPath("messages.id"), "Should return nil because the `id` key is not valid for an array")
    }
    
    func testModelMapping() {
        let model = Model(from: self.example1)
        XCTAssertEqual(model?.profile?.firstName, "John")
        XCTAssertEqual(model?.messages[1].id, "2")
        XCTAssertEqual(model?.messages[0].title, "")
    }
}
