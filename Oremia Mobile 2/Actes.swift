//
//  Actes.swift
//  Oremia Mobile 2
//
//  Created by Zumatec on 22/05/2015.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import Foundation
class Actes{
    var id: Int
    var idDocument:Int
    var date: String
    var localisation: Int
    var lettre: String
    var cotation:Int
    var descriptif:String
    var montant:String
    
    init(id:Int,idDocument:Int,date:String,localisation: Int,lettre: String,cotation:Int,descriptif:String,montant:String) {
        self.id=id
        self.idDocument = idDocument
        self.date=date
        self.localisation=localisation
        self.lettre = lettre
        self.cotation=cotation
        self.descriptif = descriptif
        self.montant = montant        
    }
    class func actesWithJSON(allResults: NSArray) -> [Actes] {
        var actes = [Actes]()
        if allResults.count>0 {
            for result in allResults {
                var id = result["id"] as? Int
                var idDocument = result["iddocument"] as? Int
                if idDocument == nil{ idDocument=0 }
                let date = result["date"] as? String
                var localisation = result["localisation"] as? Int
                if localisation == nil{localisation = 0}
                let lettre = result["lettre"] as? String
                var cotation = result["cotation"] as? Int
                if cotation == nil {cotation=0}
                let descriptif = result["description"] as? String
                var montant = result["montant"] as? String
                if montant == nil {montant = ""}
                
                var newAlbum = Actes(id: id!, idDocument: idDocument!, date: date!, localisation: localisation!, lettre: lettre!, cotation: cotation!, descriptif: descriptif!, montant: montant!)
                actes.append(newAlbum)
            }
        }
        return actes
    }
}