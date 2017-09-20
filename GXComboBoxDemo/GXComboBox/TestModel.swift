//
//  TestModel.swift
//  GXComboBox
//
//  Created by Jiang on 2017/9/20.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit

protocol ComboBoxModelProtocol {
    var title: String { get }
    var isSelected: Bool { get set }
}

class TestModel: ComboBoxModelProtocol {
    
    var title: String {
        get {
            return catName
        }
    }
    
    var isSelected: Bool = false
    
    var catImage : String
    var catName : String
    var id : String
    var parentId : String
    var data : [TestModel]
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        catImage = dictionary["cat_image"] as? String ?? ""
        catName = dictionary["cat_name"] as? String ?? ""
        id = dictionary["id"] as? String ?? ""
        parentId = dictionary["parent_id"] as? String ?? ""
        
        data = [TestModel]()
        if let dataArray = dictionary["data"] as? [[String:Any]]{
            for dic in dataArray{
                let value = TestModel(fromDictionary: dic)
                data.append(value)
            }
        }
    }
    
}
