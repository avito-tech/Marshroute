import UIKit

private let ReuseId = "SearchResultsViewCell"

final class SearchResultsView: UIView, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView(frame: .zero, style: .Plain)
    private var searchResults = [SearchResultsViewData]()
 
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadWithSearchResults(searchResults: [SearchResultsViewData]) {
        self.searchResults = searchResults
        tableView.reloadData()
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(ReuseId)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: ReuseId)
            cell?.textLabel?.highlightedTextColor = .whiteColor()
        }

        let searchResult = searchResults[indexPath.row]
        
        let color = UIColor(
            red: CGFloat(searchResult.rgb.red),
            green: CGFloat(searchResult.rgb.green),
            blue: CGFloat(searchResult.rgb.blue),
            alpha: 0.3
        )
        
        cell?.textLabel?.text = searchResult.title
        cell?.contentView.backgroundColor = color
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchResults[indexPath.row].onTap()
    }
}