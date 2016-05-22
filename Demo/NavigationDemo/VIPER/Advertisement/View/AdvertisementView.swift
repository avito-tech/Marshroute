import UIKit

private let ReuseId = "AdvertisementViewCell"
private let tableHeaderHeight: CGFloat = 44

final class AdvertisementView: UIView, UITableViewDelegate, UITableViewDataSource {
    private let background = GradientView()
    private let tableView = UITableView()
    private let descriptionTextView = UITextView()
    private var recommendedSearchResults = [SearchResultsViewData]()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .whiteColor()
        
        addSubview(background)
        
        addSubview(descriptionTextView)
        descriptionTextView.font = UIFont.systemFontOfSize(15)
        descriptionTextView.backgroundColor = .clearColor()
        descriptionTextView.editable = false
        
        addSubview(tableView)
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    func setDescription(description: String?) {
        descriptionTextView.text = description
    }
    
    func setBackgroundRGB(rgb: (red: Double, green: Double, blue: Double)?) {
        guard let color = colorFromRGB(rgb)
            else { return }
        
        background.bottomColor = color
    }
    
    func setSimilarSearchResults(searchResults: [SearchResultsViewData]) {
        recommendedSearchResults = searchResults
        tableView.reloadData()
        setNeedsLayout()
    }
    
    func setUIInsets(insets: UIEdgeInsets) {
        descriptionTextView.contentInset.top = insets.top
        descriptionTextView.scrollIndicatorInsets.top = insets.top
        descriptionTextView.contentOffset = CGPoint(x: 0, y: -descriptionTextView.contentInset.top)
        
        tableView.contentInset.bottom = insets.bottom
        tableView.scrollIndicatorInsets.bottom = insets.bottom
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        background.frame = bounds
        
        let tableHeight =
            CGFloat(recommendedSearchResults.count) * tableView.rowHeight
            + CGFloat(tableView.numberOfSections) * tableHeaderHeight
        
        let descriptionHeight = bounds.height - tableHeight
        
        let descriptionLabelFrame = CGRect(x: 0, y: 0, width: bounds.width, height: descriptionHeight)
        descriptionTextView.frame = descriptionLabelFrame
        
        let tableFrame = CGRect(x: 0, y: descriptionHeight, width: bounds.width, height: tableHeight)
        tableView.frame = tableFrame
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