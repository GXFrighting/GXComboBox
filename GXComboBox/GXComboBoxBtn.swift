//
//  GXComboBoxBtn.swift
//  GXComboBox
//
//  Created by Jiang on 2017/9/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit

class GXComboBoxBtn: UIButton {
    
    var space: CGFloat = 5

    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel else { return }
        guard let imageView = imageView else { return }
        let titleFrame = titleLabel.frame
        let imageFrame = imageView.frame
        
        titleLabel.frame.origin.x = (frame.size.width - (titleFrame.size.width + imageFrame.size.width + space)) * 0.5
        imageView.frame.origin.x = titleLabel.frame.origin.x + titleLabel.frame.size.width + space
    }
}
