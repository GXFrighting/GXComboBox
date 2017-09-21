//
//  GXComboBoxView.swift
//  GXComboBox
//
//  Created by Jiang on 2017/9/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit

class GXComboBoxViewType {
    
    var normalTitleColor: UIColor = UIColor.init(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1)
    
    var selectedTitleColor: UIColor = UIColor.init(red: 62/255.0, green: 92/255.0, blue: 238/255.0, alpha: 1)
}

class GXIndexPath {
    /// 列 （顶部按钮tag 0，1，2...）
    var column: Int
    /// 第几个tableview
    var section: Int
    /// 第几行
    var row: Int
    
    init(row: Int, section: Int, column: Int) {
        self.section = section
        self.row = row
        self.column = column
    }
}

// MARK: GXComboBoxViewDataSoure
protocol GXComboBoxViewDataSoure {
    
    /// 在这里注册每个TableView Cell
    ///
    /// - Parameters:
    ///   - comboBoxView: comboBoxView
    ///   - column: 列数
    ///   - section: 第几个TableView
    ///   - tableView: TableView
    /// - Returns: void
    func comboBoxView(_ comboBoxView: GXComboBoxView, numberOfSectionInColumn column: Int, section: Int, regiseCell tableView: UITableView)
    
    /// 获取列数
    ///
    /// - Parameters:
    ///   - comboBoxView: comboBoxView
    /// - Returns: 列数（顶部按钮多少个）
    func numberOfColumn(in comboBoxView: GXComboBoxView) -> Int
    
    /// 获取列对应的tableView个数
    ///
    /// - Parameters:
    ///   - comboBoxView: comboBoxView
    ///   - column: 列数
    /// - Returns: tableView个数
    func comboBoxView(_ comboBoxView: GXComboBoxView, numberOfSectionInColumn column: Int) -> Int

    /// 获取每个tableview row个数
    ///
    /// - Parameters:
    ///   - comboBoxView: comboBoxView
    ///   - column: 列数
    ///   - section: 第几个TableView
    /// - Returns: row
    func comboBoxView(_ comboBoxView: GXComboBoxView, numberOfRowsInColum column: Int, section: Int) -> Int

    /// 获取cell
    ///
    /// - Parameters:
    ///   - comboBoxView: comboBoxView
    ///   - indexPath: indexPath
    /// - Returns: cell
    func comboBoxView(_ comboBoxView: GXComboBoxView, cellForRowAt indexPath: GXIndexPath) -> UITableViewCell
    
    /// 按钮的标题
    ///
    /// - Parameters:
    ///   - comboBoxView: comboBoxView
    ///   - column: 列数
    /// - Returns: 按钮标题
    func titleOfColumn(_ comboBoxView: GXComboBoxView, numberOfColumn column: Int) -> String
}

// MARK: GXComboBoxViewDelegate
protocol GXComboBoxViewDelegate {
    
    /// cell height
    ///
    /// - Parameters:
    ///   - comboBoxView: comboBoxView
    ///   - indexPath: indexPath
    /// - Returns: cell height
    func comboBoxView(_ comboBoxView: GXComboBoxView, heightForRowAt indexPath: GXIndexPath) -> CGFloat
    
    /// cell click
    ///
    /// - Parameters:
    ///   - comboBoxView: comboBoxView
    ///   - indexPath: indexPath
    func comboBoxView(_ comboBoxView: GXComboBoxView, didSelectedRowAt indexPath: GXIndexPath)
}

class GXComboBoxView: UIView {
    
    var dataSoure: GXComboBoxViewDataSoure? {
        didSet {
            setUpUI()
        }
    }
    
    var delegate: GXComboBoxViewDelegate? {
        didSet {
            setUpUI()
        }
    }
    
    fileprivate func maxY() -> CGFloat {
        
        return UIScreen.main.bounds.size.height - frame.maxY
    }
    
