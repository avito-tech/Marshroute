import UIKit

private let ReuseId = "CategoriesViewCell"

final class CategoriesView: UIView, UITableViewDelegate, UITableViewDataSource {
    fileprivate let tableView = UITableView()
    fileprivate var timerButton: UIButton?
    fileprivate var categories = [CategoriesViewData]()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() // to hide unnecessary separators
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    func reloadWithCategories(_ categories: [CategoriesViewData]) {
        self.categories = categories
        tableView.reloadData()
    }
    
    func setTimerButtonVisible(_ visible: Bool) {
        if visible {
            if timerButton == nil {
                let timerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                
                timerButton.setTitleColor(.white, for: UIControlState())
                timerButton.backgroundColor = .blue
                
                timerButton.addTarget(self, action: #selector(CategoriesView.onTimerButtonTap(_:)), for: .touchUpInside)
                
                self.timerButton = timerButton
            }
        } else {
            timerButton?.removeFromSuperview()
            timerButton = nil
        }
    }
    
    func setTimerButtonEnabled(_ enabled: Bool) {
        timerButton?.isEnabled = enabled
    }
    
    func setTimerButtonTitle(_ title: String) {
        timerButton?.setTitle(title, for: UIControlState())
    }
    
    // MARK: - BasePeekAndPopViewController
    var peekSourceView: UIView {
        return tableView
    }
    
    func peekDataAtLocation(
        location: CGPoint,
        sourceView: UIView)
        -> CategoriesPeekData?
    {
        guard let indexPath = tableView.indexPathForRow(at: location)
            else { return nil }
        
        guard let cell = tableView.cellForRow(at: indexPath)
            else { return nil }
        
        guard indexPath.row < categories.count  
            else { return nil }
        
        let category = categories[indexPath.row]
        
        let cellFrameInSourceView = cell.convert(cell.bounds, to: tableView)
        
        return CategoriesPeekData(
            viewData: category,
            sourceRect: cellFrameInSourceView
        )
    }
    
    var onTimerButtonTap: (() -> ())?
    
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
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ReuseId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ReuseId)
        }
        cell?.textLabel?.text = categories[(indexPath as NSIndexPath).row].title
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        categories[(indexPath as NSIndexPath).row].onTap()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return timerButton
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return timerButton == nil ? 0 : 30
    }
    
    // MARK: - Private
    @objc fileprivate func onTimerButtonTap(_ sender: UIButton) {
        onTimerButtonTap?()
    }
}

struct CategoriesPeekData {
    let viewData: CategoriesViewData
    let sourceRect: CGRect
}
