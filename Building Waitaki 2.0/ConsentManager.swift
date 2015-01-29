//
//  ConsentManager.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 13/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class ConsentManager
{
    var consentArray: [Consent]?
    var user: String?
    
    init()
    {
        consentArray = [Consent]()
    }
    
    //method used to parse the json string into a dictionary array
    func JSONParseArray(jsonString: String) -> [AnyObject]
    {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        {
            if let array = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil) as? [AnyObject]
            {
                return array
            }
        }
        return [AnyObject]()
    }
    
    //take the string and change it into consent objects
    func loadConsentsFromServer(JSONString: String, context: NSManagedObjectContext )
    {
        var error : NSError?
        let JSONData = JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        for elem:AnyObject in JSONParseArray(JSONString)
        {
            let consent = Consent()
            consent.siteAddress = elem["siteAddress"] as? String
            consent.account = elem["account"] as? String
            consent.consentNumber = elem["consentNumber"] as? String
            consent.workDescription = elem["description"] as? String
            let contacts = elem["contact"] as NSArray
            let inspections = elem["inspections"] as NSArray
            
            //init the arrays
            consent.inspectionArray = [Inspection]()
            consent.contactArray = [Contact]()
            
            for contact:AnyObject in contacts
            {
                let newContact = Contact()
                newContact.FirstName = contact["firstName"] as? String
                newContact.LastName = contact["lastName"] as? String
                newContact.CellPhone = contact["cellPhone"] as? String
                newContact.HomePhone = contact["homePhone"] as? String
                newContact.Position = contact["position"] as? String
                consent.contactArray!.append(newContact)
            }
            
            for inspection:AnyObject in inspections
            {
                let inspectionItems = inspection["inspectionItems"] as NSArray
                let amount:Int! = removingSpacesAtTheEndOfAString((inspection["amountToDo"] as? String)!).toInt()
                
                for var i = 0; i < amount; i++
                {
                let newInspection = Inspection()
                    newInspection.InspectionItemArray = [InspectionItem]()
                newInspection.Name = inspection["name"] as? String
                newInspection.InspectionID = inspection["inspectionID"] as? String
                    
                    for inspectionItem:AnyObject in inspectionItems
                    {
                        var newInspectionItem = InspectionItem()
                        
                        newInspectionItem.Item = inspection["name"] as? String
                        
                        if (inspectionItem["camera"] as? String) == "1"
                        {
                            newInspectionItem.Camera? = true;
                        }
                        else
                        {
                            newInspectionItem.Camera? = false;
                        }
                        
                        newInspectionItem.Item? = (inspectionItem["name"] as? String)!
                        if (inspectionItem["required"] as? String) == "Y"
                        {
                            newInspectionItem.required = true
                        }
                        else
                        {
                            newInspectionItem.required = false
                        }
                        
                        switch removingSpacesAtTheEndOfAString((inspectionItem["type"] as? String)!)
                        {
                            case "F":
                                        newInspectionItem.Type = InspectionItem.InspectionType.PassFailNA
                            case "NR":
                                        newInspectionItem.Type = InspectionItem.InspectionType.ShortText
                            case "T":
                                        newInspectionItem.Type = InspectionItem.InspectionType.ShortText
                            case "D":
                                        newInspectionItem.Type = InspectionItem.InspectionType.Date
                                    
                        default:
                                        newInspectionItem.Type = nil
                        }
                        newInspection.InspectionItemArray!.append(newInspectionItem)
                    }
                consent.inspectionArray!.append(newInspection)
                }
            }

            //add consent to array
            consentArray?.append(consent)
        }
        //println(consentArray?.count)
saveConsentsToCoreData(context)
      
    }
    
    func loadConsentsFromCoreData(context: NSManagedObjectContext)
    {
        let fetchRequest = NSFetchRequest(entityName:"SavedConsent")
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [SavedConsent]
        {
            if fetchResults.count > 0
            {
                for var i = 0; i < fetchResults.count; i++
                {
                    var newConsent: Consent = Consent()
                    println(fetchResults[i].workDescription)
                    newConsent.siteAddress = fetchResults[i].siteAddress
                    newConsent.consentNumber = fetchResults[i].consentNumber
                    newConsent.account = fetchResults[i].account
                    newConsent.workDescription = fetchResults[i].workDescription
                    
                    newConsent.contactArray = [Contact]()
                    newConsent.inspectionArray = [Inspection]()
                    
                    for currentContact in fetchResults[i].contact
                    {
                        let contact = currentContact as SavedContact
                        var newContact: Contact = Contact()
                        newContact.FirstName = contact.firstName
                        newContact.LastName = contact.lastName
                        newContact.Position = contact.position
                        newContact.HomePhone = contact.homePhone
                        newContact.CellPhone = contact.cellPhone
                        //add new contact to the consent
                        newConsent.contactArray?.append(newContact)
                    }
                    
                    for currentInspection in fetchResults[i].inspection
                    {
                        let inspection = currentInspection as SavedInspection
                        var newInspection: Inspection = Inspection()
                        newInspection.Name = inspection.name;
                        newInspection.InspectionID = inspection.id
                        if let insp = inspection.comments
                        {
                        newInspection.Comments = inspection.comments
                        }
                        newInspection.BuildingConsentOfficer = inspection.officer
                        for currentInspItem in inspection.inspectionItem
                        {
                            let inspItem = currentInspItem as SavedInspectionItem
                            var newItem: InspectionItem = InspectionItem()
                            newItem.Item = inspItem.name
                            newItem.Camera = inspItem.camera
                            newItem.required = inspItem.required
                            switch inspItem.type
                            {
                            case "F" :
                                newItem.Type = InspectionItem.InspectionType.PassFailNA
                            case "D" :
                                newItem.Type = InspectionItem.InspectionType.Date
                            case "NR" :
                                newItem.Type = InspectionItem.InspectionType.ShortText
                            case "T" :
                                newItem.Type = InspectionItem.InspectionType.ShortText
                            default:
                                newItem.Type = nil
                            }
                            if let val = inspItem.value
                            {
                            newItem.Value = inspItem.value
                            }
                            
                            //for image in inspItem.image //CAMERA SAVING LOADING FROM HERE
                           // {
                             //   let image: SavedImages = SavedImages()
                            //    var newImage: NSData = image.image
                         //   }
                            
                            newInspection.InspectionItemArray?.append(newItem)
                        }
                        newConsent.inspectionArray?.append(newInspection)
                    }
                    consentArray?.append(newConsent)
                }
            }
            else
            {
                println("no consent data found")
            }
            println(consentArray?.count)
        }

    }
    
    
    //save consents to core data for syncing later
    func saveConsentsToCoreData(context: NSManagedObjectContext)
    {
        //remove saved data
        let fetchRequest = NSFetchRequest(entityName:"SavedConsent")
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [SavedConsent]
        {
            if fetchResults.count > 0
            {
                for consent:SavedConsent in fetchResults
                {
                    println("removing" + consent.siteAddress)
                    context.deleteObject(consent)
                }
            }
        }

        
       // println(consentArray?.count)
        for consent:Consent in consentArray!
        {
            let newConsent = NSEntityDescription.insertNewObjectForEntityForName("SavedConsent", inManagedObjectContext: context) as SavedConsent
            newConsent.account = consent.account!
            newConsent.consentNumber = consent.consentNumber!
            newConsent.siteAddress = consent.siteAddress!
            newConsent.workDescription = consent.workDescription!
            
            for contact:Contact in consent.contactArray!
            {
                let newContact = NSEntityDescription.insertNewObjectForEntityForName("SavedContact", inManagedObjectContext: context) as SavedContact
                newContact.firstName = contact.FirstName!
                newContact.lastName = contact.LastName!
                newContact.position = contact.Position!
                newContact.homePhone = contact.HomePhone!
                newContact.cellPhone = contact.CellPhone!
                newContact.consent = newConsent
                newConsent.addContactObject(newContact)
            }
            
            for inspection:Inspection in consent.inspectionArray!
            {
                let newInspection = NSEntityDescription.insertNewObjectForEntityForName("SavedInspection", inManagedObjectContext: context) as SavedInspection
                newInspection.id = inspection.InspectionID!
                newInspection.name = inspection.Name!
                if (inspection.Comments != nil)
                {
                newInspection.comments = inspection.Comments!
                }
                
                if (inspection.BuildingConsentOfficer != nil)
                {
                newInspection.officer = inspection.BuildingConsentOfficer!
                }
                
                for insItem:InspectionItem in inspection.InspectionItemArray!
                {
                    let newInsItem = NSEntityDescription.insertNewObjectForEntityForName("SavedInspectionItem", inManagedObjectContext: context) as SavedInspectionItem
                    if (insItem.Camera != nil)
                    {
                        newInsItem.camera = insItem.Camera!
                    }
                    newInsItem.name = insItem.Item!
                    newInsItem.required = insItem.required!
                    switch (insItem.Type!)
                    {
                    case (InspectionItem.InspectionType.PassFailNA):
                            newInsItem.type = "PassFailNA"
                    case (InspectionItem.InspectionType.ShortText):
                        newInsItem.type = "ShortText"
                    case (InspectionItem.InspectionType.YesNo):
                        newInsItem.type = "YesNo"
                    case (InspectionItem.InspectionType.Date):
                        newInsItem.type = "Date"
                    }
                    
                    if (insItem.Value != nil)
                    {
                    newInsItem.value = insItem.Value!
                    }
                    
                    //add images to item?
                    
                    newInspection.addInspectionItemObject(newInsItem)
                }
                
                
                newConsent.addInspectionObject(newInspection)
                
                
            }
        }
        //save back
        var error: NSError?
        context.save(&error)
        
        if let err = error {
            //handle error
            println(err)
        }
        
        //remove after testing
        loadConsentsFromCoreData(context)
        
    }
    
    private func removingSpacesAtTheEndOfAString(var str: String) -> String {
        var i: Int = countElements(str) - 1, j: Int = i
        
        while(i >= 0 && str[advance(str.startIndex, i)] == " ") {
            --i
        }
        
        return str.substringWithRange(Range<String.Index>(start: str.startIndex, end: advance(str.endIndex, -(j - i))))
    }
}

