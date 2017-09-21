//
//  ViewController.swift
//  GXComboBox
//
//  Created by Jiang on 2017/9/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    let comboBoxView: GXComboBoxView = GXComboBoxView()
    
    var titles: [String] = ["综合排序", "全部", "筛选"]
    
    var dataSoure: [[TestModel]] = [[TestModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpData()
        
        comboBoxView.backgroundColor = UIColor.white
        
        comboBoxView.delegate = self
        comboBoxView.dataSoure = self
        
        view.addSubview(comboBoxView)
    }
    
    // MARK: 设置数据
    fileprivate func setUpData() {
        
        let group01Titles = ["综合排序", "人气排序", "价格最高", "价格最低"]
        let group03Titles = ["全部", "收费", "免费"]
        
        dataSoure.append(getGroupModels(titles: group01Titles))
        
        let arr = NSArray(contentsOfFile: Bundle.main.path(forResource: "data", ofType: "plist")!) as! [[String : Any]]
        
        var group02 = [TestModel]()
        for dic in arr {
            let model = TestModel(fromDictionary: dic)
            group02.append(model)
        }
        dataSoure.append(group02)
            
        dataSoure.append(getGroupModels(titles: group03Titles))
    }
    
    fileprivate func getGroupModels(titles: [String]) -> [TestModel] {
        
        var models = [TestModel]()
        
        for title in titles {
            let model = TestModel(fromDictionary: ["cat_name" : title])
            models.append(model)
        }
        
        return models
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        comboBoxView.frame = CGRect.init(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 44)
    }
}

extension ViewController: GXComboBoxViewDelegate {
    
    func comboBoxView(_ comboBoxView: GXComboBoxView, heightForRowAt indexPath: GXIndexPath) -> CGFloat {
        
        return 50
    }
    
    func comboBoxView(_ comboBoxView: GXComboBoxView, didSelectedRowAt indexPath: GXIndexPath) {
        
        // 获取数据
        var data = dataSoure[indexPath.column]
        
        var selectedModel: TestModel?
        var col = 0
        while data.count > 0 {
            
            if col == indexPath.section {
                selectedModel = data[indexPath.row]
                
                clearOldSelected(data: data)
                break
            }
            
            
            let sel = data.filter({ $0.isSelected })
            if sel.count == 1 {
                data = sel.first!.data
            } else {
                return
            }
            col += 1
        }
        
        selectedModel?.isSelected = true
        titles[indexPath.column] = selectedModel?.catName ?? ""
        
        comboBoxView.reloadData()
        
        if selectedModel?.data.count == 0 {
            comboBoxView.closeSelecting()
        }
    }
    
    func clearOldSelected(data: [TestModel]) {
        
        let sel = data.filter({ $0.isSelected })
        
        if sel.count > 0 {
            for i in 0..<sel.count {
                clearOldSelected(data: sel[i].data)
            }
        }
        
        _ = data.map({ $0.isSelected = false})
    }
}

extension ViewController: GXComboBoxViewDataSoure {
    
    func numberOfColumn(in comboBoxView: GXComboBoxView) -> Int {
        
        return titles.count
    }
    
    func comboBoxView(_ comboBoxView: GXComboBoxView, numberOfSectionInColumn column: Int) -> Int {
        
        // 获取列数据
        let data = dataSoure[column]
        
        var section = 1
        
        var selecteds = data.filter({ $0.isSelected })
        
        while selecteds.count == 1 && selecteds.first!.data.count > 0 {
            selecteds = selecteds.first!.data.filter({ $0.isSelected })
            section += 1
        }
        
        return section
    }
    
    func comboBoxView(_ comboBoxView: GXComboBoxView, numberOfSectionInColumn column: Int, section: Int, regiseCell tableView: UITableView) {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
    }
    
    func comboBoxView(_ comboBoxView: GXComboBoxView, numberOfRowsInColum column: Int, section: Int) -> Int {
        
        // 获取列数据
        var data = dataSoure[column]
        
        var sectionNum = section
        
        while sectionNum > 0 {
            data = data.filter({ $0.isSelected }).first?.data ?? [TestModel]()
            sectionNum -= 1
        }
        
        return data.count
    }
    
    func comboBoxView(_ comboBoxView: GXComboBoxView, cellForRowAt indexPath: GXIndexPath) -> UITableViewCell {
        
        // 获取列数据
        var data = dataSoure[indexPath.column]
        
        var section = indexPath.section + 1
        
        while section > 1 {
            data = data.filter({ $0.isSelected }).first?.data ?? [TestModel]()
            section -= 1
        }
        
        var model: TestModel?
        if data.count > indexPath.row {
            model = data[indexPath.row]
        }
        
        let cell = UITableViewCell()
        
        cell.selectionStyle = .none
        
        if model != nil {
            cell.backgroundColor = model!.isSelected ? UIColor.groupTableViewBackground : UIColor.white
        }
        cell.textLabel?.text = model?.title ?? ""
        
        return cell
    }
    
    func titleOfColumn(_ comboBoxView: GXComboBoxView, numberOfColumn column: Int) -> String {
        return titles[column]
    }

}
