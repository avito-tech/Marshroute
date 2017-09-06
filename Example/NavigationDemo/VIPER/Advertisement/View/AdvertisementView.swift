import UIKit

private let ReuseId = "AdvertisementViewCell"
private let tableHeaderHeight: CGFloat = 44

final class AdvertisementView: UIView, UITableViewDelegate, UITableViewDataSource {
    fileprivate let gradientView = GradientView()
    fileprivate let patternView = UIView()
    fileprivate let tableView = UITableView()
    fileprivate var recommendedSearchResults = [SearchResultsViewData]()
    fileprivate let placeholderImageView = UIImageView()
    fileprivate var uiInsets = UIEdgeInsets.zero
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(gradientView)
        
        addSubview(patternView)
        patternView.isHidden = true
        
        addSubview(placeholderImageView)
        placeholderImageView.contentMode = .scaleAspectFill
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
    func setPatternAssetName(_ assetName: String?) {
        if let assetName = assetName, let patternImage = UIImage(named: assetName) {
            patternView.backgroundColor = UIColor(patternImage: patternImage)
            patternView.isHidden = false
        } else {
            patternView.isHidden = true
        }
    }
    
    func setPlaceholderAssetName(_ assetName: String?) {
        if let assetName = assetName, let placeholderImage = UIImage(named: assetName) {
            placeholderImageView.image = placeholderImage
            setNeedsLayout()
        }
    }
    
    func setBackgroundRGB(_ rgb: (red: Double, green: Double, blue: Double)?) {
        guard let color = colorFromRGB(rgb)
            else { return }
        
        gradientView.bottomColor = color
    }
    
    func setSimilarSearchResults(_ searchResults: [SearchResultsViewData]) {
        recommendedSearchResults = searchResults
        tableView.reloadData()
        setNeedsLayout()
    }
    
    func setSimilarSearchResultsHidden(_ hidden: Bool) {
        tableView.isHidden = hidden
        setNeedsLayout()
    }
    
    func setUIInsets(_ insets: UIEdgeInsets) {
        uiInsets = insets
        
        tableView.contentInset.bottom = insets.bottom
        tableView.scrollIndicatorInsets.bottom = insets.bottom
    }    

    var peekSourceViews: [UIView] {
        return [tableView]
    }
    
    func peekDataAt(
        location: CGPoint,
        sourceView: UIView)
        -> RecommendedSearchResultsPeekData?
    {
        guard let indexPath = tableView.indexPathForRow(at: location)
            else { return nil }
        
        guard let cell = tableView.cellForRow(at: indexPath)
            else { return nil }
        
        guard indexPath.row < recommendedSearchResults.count  
            else { return nil }
        
        let recommendedSearchResult = recommendedSearchResults[indexPath.row]
        
        let cellFrameInSourceView = cell.convert(cell.bounds, to: tableView)
        
        return RecommendedSearchResultsPeekData(
            viewData: recommendedSearchResult,
            sourceRect: cellFrameInSourceView
        )
    }    
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientView.frame = bounds
        patternView.frame = bounds
        
        if tableView.isHidden {
            placeholderImageView.frame = bounds
        } else {
            let tableHeight =
                CGFloat(recommendedSearchResults.count) * tableView.rowHeight
                    + CGFloat(tableView.numberOfSections) * tableHeaderHeight
            
            let tableTop = bounds.height - tableHeight
            
            let tableFrame = CGRect(x: 0, y: tableTop, width: bounds.width, height: tableHeight)
            tableView.frame = tableFrame
            
            placeholderImageView.frame = CGRect(x: 0, y: uiInsets.top, width: bounds.width, height: tableTop)            
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ReuseId)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ReuseId)
            cell?.textLabel?.highlightedTextColor = .white
        }
        
        let searchResult = recommendedSearchResults[(indexPath as NSIndexPath).row]
        
        let color = colorFromRGB(searchResult.rgb)
        
        cell?.textLabel?.text = searchResult.title
        cell?.contentView.backgroundColor = color
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Рекомендуемые объявления"
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        recommendedSearchResults[(indexPath as NSIndexPath).row].onTap()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderHeight
    }
    
    // MARK: - Private
    fileprivate func colorFromRGB(_ rgb: (red: Double, green: Double, blue: Double)?) -> UIColor? {
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
    var bottomColor: UIColor = .white {
        didSet {
            if let gradientLayer = layer as? CAGradientLayer {
                gradientLayer.colors = [
                    UIColor.white.cgColor,
                    bottomColor.withAlphaComponent(0.8).cgColor,
                ]
                
                gradientLayer.locations = [0, 1]
            }
        }
    }
    
    // MARK: - Layer
    override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

struct RecommendedSearchResultsPeekData {
    let viewData: SearchResultsViewData
    let sourceRect: CGRect
}
