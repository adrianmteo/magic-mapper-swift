# magic-mapper-swift
🌟 Super light and easy JSON to model mapper

## How to convert

### Step 1: Get the JSON model

```json
{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
    "geo": {
      "lat": "-37.3159",
      "lng": "81.1496"
    }
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
  }
}
```

### Step 2: Write the Swift models

```swift
class Company: NSObject, Mappable {
    var name        : String = ""
    var catchPhrase : String = ""
    var tags        : [String] = []
}

class User: NSObject, Mappable {
    var id       : String = ""
    var fullName : String = ""
    var nickname : String = ""
    var city     : String = ""
    var company  : Company = Company()
}
```

### Step 3: Tell the mapper how to convert

The method `populateFrom` lets you custom populate your model.
The property `fromDictionaryNameMappings` tells the mapper where it will find the class properties.

```swift
class Company: NSObject, Mappable {

    ...
    
    func populateFrom(_ dictionary: Mappable.KeyValue) {
        if let bs = dictionary["bs"] as? String {
            self.tags = bs.components(separatedBy: " ")
        }
    }
}

class User: NSObject, Mappable {
    
    ...
    
    var fromDictionaryNameMappings: Mappable.Mapping {
        return [
            "fullName" : "name",
            "nickname" : "username",
            "city"     : "address.city"
        ]
    }
}
```

### Step 4: That's it!
