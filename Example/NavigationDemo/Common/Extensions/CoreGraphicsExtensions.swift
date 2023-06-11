import Foundation

extension CGSize {
    func intersectionWidth(_ width: CGFloat) -> CGSize {
        return CGSize(
            width: min(self.width, width),
            height: height
        )
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}

extension CGRect {
    func byChangingBottomAndHeight(_ height: CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: height)
    }
    
    func byChangingTop(_ top: CGFloat) -> CGRect {
        return CGRect(left: left, right: right, top: top, bottom: bottom)
    }
    
    init(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        self.init(x: left, y: top, width: right - left, height: bottom - top)
    }
    
    var x: CGFloat {
        get { return origin.x }
        set { origin.x = newValue }
    }
    
    var y: CGFloat {
        get { return origin.y }
        set { origin.y = newValue }
    }
    
    var left: CGFloat {
        get { return x }
        set { x = newValue }
    }
    
    var right: CGFloat {
        get { return left + width }
        set { left = newValue - width }
    }
    
    var top: CGFloat {
        get { return y }
        set { y = newValue }
    }
    
    var bottom: CGFloat {
        get { return top + height }
        set { top = newValue - height }
    }
}
