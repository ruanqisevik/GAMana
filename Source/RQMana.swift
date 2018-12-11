//
//  RQMana.swift
//  RQMana
//
//  Created by Q.Roy on 17/12/3.
//
//  Copyright (c) 2017 Q.Roy <ruanqisevik@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

extension DispatchQueue {
    // MARK: - DispatchQueue Extension; (singleton)
    
    private static var onceTracker = [String]()
    
    open class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}



extension String {
    // MARK: - String Extension; (feature: md5 string)
    
    //note: please #import <CommonCrypto/CommonCrypto.h>
    
    //    var md5: String {
    //        let str = self.cString(using: String.Encoding.utf8)
    //        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
    //        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    //        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
    //
    //        CC_MD5(str!, strLen, result)
    //
    //        let hash = NSMutableString()
    //        for i in 0 ..< digestLen {
    //            hash.appendFormat("%02x", result[i])
    //        }
    //        result.deinitialize()
    //
    //        return String(format: hash as String)
    //    }
}

extension CGFloat {
    // MARK: - CGFloat Extension; (feature: get random value)
    static func random(_ lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
    
    // MARK: - CGFloat Extension; (feature: get screen width and height)
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
}

extension CGPoint {
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
}

extension CGSize {
    // MARK: - CGSize Extension; (feature: get screen size)
    static func screenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    static func + (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    
    static func - (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width - right.width, height: left.height - right.height)
    }
}

extension CGRect {
    // MARK: - CGSize Extension; (feature: get screen size)
    static func screenRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

extension UIFont {
    // MARK: - UIFont Extension; (feature: get string size with width constraint)
    
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSFontAttributeName: self],
                                                     context: nil).size
    }
}

extension UIColor {
    // MARK: - UIColor Extension; (feature: candy for init UIColor)
    
    public convenience init(red255Value r: Int, green255Value g: Int, blue255Value b: Int, alpha a: CGFloat = 1) {
        
        self.init(red: CGFloat.init(r) / 255.0, green: CGFloat.init(g) / 255.0, blue: CGFloat.init(b) / 255.0, alpha: a)
    }
    
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    public convenience init(gray: CGFloat, alpha: CGFloat = 1) {
        self.init(red: gray/255, green: gray/255, blue: gray/255, alpha: alpha)
    }
    
    public var redComponent: Int {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return Int(r * 255)
    }
    
    public var greenComponent: Int {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return Int(g * 255)
    }
    
    public var blueComponent: Int {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return Int(b * 255)
    }
    
    public var alpha: CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
    
    public static func random(randomAlpha: Bool = false) -> UIColor {
        let randomRed = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue = CGFloat.random()
        let alpha = randomAlpha ? CGFloat.random() : 1.0
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
    }
}

extension UIView {
    // MARK: - UIView Extension; (feature: add border to view)
    
    enum BorderSide {
        case left(top: CGFloat, bottom: CGFloat)
        case right(top: CGFloat, bottom: CGFloat)
        case top(left: CGFloat, right: CGFloat)
        case bottom(left: CGFloat, right: CGFloat)
    }
    
    func setBorder(border: UIView.BorderSide, weight: CGFloat, color: UIColor ) {
        
        let lineView = UIView()
        self.addSubview(lineView)
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        
        if #available(iOS 9.0, *) {
            switch border {
                
            case .left(let top, let bottom):
                lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                lineView.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
                lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom).isActive = true
                lineView.widthAnchor.constraint(equalToConstant: weight).isActive = true
                
            case .right(let top, let bottom):
                lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
                lineView.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
                lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom).isActive = true
                lineView.widthAnchor.constraint(equalToConstant: weight).isActive = true
                
            case .top(let left, let right):
                lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
                lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: left).isActive = true
                lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: right).isActive = true
                lineView.heightAnchor.constraint(equalToConstant: weight).isActive = true
                
            case .bottom(let left, let right):
                lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: left).isActive = true
                lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: right).isActive = true
                lineView.heightAnchor.constraint(equalToConstant: weight).isActive = true
            }
        } else {
            // Fallback on earlier versions
            switch border {
                
            case .left(let top, let bottom):
                lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                lineView.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
                lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom).isActive = true
                lineView.widthAnchor.constraint(equalToConstant: weight).isActive = true
                
            case .right(let top, let bottom):
                lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
                lineView.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
                lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom).isActive = true
                lineView.widthAnchor.constraint(equalToConstant: weight).isActive = true
                
            case .top(let left, let right):
                lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
                lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: left).isActive = true
                lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: right).isActive = true
                lineView.heightAnchor.constraint(equalToConstant: weight).isActive = true
                
            case .bottom(let left, let right):
                lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: left).isActive = true
                lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: right).isActive = true
                lineView.heightAnchor.constraint(equalToConstant: weight).isActive = true
            }
        }
    }
}


