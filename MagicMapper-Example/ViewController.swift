//
//  ViewController.swift
//  MagicMapper-Example
//
//  Created by Adrian Mateoaea on 04/10/2016.
//  Copyright © 2016 Magic Mapper. All rights reserved.
//

import UIKit
import Alamofire

class Company: NSObject, Mappable {
    
    var name        : String = ""
    var catchPhrase : String = ""
    var tags        : [String] = []
    
    func populateFrom(_ dictionary: Mappable.KeyValue) {
        if let bs = dictionary["bs"] as? String {
            self.tags = bs.components(separatedBy: " ")
        }
    }
}

class User: NSObject, Mappable {
    
    var id       : String = ""
    var fullName : String = ""
    var nickname : String = ""
    var city     : String = ""
    var company  : Company = Company()
    
    var fromDictionaryNameMappings: Mappable.Mapping {
        return [
            "fullName" : "name",
            "nickname" : "username",
            "city"     : "address.city"
        ]
    }
}

class ViewController: UITableViewController {

    fileprivate let URL = "https://jsonplaceholder.typicode.com/users"
    
    var items: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(URL).responseJSON { (response) in
            if let arr = response.result.value as? [Mappable.KeyValue] {
                self.items = arr.map { User($0) }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let item = items[indexPath.row]
        
        cell.textLabel?.text = "\(item.fullName) (\(item.nickname))"
        cell.detailTextLabel?.text = item.company.name
        
        return cell
    }

}
