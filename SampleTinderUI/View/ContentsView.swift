//
//  ContentsView.swift
//  SampleTinderUI
//
//  Created by nagisa-kosuge on 2015/10/14.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

class ContentsView: MDCSwipeToChooseView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    var imageName = "hoge2" {
        didSet {
            if let path = NSBundle.mainBundle().pathForResource(imageName, ofType: "jpeg") {
                mainImageView.image = UIImage(contentsOfFile: path)
            }
        }
    }
    
    var index: Int = 0
    
    override init!(frame: CGRect, options: MDCSwipeToChooseViewOptions!) {
        super.init(frame: frame, options: options)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ContentsView {
    
    private func setupView() {
        NSBundle.mainBundle().loadNibNamed("ContentsView", owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
}