private var dynamicCopyableKey: UInt8 = 0

extension UILabel {
    // MARK: - UILabel Extension; (feature: add long press copyable function)
    
    func associatedObject<ValueType>(
        base: AnyObject,
        key: UnsafePointer<UInt8>,
        initialiser: () -> ValueType)
        -> ValueType {
            if let associated = objc_getAssociatedObject(base, key)
                as? ValueType { return associated }
            let associated = initialiser()
            objc_setAssociatedObject(base, key, associated,
                                     .OBJC_ASSOCIATION_RETAIN)
            return associated
    }
    
    func associateObject<ValueType>(
        base: AnyObject,
        key: UnsafePointer<UInt8>,
        value: ValueType) {
        objc_setAssociatedObject(base, key, value,
                                 .OBJC_ASSOCIATION_RETAIN)
    }
    
    var isCopyable: Bool {
        get {
            return self.associatedObject(base: self, key: &dynamicCopyableKey, initialiser: { () -> Bool in
                return false
            })
        }
        set {
            self.associateObject(base: self, key: &dynamicCopyableKey, value: newValue)
            if newValue {
                self.attachLongPressHandler()
            }
        }
    }
    
    override open var canBecomeFirstResponder: Bool {
        get {
            return self.isCopyable
        }
        set {
            
        }
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            return true
        }else{
            return false
        }
    }
    
    open override func copy(_ sender: Any?) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = self.text
    }
    
    private func attachLongPressHandler() {
        self.isUserInteractionEnabled = true
        
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction))
        longPressGesture.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func longPressAction() {
        self.becomeFirstResponder()
        
        let copyItem = UIMenuItem(title: "复制", action: #selector(copy(_:)))
        let menu = UIMenuController.shared
        menu.menuItems = [copyItem]
        if menu.isMenuVisible {
            return
        }
        menu.setTargetRect(self.bounds, in: self)
        menu.setMenuVisible(true, animated: true)
    }
    
}

extension UIButton {
    // MARK: - UIButton Extension; (feature: candy for configure button image)
    
    func setItemsWithPosition(image: UIImage?,
                              renderingMode: UIImageRenderingMode = .alwaysOriginal,
                              title: String? = "",
                              titleColor: UIColor = UIColor.black,
                              titlePosition: UIViewContentMode,
                              additionalSpacing: CGFloat) {
        
        self.setImage(image?.withRenderingMode(renderingMode), for: .normal)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.imageView?.contentMode = .center
        self.titleLabel?.contentMode = .center
        
        positionLabelRespectToImage(title: title!, position: titlePosition, spacing: additionalSpacing)
    }
    
    func setHighlightItems(highlightImage: UIImage?, highlightTitle: String?, highlightTitleColor: UIColor?, highlightBackgroundColor: UIColor = UIColor.white) {
        
        self.setImage(highlightImage, for: .highlighted)
        self.setTitle(highlightTitle, for: .highlighted)
        self.setTitleColor(highlightTitleColor, for: .highlighted)
        self.setBackgroundImage(UIImage.init(color: highlightBackgroundColor), for: .highlighted)
        self.adjustsImageWhenHighlighted = false
        self.imageView?.contentMode = .center
        self.titleLabel?.contentMode = .center
    }
    
    private func positionLabelRespectToImage(title: String, position: UIViewContentMode, spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(attributes: [NSFontAttributeName: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    enum RQButtonTitlePositionType {
        case right
        case bottom(spacing: CGFloat)
        case left
        case top(spacing: CGFloat)
    }
    
    func setButton(titlePositionType: RQButtonTitlePositionType) {
        self.layoutIfNeeded()
        guard let titleLabel = self.titleLabel, let imageView = self.imageView else {
            return
        }
        
        let titleFrame = titleLabel.frame
        let imageFrame = imageView.frame
        
        let space = titleFrame.origin.x - imageFrame.origin.x - imageFrame.size.width
        switch titlePositionType {
        case .top(spacing: let spacing):
            self.imageEdgeInsets = UIEdgeInsetsMake(titleFrame.size.height + space + spacing, 0, 0, -(titleFrame.size.width))
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageFrame.size.width), imageFrame.size.height + space + spacing, 0)
        case .left:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleFrame.size.width + space, 0, -(titleFrame.size.width + space))
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(titleFrame.origin.x - imageFrame.origin.x), 0, titleFrame.origin.x - imageFrame.origin.x)
        case .bottom(spacing: let spacing):
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, titleFrame.size.height + space + spacing, -(titleFrame.size.width))
            self.titleEdgeInsets = UIEdgeInsetsMake(imageFrame.size.height + space + spacing, -(imageFrame.size.width), 0, 0)
        default:
            break
        }
    }
}

