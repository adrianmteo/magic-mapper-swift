//
//  ViewController.swift
//  MagicMapper-Example
//
//  Created by Adrian Mateoaea on 04/10/2016.
//  Copyright © 2016 Magic Mapper. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class GithubRepository: NSObject, Mappable {
    
    var id    : String = ""
    var name  : String = ""
    var body  : String = ""
    var url   : String = ""
    var photo : String = ""
    
    var fromDictionaryNameMappings: Mappable.Mapping {
        return [
            "body"  : "description",
            "photo" : "owner.avatar_url"
        ]
    }
}

class GithubSearch: NSObject, Mappable {
    
    var total : Int = 0
    var items : [GithubRepository] = []
    
    var fromDictionaryNameMappings: Mappable.Mapping {
        return [
            "total" : "total_count",
        ]
    }
    
    func populateFrom(_ dictionary: Mappable.KeyValue) {
        if let arr = dictionary["items"] as? [Mappable.KeyValue] {
            self.items = arr.map { GithubRepository($0) }
        }
    }
}

class ViewController: UITableViewController {

    fileprivate let APIURL = "https://api.github.com/search/repositories?q=+language:swift"
    
    var feed: GithubSearch? {
        didSet {
            if let feed = feed {
                self.title = "Total: \(feed.total)"
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(APIURL).responseJSON { (response) in
            if let dictionary = response.result.value as? Mappable.KeyValue {
                self.feed = GithubSearch(dictionary)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.tag = indexPath.row
        
        if let item = feed?.items[indexPath.row] {
            Alamofire.request(item.photo).responseImage(completionHandler: { (response) in
                DispatchQueue.main.async { [weak cell] in
                    if let image = response.result.value, cell?.tag == indexPath.row {
                        cell?.imageView?.image = image
                        cell?.setNeedsLayout()
                    }
                }
            })
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.body
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