    var stytle: GXComboBoxViewType = GXComboBoxViewType()
    
    fileprivate var currentBtn: GXComboBoxBtn?
    
    fileprivate var btns: [GXComboBoxBtn] = [GXComboBoxBtn]()
    
    fileprivate var tableViews: [UITableView] = [UITableView]()
    
    fileprivate var popView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    fileprivate lazy var btnsStackView: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        
        return stackView
    }()
    
    fileprivate lazy var tableViewStackView: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        stackView.spacing = 0
        
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initUI()
    }
    
    func reloadData() {
        setUpTableViews()
        setUpTitles()
    }
    
    @objc func closeSelecting() {
        hidenPopView(isAnimal: true)
        hidenTableViews(isAnimal: true)
        
        _ = btns.map({ $0.isSelected = false })
    }
}

// MARK: UI
extension GXComboBoxView {
    
    fileprivate func initUI() {
        
        addSubview(btnsStackView)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func setUpTitles() {
        
        for btn in btns {
            
            let title = self.dataSoure?.titleOfColumn(self, numberOfColumn: btn.tag)
            
            btn.setTitle(title, for: .normal)
        }
    }
    
    fileprivate func setUpUI() {
        
        for btn in btns {
            btnsStackView.removeArrangedSubview(btn)
        }
        btns.removeAll()
        
        let count = self.dataSoure?.numberOfColumn(in: self) ?? 0
        
        for i in 0..<count {
            
            let btn = GXComboBoxBtn()
            
            let title = self.dataSoure?.titleOfColumn(self, numberOfColumn: i)
            
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(stytle.normalTitleColor, for: .normal)
            btn.setTitleColor(stytle.selectedTitleColor, for: .selected)
            
            btn.setImage(UIImage.init(named: "GXComboBox.bundle/btn_default_img"), for: .normal)
            btn.setImage(UIImage.init(named: "GXComboBox.bundle/btn_selected_img"), for: .selected)
            
            btn.tag = i
            btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            
            btnsStackView.addArrangedSubview(btn)
            btns.append(btn)
        }
    }
    
    @objc fileprivate func btnClick(_ thisBtn: GXComboBoxBtn) {
        
        if thisBtn.isSelected {
            thisBtn.isSelected = false
        } else {
            for btn in btns  {
                btn.isSelected = btn.tag == thisBtn.tag
            }
        }
        
        currentBtn = thisBtn
        
        setUpPopView()
        setUpTableViews()
    }
    
    fileprivate func setUpTableViews() {
        
        if let btn = btns.filter({ $0.isSelected }).first {
            // 有选中
            showTableViews(isAnimal: true)
            
            let col = dataSoure?.comboBoxView(self, numberOfSectionInColumn: btn.tag) ?? 0
            
            if col < tableViews.count {
                for _ in 0..<(tableViews.count - col) {
                    tableViews.last!.removeFromSuperview()
//                    tableViewStackView.removeArrangedSubview(tableViews.last!)
                    tableViews.removeLast()
                }
            } else if col > tableViews.count {
                
                for i in tableViews.count..<col {
                    let tableView = UITableView()
                    tableView.tag = i
                    
                    dataSoure?.comboBoxView(self, numberOfSectionInColumn: btn.tag, section: i, regiseCell: tableView)
                    
                    tableView.dataSource = self
                    tableView.delegate = self
                    
                    tableView.translatesAutoresizingMaskIntoConstraints = false
                    tableView.frame.origin.x = (frame.size.width / CGFloat(col)) * CGFloat(i)
                    tableView.frame.size.width = frame.size.width / CGFloat(col)
                    let heightConstraint = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
                    
                    tableView.addConstraint(heightConstraint)
                    
                    tableViewStackView.addArrangedSubview(tableView)
                    tableViews.append(tableView)
                }
            }
            
            for (index, tableView) in tableViews.enumerated() {
                tableView.reloadData()
                
                let row = self.delegate?.comboBoxView(self, heightForRowAt: GXIndexPath(row: 0, section: index, column: btn.tag)) ?? 0
                let cellHeight = CGFloat(self.dataSoure?.comboBoxView(self, numberOfRowsInColum: btn.tag, section: index) ?? 0)
                let height = row * cellHeight
                let maxHeight = maxY()
                
                tableView.constraints.first?.constant = height > maxHeight ? maxHeight : height
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.tableViewStackView.layoutIfNeeded()
            })
            
        } else {
            // 没有选中
            hidenTableViews(isAnimal: true)
        }
    }
    
