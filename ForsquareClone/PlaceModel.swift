//
//  PlaceModel.swift
//  ForsquareClone
//
//  Created by Zeynep Özdemir Açıkgöz on 1.08.2022.
//

import Foundation
import UIKit

class PlaceModel{
    //sharedInstance Paylaşılan objeyi temsil ediyor
    
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLAtitude = ""
    var placeLongitude = ""
    
    private init(){}
}
