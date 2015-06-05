//
//  patients.swift
//  Oremia mobile
//
//  Created by Zumatec on 23/03/2015.
//  Copyright (c) 2015 Zumatec. All rights reserved.
//

import Foundation
class patients {
    
    var id: Int
    var civilite:Int
    var idPhoto: Int
    var nom: String
    var prenom: String
    var adresse: String
    var codePostal:String
    var ville:String
    var telephone1:String
    var telephone2:String
    var email:String
    var dateNaissance:String
    var autoSMS:Bool
    var profession:String
    var photo:UIImage?
    
    init(id: Int, idP:Int, nom: String, prenom: String, civilite:Int, adresse:String, codePostal:String, ville: String, tel1:String, tel2: String, email:String, dn:String, sms:Bool, profession:String) {
        self.id = id
        self.idPhoto = idP
        self.nom = nom
        self.prenom = prenom
        self.photo = UIImage(named: "glyphicons_003_user")
        self.civilite = civilite
        self.adresse = adresse
        self.codePostal = codePostal
        self.ville = ville
        self.telephone1 = tel1
        self.telephone2 = tel2
        self.email = email
        self.dateNaissance = dn
        self.autoSMS = sms
        self.profession = profession
    }
    class func patientWithJSON(allResults: NSArray) -> [patients] {
        
        var tracks = [patients]()
        
        if allResults.count>0 {
            for trackInfo in allResults {
                        var id = trackInfo["id"] as? Int ?? 0
                        var idP = trackInfo["idphoto"] as? Int ?? 0
                        var nomP = trackInfo["nom"] as? String ?? ""
                        var prenomP = trackInfo["prenom"] as? String ?? ""
                        var civilite = trackInfo["genre"] as? Int ?? 0
                        var adresse = trackInfo["adresse"] as? String ?? ""
                        var codePostal = trackInfo["codepostal"] as? String ?? ""
                        var ville = trackInfo["ville"] as? String ?? ""
                        var tel1 = trackInfo["telephone1"] as? String ?? ""
                        var tel2 = trackInfo["telephone2"] as? String ?? ""
                        var email = trackInfo["email"] as? String ?? ""
                        var dn = trackInfo["naissance"] as? String ?? ""
                        var sms = trackInfo["autorise_sms"] as? Bool ?? false
                        var profession = trackInfo["profession"] as? String ?? ""
                        var track = patients(id: id, idP:idP, nom: nomP, prenom: prenomP, civilite: civilite, adresse: adresse,codePostal: codePostal,ville: ville,tel1: tel1,tel2: tel2,email: email,dn: dn,sms: sms,profession: profession)
                        tracks.append(track)
            }
        }
        return tracks
    }
}