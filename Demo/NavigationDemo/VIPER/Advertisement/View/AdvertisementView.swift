import UIKit

private let ReuseId = "AdvertisementViewCell"
private let tableHeaderHeight: CGFloat = 44

final class AdvertisementView: UIView, UITableViewDelegate, UITableViewDataSource {
    private let gradientView = GradientView()
    private let patternView = UIView()
    private let tableView = UITableView()
    private var recommendedSearchResults = [SearchResultsViewData]()
    private let placeholderImageView = UIImageView()
    private var uiInsets = UIEdgeInsetsZero
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .whiteColor()
        
        addSubview(gradientView)
        
        addSubview(patternView)
        patternView.hidden = true
        
        addSubview(placeholderImageView)
        placeholderImageView.contentMode = .ScaleAspectFill
        placeholderImageView.layer.masksToBounds = true
        
        addSubview(tableView)
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    func setPatternAssetName(assetName: String?) {
        if let assetName = assetName, patternImage = UIImage(named: assetName) {
            patternView.backgroundColor = UIColor(patternImage: patternImage)
            patternView.hidden = false
        } else {
            patternView.hidden = true
        }
    }
    
    func setPlaceholderAssetName(assetName: String?) {
        if let assetName = assetName, placeholderImage = UIImage(named: assetName) {
            placeholderImageView.image = placeholderImage
            setNeedsLayout()
        }
    }
    
    func setBackgroundRGB(rgb: (red: Double, green: Double, blue: Double)?) {
        guard let color = colorFromRGB(rgb)
            else { return }
        
        gradientView.bottomColor = color
    }
    
    func setSimilarSearchResults(searchResults: [SearchResultsViewData]) {
        recommendedSearchResults = searchResults
        tableView.reloadData()
        setNeedsLayout()
    }
    
    func setUIInsets(insets: UIEdgeInsets) {
        uiInsets = insets
        
        tableView.contentInset.bottom = insets.bottom
        tableView.scrollIndicatorInsets.bottom = insets.bottom
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientView.frame = bounds
        patternView.frame = bounds
        
        let tableHeight =
            CGFloat(recommendedSearchResults.count) * tableView.rowHeight
            + CGFloat(tableView.numberOfSections) * tableHeaderHeight
        
        let tableTop = bounds.height - tableHeight
        
        let tableFrame = CGRect(x: 0, y: tableTop, width: bounds.width, height: tableHeight)
        tableView.frame = tableFrame
        
        placeholderImageView.frame = CGRect(x: 0, y: uiInsets.top, width: bounds.width, height: tableTop)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedSearchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(ReuseId)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: ReuseId)
            cell?.textLabel?.highlightedTextColor = .whiteColor()
        }
        
        let searchResult = recommendedSearchResults[indexPath.row]
        
        let color = colorFromRGB(searchResult.rgb)
        
        cell?.textLabel?.text = searchResult.title
        cell?.contentView.backgroundColor = color
        
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Рекомендуемые объявления"
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        recommendedSearchResults[indexPath.row].onTap()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderHeight
    }
    
    // MARK: - Private
    private func colorFromRGB(rgb: (red: Double, green: Double, blue: Double)?) -> UIColor? {
        guard let rgb = rgb
            else { return nil }
        
        let color = UIColor(
            red: CGFloat(rgb.red),
            green: CGFloat(rgb.green),
            blue: CGFloat(rgb.blue),
            alpha: 0.3
        )
        
        return color
    }
}

private class GradientView: UIView {
    var bottomColor: UIColor = .whiteColor() {
        didSet {
            if let gradientLayer = layer as? CAGradientLayer {
                gradientLayer.colors = [
                    UIColor.whiteColor().CGColor,
                    bottomColor.colorWithAlphaComponent(0.8).CGColor,
                ]
                
                gradientLayer.locations = [0, 1]
            }
        }
    }
    
    // MARK: - Layer
    override static func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
}