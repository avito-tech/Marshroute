import UIKit

private let ReuseId = "SearchResultsViewCell"

final class SearchResultsView: UIView, UITableViewDelegate, UITableViewDataSource {
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate var searchResults = [SearchResultsViewData]()
 
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    func reloadWithSearchResults(_ searchResults: [SearchResultsViewData]) {
        self.searchResults = searchResults
        tableView.reloadData()
    }    
    
    var peekSourceViews: [UIView] {
        return [tableView]
    }
    
    func peekDataAt(
        location: CGPoint,
        sourceView: UIView)
        -> SearchResultsPeekData?
    {
        guard let indexPath = tableView.indexPathForRow(at: location)
            else { return nil }
        
        guard let cell = tableView.cellForRow(at: indexPath)
            else { return nil }
        
        guard indexPath.row < searchResults.count  
            else { return nil }
        
        let searchResult = searchResults[indexPath.row]
        
        let cellFrameInSourceView = cell.convert(cell.bounds, to: tableView)
        
        return SearchResultsPeekData(
            viewData: searchResult,
            sourceRect: cellFrameInSourceView
        )
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ReuseId)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ReuseId)
            cell?.textLabel?.highlightedTextColor = .white
        }

        let searchResult = searchResults[(indexPath as NSIndexPath).row]
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchResults[(indexPath as NSIndexPath).row].onTap()
    }
}

struct SearchResultsPeekData {
    let viewData: SearchResultsViewData
    let sourceRect: CGRect
}
