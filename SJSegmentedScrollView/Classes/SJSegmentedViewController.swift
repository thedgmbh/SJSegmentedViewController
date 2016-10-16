//
//  SJSegmentedViewController.swift
//  Pods
//
//  Created by Subins Jose on 20/06/16.
//  Copyright © 2016 Subins Jose. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//    associated documentation files (the "Software"), to deal in the Software without restriction,
//    including without limitation the rights to use, copy, modify, merge, publish, distribute,
//    sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//    substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

@objc public protocol SJSegmentedViewControllerDelegate {
    
    @objc optional func didSelectSegmentAtIndex(_ index:Int)
    
    /**
     Method to identify the current controller and segment of contentview
     
     - parameter controller: Current controller
     - parameter segment: selected segment
     - parameter index: index of selected segment.
     */
    @objc optional func didMoveToPage(_ controller: UIViewController, segment: UIButton?, index: Int)
}

/**
 *  Public protocol of  SJSegmentedViewController for content changes and makes the scroll effect.
 */
@objc public protocol SJSegmentedViewControllerViewSource {
    
    /**
     By default, SJSegmentedScrollView will observe the default view of viewcontroller for content
     changes and makes the scroll effect. If you want to change the default view, implement
     SJSegmentedViewControllerViewSource and pass your custom view.
     
     - parameter controller: UIViewController for segment
     - parameter index:      index of segment controller
     
     - returns: observe view
     */
    @objc optional func viewForSegmentControllerToObserveContentOffsetChange(_ controller: UIViewController,
                                                                       index: Int) -> UIView
}

/**
 *  Public protocol of  SJSegmentedViewController for button image in normal or selected state.
 */
@objc public protocol SJSegmentedViewControllerViewDataSource: class {
    
    /**
     By default, SJSegmentedScrollView Have text to display, this will add image to the buttons
     instead of or + the text, IF you want to add it, implement the delegate and pass your image
     for both states.
     
     - parameter state: UIControlState for Button
     
     - returns: Image for UIButton
     */
    @objc optional func imageForViewController(state: UIControlState) -> UIImage?
}

/**
 *  Public class for customizing and setting our segmented scroll view
 */
@objc open class SJSegmentedViewController: UIViewController {
    
    /**
     *  The headerview height for 'Header'.
     *
     *  By default the height will be 0.0
     *
     *  segmentedViewController.headerViewHeight = 200.0
     */
    open var headerViewHeight: CGFloat = 0.0 {
        didSet {
            segmentedScrollView.headerViewHeight = headerViewHeight
        }
    }
    
    /**
     *  Set height for segment view.
     *
     *  By default the height is 40.0
     *
     *  segmentedViewController.segmentViewHeight = 60.0
     */
    open var segmentViewHeight: CGFloat = 40.0 {
        didSet {
            segmentedScrollView.segmentViewHeight = segmentViewHeight
        }
    }
    
    /**
     *  Set headerview offset height.
     *
     *  By default the height is 0.0
     *
     *  segmentedViewController. headerViewOffsetHeight = 10.0
     */
    open var headerViewOffsetHeight: CGFloat = 0.0 {
        didSet {
            segmentedScrollView.headerViewOffsetHeight = headerViewOffsetHeight
        }
    }
    
    /**
     *  Set color for selected segment.
     *
     *  By default the color is light gray.
     *
     *  segmentedViewController.selectedSegmentViewColor = UIColor.redColor()
     */
    open var selectedSegmentViewColor = UIColor.lightGray {
        didSet {
            segmentedScrollView.selectedSegmentViewColor = selectedSegmentViewColor
        }
    }
    
    /**
     *  Set height for selected segment view.
     *
     *  By default the height is 5.0
     *
     *  segmentedViewController.selectedSegmentViewHeight = 5.0
     */
    open var selectedSegmentViewHeight: CGFloat = 5.0 {
        didSet {
            segmentedScrollView.selectedSegmentViewHeight = selectedSegmentViewHeight
        }
    }
    