    fileprivate func showTableViews(isAnimal: Bool) {
        
        guard tableViewStackView.superview != nil else {
            
            tableViewStackView.frame = CGRect.init(x: 0, y: self.frame.maxY, width: self.frame.size.width, height: 0)
            superview?.addSubview(tableViewStackView)
            
            UIView.animate(withDuration: isAnimal ? 0.25 : 0, animations: { 
                self.tableViewStackView.frame = CGRect.init(x: 0, y: self.frame.maxY, width: self.frame.size.width, height: self.maxY())
            }, completion: nil)
            
            return
        }
    }
    
    fileprivate func hidenTableViews(isAnimal: Bool) {
        
        _ = self.tableViews.map({ $0.constraints.first?.constant = 0 })
        
        UIView.animate(withDuration: isAnimal ? 0.25 : 0, animations: {
            self.tableViewStackView.layoutIfNeeded()
            self.tableViewStackView.frame = CGRect.init(x: 0, y: self.frame.maxY, width: self.frame.size.width, height: 0)
        }) { (_) in
            self.tableViewStackView.removeFromSuperview()
            self.removeAllTableViews()
        }
    }
    
    fileprivate func removeAllTableViews() {
        
        for tableView in tableViews {
            tableView.removeFromSuperview()
        }
        
        tableViews.removeAll()
    }
    
    fileprivate func setUpPopView() {
        
        if btns.filter({ $0.isSelected }).first != nil {
            // 有选中
            if popView.superview == nil {
                showPopView(isAnimal: true)
            }
            
        } else {
            // 没有选中
            hidenPopView(isAnimal: true)
        }
    }
    
    fileprivate func showPopView(isAnimal: Bool) {
        
        popView.backgroundColor = UIColor.clear
        
        superview?.addSubview(popView)
        
        UIView.animate(withDuration: isAnimal ? 0.25 : 0, animations: {
            self.popView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }) { (_) in
            
        }
    }
    
    fileprivate func hidenPopView(isAnimal: Bool) {
        
        UIView.animate(withDuration: isAnimal ? 0.25 : 0, animations: {
            self.popView.backgroundColor = UIColor.clear
        }) { (_) in
            self.popView.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        btnsStackView.frame = bounds

        popView.frame = CGRect.init(x: 0, y: frame.maxY, width: frame.size.width, height: maxY())
    }
}

extension GXComboBoxView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSoure?.comboBoxView(self, numberOfRowsInColum: currentBtn?.tag ?? 0, section: tableView.tag) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let indexPath = GXIndexPath(row: indexPath.row, section: tableView.tag, column: currentBtn?.tag ?? 0)
        
        let cell = self.dataSoure?.comboBoxView(self, cellForRowAt: indexPath)
        
        return cell ?? UITableViewCell()
    }
}

extension GXComboBoxView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let col = dataSoure?.comboBoxView(self, numberOfSectionInColumn: tableView.tag) ?? 0
        
        return self.delegate?.comboBoxView(self, heightForRowAt: GXIndexPath(row: indexPath.row, section: tableView.tag, column: col)) ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let btn = btns.filter({ $0.isSelected }).first {
            
            self.delegate?.comboBoxView(self, didSelectedRowAt: GXIndexPath(row: indexPath.row, section: tableView.tag, column: btn.tag))
        }
        
    }
}