extension UIImage {
    
    // MARK: - UIImage Extension; (feature: candy for init UIImage)
    convenience init(color: UIColor, size: CGSize? = nil) {
        let size = size == nil || __CGSizeEqualToSize(size!, CGSize.zero) ? CGSize.init(width: 1, height: 1) : size!
        let rect = CGRect.init(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
    
    convenience init?(gradientColors:[UIColor], size:CGSize = CGSize(width: 10, height: 10), locations: [Float] = [] )
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map {(color: UIColor) -> AnyObject! in return color.cgColor as AnyObject! } as NSArray
        let gradient: CGGradient
        if locations.count > 0 {
            let cgLocations = locations.map { CGFloat($0) }
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: cgLocations)!
        } else {
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
        }
        context!.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions(rawValue: 0))
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }
    
    // MARK: - UIImage Extension; (feature: get image with corner radius)
    func getImageWithCornerRadius(radius: CGFloat) -> UIImage {
        let w = Int(self.size.width)
        let h = Int(self.size.height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rect = CGRect.init(x: 0, y: 0, width: w, height: h)
        
        var image = self
        guard let context = CGContext.init(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 4 * w, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            return self
        }
        image.addRoundedRectToPath(path: context, rect: rect, ovalWidth: radius, ovalHeight: radius)
        context.closePath()
        context.clip()
        guard let cgImage = image.cgImage else {
            return self
        }
        context.draw(cgImage, in: CGRect.init(x: 0, y: 0, width: w, height: h))
        guard let imageMasked = context.makeImage() else {
            return self
        }
        image = UIImage.init(cgImage: imageMasked)
        return image
    }
    
    private func addRoundedRectToPath(path context: CGContext, rect: CGRect, ovalWidth: CGFloat, ovalHeight: CGFloat) {
        guard ovalHeight > 0, ovalWidth > 0 else {
            context.addRect(rect)
            return
        }
        context.saveGState()
        context.ctm.translatedBy(x: rect.minX, y: rect.minY)
        context.ctm.scaledBy(x: ovalWidth, y: ovalHeight)
        let fw = rect.width / ovalWidth
        let fh = rect.height / ovalHeight
        
        context.move(to: CGPoint.init(x: fw, y: fh/2))
        context.addArc(tangent1End: CGPoint.init(x: fw, y: fh), tangent2End: CGPoint.init(x: fw/2, y: fh), radius: 1)
        context.addArc(tangent1End: CGPoint.init(x: 0, y: fh), tangent2End: CGPoint.init(x: 0, y: fh/2), radius: 1)
        context.addArc(tangent1End: CGPoint.init(x: 0, y: 0), tangent2End: CGPoint.init(x: fw/2, y: 0), radius: 1)
        context.addArc(tangent1End: CGPoint.init(x: fw, y: 0), tangent2End: CGPoint.init(x: fw, y: fh), radius: 1)
        
        context.closePath()
        context.restoreGState()
    }
    
    func resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    class func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func gradientImage(colors: [UIColor], locations: [CGFloat], size: CGSize, horizontal: Bool = false) -> UIImage {
        let endPoint = horizontal ? CGPoint(x: 1.0, y: 0.0) : CGPoint(x: 0.0, y: 1.0)
        return gradientImage(colors: colors, locations: locations, startPoint: CGPoint.zero, endPoint: endPoint, size: size)
    }
    
    static func gradientImage(colors: [UIColor], locations: [CGFloat], startPoint: CGPoint, endPoint: CGPoint, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsPushContext(context!);
        
        let components = colors.reduce([]) { (currentResult: [CGFloat], currentColor: UIColor) -> [CGFloat] in
            var result = currentResult
            
            let numberOfComponents = currentColor.cgColor.numberOfComponents
            if let components = currentColor.cgColor.components {
                if numberOfComponents == 2 {
                    result.append(contentsOf: [components[0], components[0], components[0], components[1]])
                } else {
                    result.append(contentsOf: [components[0], components[1], components[2], components[3]])
                }
            }
            
            
            return result
        }
        
        let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: components, locations: locations, count: colors.count);
        
        let transformedStartPoint = CGPoint(x: startPoint.x * size.width, y: startPoint.y * size.height)
        let transformedEndPoint = CGPoint(x: endPoint.x * size.width, y: endPoint.y * size.height)
        context!.drawLinearGradient(gradient!, start: transformedStartPoint, end: transformedEndPoint, options: []);
        UIGraphicsPopContext();
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return gradientImage!
    }

}

