# magic-mapper-swift
🌟 Super light and easy automatic JSON to model mapper

- [ ] Finish writing `README.md`
- [ ] Ability to convert model back to dictionary

## How to setup

### Step 1: Get the JSON model

```json
{
  "total_count": 176552,
  "incomplete_results": false,
  "items": [
    {...}
  ]
}
```

### Step 2: Write the Swift models

```swift
class GithubRepository: NSObject, Mappable {
    var id        : String = ""
    var name      : String = ""
    var body      : String = ""
    var url       : String = ""
    var photo     : String = ""
    var createdAt : Date?
}

class GithubSearch: NSObject, Mappable {
    var total : Int = 0
    var items : [GithubRepository] = []
}
```

### Step 3: Link your custom namings with the JSON model

The `mapFromDictionary` property lets you customize the properties mappings. You can also access nested values within dictionaries and arrays (example: `emails.0.address`).

```swift
var mapFromDictionary: [String : String] {
    return [
        "body"      : "description",
        "photo"     : "owner.avatar_url",
        "createdAt" : "created_at"
    ]
}
```

### Step 4: Custom properties

The `mapFromDictionaryTypes` property let's you customize the type of the JSON property (only for optionals). If you have other Swift structures that you need to use, just extend them using the `Mappable` protocol.

```swift
var mapFromDictionaryTypes: [String : Mappable.Type] {
    return [
        "createdAt" : Date.self
    ]
}
```

For instance `createdAt` is of type `Date` and the JSON property is of type `String`. In order to convert the `String` to a `Date` type, just extend it using the `Mappable` protocol and it will automatically know to convert and set the value to the model.

```swift
extension Date: Mappable {
    
    init?(from: Any) {
        if let value = from as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd'T'HH':'mm':'ss'Z'"
            if let date = formatter.date(from: value) {
                self.init(timeIntervalSince1970: date.timeIntervalSince1970)
                return
            }
        }
        
        self.init()
    }
}
```

### And that's it!

You can now populate your model from the generic dictionary that comes from your network layer. Happy coding :)

```swift
Alamofire.request(APIURL).responseJSON { (response) in
    if let dictionary = response.result.value as? KeyValue {
        self.feed = GithubSearch(dictionary)
    }
}
```