    /**
     *  Set color for segment title.
     *
     *  By default the color is black.
     *
     *  segmentedViewController.segmentTitleColor = UIColor.redColor()
     */
    open var segmentTitleColor = UIColor.black {
        didSet {
            segmentedScrollView.segmentTitleColor = segmentTitleColor
        }
    }
    
    /**
     *  Set color for segment background.
     *
     *  By default the color is white.
     *
     *  segmentedViewController.segmentBackgroundColor = UIColor.whiteColor()
     */
    open var segmentBackgroundColor = UIColor.white {
        didSet {
            segmentedScrollView.segmentBackgroundColor = segmentBackgroundColor
        }
    }
    
    /**
     *  Set shadow for segment.
     *
     *  By default the color is light gray.
     *
     *  segmentedViewController.segmentShadow = SJShadow.light()
     */
    open var segmentShadow = SJShadow() {
        didSet {
            segmentedScrollView.segmentShadow = segmentShadow
        }
    }
    
    /**
     *  Set font for segment title.
     *
     *  segmentedViewController.segmentTitleFont = UIFont.systemFontOfSize(14.0)
     */
    open var segmentTitleFont = UIFont.systemFont(ofSize: 14.0) {
        didSet {
            segmentedScrollView.segmentTitleFont = segmentTitleFont
        }
    }
    
    /**
     *  Set bounce for segment.
     *
     *  By default it is set to false.
     *
     *  segmentedViewController.segmentBounces = true
     */
    open var segmentBounces = false {
        didSet {
            segmentedScrollView.segmentBounces = segmentBounces
        }
    }
    
    /**
     *  Set ViewController for header view.
     */
    open var headerViewController: UIViewController? {
        didSet {
            setDefaultValuesToSegmentedScrollView()
        }
    }
    
    /**
     *  Array of ViewControllers for segments.
     */
    open var segmentControllers = [UIViewController]() {
        didSet {
            setDefaultValuesToSegmentedScrollView()
        }
    }
    
    /**
     *  Array of segments. For single view controller segments will be empty.
     */
    open var segments: [UIButton] {
        get {
            
            if let segmentView = segmentedScrollView.segmentView {
                return segmentView.segments
            }
            
            return [UIButton]()
        }
    }
    
    open var delegate:SJSegmentedViewControllerDelegate?
    var viewObservers = [UIView]()
    var segmentedScrollView = SJSegmentedScrollView(frame: CGRect.zero)
    var segmentScrollViewTopConstraint: NSLayoutConstraint?
    
    
    /**
     Custom initializer for SJSegmentedViewController.
     
     - parameter headerViewController: A UIViewController
     - parameter segmentControllers:   Array of UIViewControllers for segments.
     
     */
    convenience public init(headerViewController: UIViewController?,
                            segmentControllers: [UIViewController]) {
        self.init(nibName: nil, bundle: nil)
        self.headerViewController = headerViewController
        self.segmentControllers = segmentControllers
        setDefaultValuesToSegmentedScrollView()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        for view in viewObservers {
            view.removeObserver(self,
                                forKeyPath: "contentOffset",
                                context: nil)
        }
    }
    
    override open func loadView() {
        super.loadView()
        addSegmentedScrollView()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        loadControllers()
    }
    