extension UIImageView {
    
    //MARK: UIImageView Extension; (feature: set image with serveral type resources)
    
    /// set image with resource, resource type can be UIImage, Data, URL, String, if you want set image with third party framework, please edit in function
    ///
    /// - Parameters:
    ///   - resource: resource for imageView, type can be UIImage, Data, URL, String
    ///   - placeholder: place holder image
    ///   - completionHandler: completion handler
    public func setImage(withResource resource: Any, placeholder: UIImage?, completionHandler: ((UIImage?) -> Void)? = nil) {
        if resource is UIImage {
            self.image = resource as? UIImage
            completionHandler?(self.image)
            return
        }
        if resource is Data {
            let image = UIImage.init(data: resource as! Data)
            self.image = image
            completionHandler?(self.image)
            return
        }
        if resource is URL {
            self.download(from: resource as! URL, placeholder: placeholder, completionHandler: completionHandler)
        }
        if resource is String {
            let url = URL.init(string: resource as! String)
            if url == nil {
                self.image = placeholder
            }
            self.download(from: url!, placeholder: placeholder, completionHandler: completionHandler)
        }
    }
    
    public func download(from url: URL,
                         contentMode: UIViewContentMode = .scaleAspectFit,
                         placeholder: UIImage? = nil,
                         completionHandler: ((UIImage?) -> Void)? = nil) {
        
        image = placeholder
        self.contentMode = contentMode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                completionHandler?(image)
            }
            }.resume()
    }
    
    //MARK: UIImageView Extension; (feature: image view blur)
    public func blur(withStyle style: UIBlurEffectStyle = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }
    
    public func blurred(withStyle style: UIBlurEffectStyle = .light) -> UIImageView {
        let imgView = self
        imgView.blur(withStyle: style)
        return imgView
    }
    
    //MARK: UIImageView Extension; (feature: candy for size adjustment)
    func resizeTo(size: CGSize, opaque: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func scale(ratio: CGFloat, opaque: Bool = false) -> UIImage? {
        let newSize = CGSize.init(width: self.bounds.size.width * ratio, height: self.bounds.size.height * ratio)
        return self.resizeTo(size: newSize, opaque: opaque)
    }
}


private var dynamicNavigationBarOverlayKey: Void?
private var dynamicNavigationBarOriginBackgroundColorKey: Void?
private var dynamicNavigationBarOriginShadowImageKey: Void?

extension UINavigationBar {
    
    //MARK: UINavigationBar Extension; (feature: candy for setup navigationBar)
    var itemColor: UIColor! {
        get {
            return self.tintColor
        }
        set {
            self.tintColor = newValue
        }
    }
    
    var color: UIColor? {
        get {
            return self.barTintColor
        }
        set {
            self.barTintColor = newValue
        }
    }
    
    var titleColor: UIColor? {
        get {
            if let attributes = self.titleTextAttributes {
                if let foregroundColor = attributes[NSForegroundColorAttributeName] {
                    return foregroundColor as? UIColor
                }
                return nil
            }
            return nil
        }
        set {
            var newTextAttributes = self.titleTextAttributes ?? [:]
            newTextAttributes[NSForegroundColorAttributeName] = newValue
            self.titleTextAttributes = newTextAttributes
        }
    }
    
    var titleFont: UIFont? {
        get {
            if let attributes = self.titleTextAttributes {
                if let font = attributes[NSFontAttributeName] {
                    return font as? UIFont
                }
                return nil
            }
            return nil
        }
        set {
            var newTextAttributes = self.titleTextAttributes ?? [:]
            newTextAttributes[NSFontAttributeName] = newValue
            self.titleTextAttributes = newTextAttributes
        }
    }
    
