import UIKit

final class ShelfView: UIView {
    private let shelfImage = UIImage(named: "Shelf.png")
    private var shelfImageViews = [UIImageView]()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = .yellowColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        didSet {
            guard let shelfImage = shelfImage
                else { return }
            
            for shelfImageView in shelfImageViews {
                shelfImageView.removeFromSuperview()
            }
            
            shelfImageViews.removeAll()
            
            for _ in 0 ..< 15 {
                let shelfImageView = UIImageView(image: shelfImage)
                
                shelfImageView.contentMode = .ScaleAspectFill
                
                shelfImageViews.append(shelfImageView)
                
                addSubview(shelfImageView)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = 125.6 * bounds.width / 703
        var y = bounds.origin.y + height - 64
        
        for shelfImageView in shelfImageViews {
            shelfImageView.frame = CGRect(x: bounds.origin.x, y: y, width: bounds.width, height: height)
            
            y += height
        }
    }
}