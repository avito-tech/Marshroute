import UIKit

final class ShelfView: UIView {
    // MARK: - Private properties
    private let shelfImage = UIImage(named: "Shelf.png")
    private var shelfImageViews = [UIImageView]()
    
    // MARK: - Internal properties
    var defaultContentInsets: UIEdgeInsets = .zero
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override var frame: CGRect {
        didSet {
            guard let shelfImage, shelfImage.size.width > 0 else { return }
            
            guard frame != oldValue else { return }
            
            let shelfHeight = shelfHeightForWidth(frame.size.width)
            
            let shelvesNeededToTileAllView = Int(ceil(frame.size.height / shelfHeight))
            
            while shelfImageViews.count > shelvesNeededToTileAllView {
                let imageView = shelfImageViews.removeLast()
                imageView.removeFromSuperview()
            }
            
            while shelfImageViews.count < shelvesNeededToTileAllView {
                let shelfImageView = UIImageView(image: shelfImage)
                
                shelfImageView.contentMode = .scaleAspectFill
                
                shelfImageViews.append(shelfImageView)
                
                addSubview(shelfImageView)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shelfHeight = shelfHeightForWidth (bounds.width)
        
        guard shelfHeight > 0 else { return }
        
        guard let shelfImage, shelfImage.size.width > 0 else { return }
        
        var y = defaultContentInsets.top
        
        for shelfImageView in shelfImageViews {
            shelfImageView.frame = CGRect(x: bounds.origin.x, y: y, width: bounds.width, height: shelfHeight)
            y += shelfHeight
        }
    }
    
    // MARK: - Private
    private func shelfHeightForWidth(_ width: CGFloat) -> CGFloat {
        guard let shelfImage, width > 0 else { return 0 }
        
        let ratio = shelfImage.size.width / width
        
        guard ratio != 0 else { return 0 }
        
        let shelfHeight = shelfImage.size.height / ratio
        
        return shelfHeight
    }
}
