/*
Converts A class to a dictionary, used for serializing dictionaries to JSON
Supported objects:
- Serializable derived classes (sub classes)
- Arrays of Serializable
- NSData
- String, Numeric, and all other NSJSONSerialization supported objects
*/

import Foundation

public class Serializable: NSObject {
    
    /**
    Converts the class to a dictionary.
    
    - returns: The class as an NSDictionary.
    */
    public func toDictionary() -> NSDictionary
    {
        let propertiesDictionary = NSMutableDictionary()
        //let mirror = reflect(self)
        let mirror = Mirror(reflecting: self)
        
        for c in mirror.children {
            
            let propName = c.label
            let childMirror = c.value
            
            
            //        for i in 1..<mirror..count {
            //            let (propName, childMirror) = mirror[i]
            
            if let propValue: AnyObject = self.unwrap(childMirror) as? AnyObject {
                if let serializablePropValue = propValue as? Serializable {
                    propertiesDictionary.setValue(serializablePropValue.toDictionary(), forKey: propName!)
                } else if let arrayPropValue = propValue as? [Serializable] {
                    var subArray = [NSDictionary]()
                    for item in arrayPropValue {
                        subArray.append(item.toDictionary())
                    }
                    
                    propertiesDictionary.setValue(subArray, forKey: propName!)
                } else if propValue is Int || propValue is Double || propValue is Float {
                    propertiesDictionary.setValue(propValue, forKey: propName!)
                } else if let dataPropValue = propValue as? NSData {
                    propertiesDictionary.setValue(dataPropValue.base64EncodedStringWithOptions(.Encoding64CharacterLineLength), forKey: propName!)
                } else if let datePropValue = propValue as? NSDate {
                    propertiesDictionary.setValue(datePropValue.timeIntervalSince1970, forKey: propName!)
                } else if let boolPropValue = propValue as? Bool {
                    propertiesDictionary.setValue(boolPropValue, forKey: propName!)
                } else {
                    propertiesDictionary.setValue(propValue, forKey: propName!)
                }
            }
        }
        
        return propertiesDictionary
    }
    
    /**
    Converts the class to JSON.
    
    - returns: The class as JSON, wrapped in NSData.
    */
    public func toJson() -> NSData {
        let dictionary = self.toDictionary()
        
        var err: NSError?
        
        do {
            let json = try NSJSONSerialization.dataWithJSONObject(dictionary, options: .PrettyPrinted)
            return json
        } catch let error1 as NSError {
            err = error1
            let error = err?.description ?? "nil"
            print("ERROR: Unable to serialize json, error: \(error)", terminator: "")
            NSNotificationCenter.defaultCenter().postNotificationName("CrashlyticsLogNotification", object: self, userInfo: ["string": "unable to serialize json, error: \(error)"])
            abort()
        }
    }
    
    /**
    Converts the class to a JSON string.
    
    - returns: The class as a JSON string.
    */
    public func toJsonString() -> String! {
        return NSString(data: self.toJson(), encoding: NSUTF8StringEncoding) as String!
    }
}

extension Serializable {
    private func unwrap(any: Any) -> Any? {
        
        let mi = Mirror(reflecting: any)
        
        if mi.descendant("Some") == nil { // not sure in this row but seems it works
            return any
        }
        
        if mi.children.count == 0 {
            return nil
        }
        
        let (_, some) = mi.children.first!
        
        return some
    }
}