    var isHideShadowImage: Bool {
        get {
            return !(self.originShadowImage == nil)
        }
        set {
            if newValue {
                self.originShadowImage = self.shadowImage
                self.shadowImage = UIImage()
            } else {
                self.shadowImage = self.originShadowImage
            }
        }
    }
    
    var originShadowImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &dynamicNavigationBarOriginShadowImageKey) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &dynamicNavigationBarOriginShadowImageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //MARK: UINavigationBar Extension; (feature: solution for gradual color change caused by scrollview's scroll interaction, this solution will only valid when UINavigationBar isTranslucent propery value is true)
    var overlay: UIView? {
        get {
            return objc_getAssociatedObject(self, &dynamicNavigationBarOverlayKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &dynamicNavigationBarOverlayKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var originBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &dynamicNavigationBarOriginBackgroundColorKey) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &dynamicNavigationBarOriginBackgroundColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var overlayColor: UIColor? {
        get {
            return self.overlay?.backgroundColor
        }
        set {
            if newValue != nil && self.overlay == nil {
                self.initOverlay()
            }
            self.overlay?.backgroundColor = newValue
        }
    }
    
    enum OverlayPositionType {
        case coverStatusBar
        case `default`
    }
    
    private var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

    var overlayPositionType: OverlayPositionType? {
        get {
            if self.overlay == nil {
                return nil
            } else {
                return self.overlay!.frame.origin == CGPoint.zero ? OverlayPositionType.coverStatusBar : OverlayPositionType.default
            }
        }
        set {
            guard let position = newValue else {
                return
            }
            switch position {
            case OverlayPositionType.coverStatusBar:
                guard self.overlay != nil else {
                    return
                }
                let newFrame = CGRect.init(origin: CGPoint.zero, size: CGSize(width: self.bounds.width, height: self.bounds.height + statusBarHeight))
                self.overlay?.frame = newFrame
            default:
                guard self.overlay != nil else {
                    return
                }
                let newFrame = CGRect.init(origin: CGPoint.init(x: 0, y: statusBarHeight), size: CGSize(width: self.bounds.width, height: self.bounds.height))
                self.overlay?.frame = newFrame
            }
        }
    }
    
    private func initOverlay() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.originBackgroundColor = self.backgroundColor
        self.backgroundColor = UIColor.clear
        self.overlay = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.bounds.width, height: self.bounds.height + statusBarHeight)))
        self.overlay?.isUserInteractionEnabled = false
        self.overlay?.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.subviews.first?.insertSubview(self.overlay!, at: 0)
    }
    
    func removeOverlay() {
        self.backgroundColor = self.originBackgroundColor
        self.setBackgroundImage(nil, for: .default)
        self.overlay?.removeFromSuperview()
        self.overlay = nil
    }
    
    func removeOverlayWithOutBackgroundImage() {
        self.backgroundColor = self.originBackgroundColor
        self.overlay?.removeFromSuperview()
        self.overlay = nil
    }
}


extension UITabBarItem {
    
    //MARK: UITabBarItem Extension; (feature: candy for setup tabBarItem)
    func setTitle(_ font: UIFont, _ color: UIColor, for state: UIControlState) {
        var newTextAttributes = self.titleTextAttributes(for: state) ?? [:]
        newTextAttributes[NSFontAttributeName] = font
        newTextAttributes[NSForegroundColorAttributeName] = color
        self.setTitleTextAttributes(newTextAttributes, for: state)
    }
}

extension RQVersionMana {
    class var isEverLaunched: Bool {
        get {
            return !(RQVersionMana.shared.state==RQVersionMana.State.installed)
        }
    }
    
    class var isFirstLaunchThisVersion: Bool {
        get {
            return !(RQVersionMana.shared.state==RQVersionMana.State.notChanged)
        }
    }
}

extension RQApplicationMana {
    class var AppDisplayName: String {
        get {
            return Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
        }
    }
    
    class var AppBundleIdentifier: String {
        get {
            return Bundle.main.bundleIdentifier!
        }
    }
    
    class var deviceUUID: UUID? {
        get {
            return UIDevice.current.identifierForVendor
        }
    }
    
    class var systemName: String {
        get {
            return UIDevice.current.systemName
        }
    }
    
    class var model: String {
        get {
            return UIDevice.current.model
        }
    }
    
    class var localizedModel: String {
        get {
            return UIDevice.current.localizedModel
        }
    }
}

