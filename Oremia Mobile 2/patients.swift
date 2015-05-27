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
    var idPhoto: Int
    var nom: String
    var prenom: String
    var photo:UIImage?
    
    init(id: Int, idP:Int, nom: String, prenom: String) {
        self.id = id
        self.idPhoto = idP
        self.nom = nom
        self.prenom = prenom
        self.photo = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://\(preference.ipServer)/scripts/OremiaMobileHD/image.php?query=select+image+from+images_preview+where+id=\(idPhoto)&&db=zuma&&login=zm501&&pw=zuma")!)!)
    }
    class func patientWithJSON(allResults: NSArray) -> [patients] {
        
        var tracks = [patients]()
        
        if allResults.count>0 {
            for trackInfo in allResults {
                        var id = trackInfo["id"] as? Int
                        var idP = trackInfo["idphoto"] as? Int
                        var nomP = trackInfo["nom"] as? String
                        var prenomP = trackInfo["prenom"] as? String
                        if(id == nil) {
                            id = 0
                        }
                        if(idP == nil) {
                                idP = 0
                        }
                        else if(nomP == nil) {
                            nomP = "?"
                        }
                        else if(prenomP == nil) {
                            prenomP = ""
                        }
                        var track = patients(id: id!, idP:idP!, nom: nomP!, prenom: prenomP!)
                        tracks.append(track)
            }
        }
        return tracks
    }
}