    /**
     * Update view as per the current layout
     */
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let topSpacing = SJUtil.getTopSpacing(self)
        segmentedScrollView.topSpacing = topSpacing
        segmentedScrollView.bottomSpacing = SJUtil.getBottomSpacing(self)
        segmentScrollViewTopConstraint?.constant = topSpacing
        segmentedScrollView.isScrollEnabled = false
        segmentedScrollView.updateSubviewsFrame(view.bounds)
    }
    
    /**
     * Set the default values for the segmented scroll view.
     */
    func setDefaultValuesToSegmentedScrollView() {
        
        segmentedScrollView.selectedSegmentViewColor    = selectedSegmentViewColor
        segmentedScrollView.selectedSegmentViewHeight   = selectedSegmentViewHeight
        segmentedScrollView.segmentTitleColor           = segmentTitleColor
        segmentedScrollView.segmentBackgroundColor      = segmentBackgroundColor
        segmentedScrollView.segmentShadow               = segmentShadow
        segmentedScrollView.segmentTitleFont            = segmentTitleFont
        segmentedScrollView.segmentBounces              = segmentBounces
        segmentedScrollView.headerViewHeight            = headerViewHeight
        segmentedScrollView.headerViewOffsetHeight      = headerViewOffsetHeight
        segmentedScrollView.segmentViewHeight           = segmentViewHeight
    }
    
    /**
     * Private method for adding the segmented scroll view.
     */
    func addSegmentedScrollView() {
        
        let topSpacing = SJUtil.getTopSpacing(self)
        segmentedScrollView.topSpacing = topSpacing
        
        let bottomSpacing = SJUtil.getBottomSpacing(self)
        segmentedScrollView.bottomSpacing = bottomSpacing
        
        view.addSubview(segmentedScrollView)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[scrollView]-0-|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["scrollView": segmentedScrollView])
        view.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[scrollView]-bp-|",
                                                                                 options: [],
                                                                                 metrics: ["tp": topSpacing,
                                                                                    "bp": bottomSpacing],
                                                                                 views: ["scrollView": segmentedScrollView])
        view.addConstraints(verticalConstraints)
        
        segmentScrollViewTopConstraint = NSLayoutConstraint(item: segmentedScrollView,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: view,
                                                            attribute: .top,
                                                            multiplier: 1.0,
                                                            constant: topSpacing)
        view.addConstraint(segmentScrollViewTopConstraint!)
        
        segmentedScrollView.setContentView()
        
        // selected segment at index
        segmentedScrollView.didSelectSegmentAtIndex = {(segment,index) in
            let selectedController = self.segmentControllers[index]
            
            self.delegate?.didMoveToPage?(selectedController, segment: segment!, index: index)
            
        }
    }
    
    /**
     Method for adding the HeaderViewController into the container
     
     - parameter headerViewController: Header ViewController.
     */
    func addHeaderViewController(_ headerViewController: UIViewController) {
        
        addChildViewController(headerViewController)
        segmentedScrollView.addHeaderView(headerViewController.view)
        headerViewController.didMove(toParentViewController: self)
    }
    
    /**
     Method for adding the array of content ViewControllers into the container
     
     - parameter contentControllers: array of ViewControllers
     */
    func addContentControllers(_ contentControllers: [UIViewController]) {
        
        viewObservers.removeAll()
        segmentedScrollView.addSegmentView(contentControllers, frame: view.bounds)
        
        var index = 0
        for controller in contentControllers {
            
            addChildViewController(controller)
            segmentedScrollView.addContentView(controller.view, frame: view.bounds)
            controller.didMove(toParentViewController: self)
            
            let delegate = controller as? SJSegmentedViewControllerViewSource
            var observeView = controller.view
            
            if let view = delegate?.viewForSegmentControllerToObserveContentOffsetChange!(controller,
                                                                                          index: index) {
                observeView = view
            }
            
            viewObservers.append(observeView!)
            segmentedScrollView.addObserverFor(observeView!)
            index += 1
        }
        
        segmentedScrollView.segmentView?.contentView = segmentedScrollView.contentView
    }
    
    /**
     * Method for loading content ViewControllers and header ViewController
     */
    func loadControllers() {
        
        if headerViewController == nil  {
            headerViewController = UIViewController()
        }
        
        addHeaderViewController(headerViewController!)
        addContentControllers(segmentControllers)
        
        
        //Delegate call for setting the first view of segments.
        var segment: UIButton?
        if segments.count > 0 {
            segment = segments[0]
        }
        
        delegate?.didMoveToPage?(segmentControllers[0],
                                 segment: segment,
                                 index: 0)
    }
    
}
