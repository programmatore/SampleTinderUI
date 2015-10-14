//
//  ViewController.swift
//  SampleTinderUI
//
//  Created by nagisa-kosuge on 2015/10/14.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private let imageNames: [String] = ["hoge1", "hoge2", "hoge3", "hoge4", "hoge5", "hoge6", "hoge7", "hoge8", "hoge9", "hoge10"]
    
    private var frontCardView: ContentsView?
    private var backCardView: ContentsView?
    private var currentIndex: Int = 0
    
    @IBInspectable var horizontalMargin: CGFloat = 16.0
    @IBInspectable var topMargin: CGFloat = 32.0
    @IBInspectable var backViewBottomValue: CGFloat = 10.0
    @IBInspectable var ratio: CGFloat = 1.25

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

extension ViewController {
    
    @IBAction func tapRight(sender: AnyObject) {
        frontCardView?.mdc_swipe(MDCSwipeDirection.Right)
    }
    
    @IBAction func tapLeft(sender: AnyObject) {
        frontCardView?.mdc_swipe(MDCSwipeDirection.Left)
    }
}

extension ViewController {
    
    private func frontCardViewFrame() -> CGRect {
        let viewWidth = view.frame.width
        let width = viewWidth - (horizontalMargin * 2)
        let height = viewWidth * ratio
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        return CGRect(x: horizontalMargin, y: statusBarHeight + topMargin, width: width, height: height)
    }
    
    private func backCardViewFrame() -> CGRect {
        let frame = frontCardViewFrame()
        return CGRect(origin: CGPoint(x: frame.origin.x, y: frame.origin.y + backViewBottomValue), size: frame.size)
    }
    
    private func popCardViewWithFrame(frame: CGRect, index: Int) -> ContentsView? {
        
        let options: MDCSwipeToChooseViewOptions = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.onPan = {[weak self] state -> Void in
            if let weakSelf = self, let backView = self?.backCardView {
                let frame = weakSelf.frontCardViewFrame()
                let y = frame.origin.y - (state.thresholdRatio * weakSelf.backViewBottomValue)
                backView.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
            }
        }
        
        let imageName = imageNames[index]
        let view = ContentsView(frame: frame, options: options)
        view.imageName = imageName
        
        return view
    }
    
    private func setupView() {
        
        if let frontCardView = popCardViewWithFrame(frontCardViewFrame(), index: currentIndex) {
            view.addSubview(frontCardView)
            setFrontView(frontCardView, index: currentIndex)
        }
        
        if let backCardView = popCardViewWithFrame(backCardViewFrame(), index: nextIndex()), let frontView = frontCardView {
            self.backCardView = backCardView
            view.insertSubview(backCardView, belowSubview: frontView)
        }
    }
    
    private func nextIndex() -> Int {
        let i = currentIndex + 1
        if i >= imageNames.count {
            return 0
        }
        return i
    }
    
    private func setFrontView(view: ContentsView, index: Int) {
        self.frontCardView = view
        self.currentIndex = index
        
        let transitionAnim = CATransition()
        transitionAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transitionAnim.type = kCATransitionFade
        transitionAnim.duration = 0.5
        self.backgroundImageView.layer.addAnimation(transitionAnim, forKey: "transition")
        self.backgroundImageView.image = view.mainImageView.image
    }
}

extension ViewController: MDCSwipeToChooseDelegate {
    
    func view(view: UIView!, wasChosenWithDirection direction: MDCSwipeDirection) {
        
        if let backView = backCardView {
            setFrontView(backView, index: nextIndex())
            self.backCardView = popCardViewWithFrame(backCardViewFrame(), index: nextIndex())
        }
        
        if let backView = backCardView, frontView = frontCardView {
            backView.alpha = 0
            self.view.insertSubview(backView, belowSubview: frontView)
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {[weak self] () -> Void in
                self?.backCardView?.alpha = 1
            }, completion: nil)
        }
    }
}
