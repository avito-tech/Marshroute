import UIKit

private let ReuseId = "CategoriesViewCell"

final class CategoriesView: UIView, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()
    private var timerButton: UIButton?
    private var categories = [CategoriesViewData]()
    
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
    func reloadWithCategories(categories: [CategoriesViewData]) {
        self.categories = categories
        tableView.reloadData()
    }
    
    func setTimerButtonVisible(visible: Bool) {
        if visible {
            if timerButton == nil {
                let timerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                
                timerButton.setTitleColor(.whiteColor(), forState: .Normal)
                timerButton.backgroundColor = .blueColor()
                
                timerButton.addTarget(self, action: "onTimerButtonTap:", forControlEvents: .TouchUpInside)
                
                self.timerButton = timerButton
            }
        } else {
            timerButton?.removeFromSuperview()
            timerButton = nil
        }
    }
    
    func setTimerButtonEnabled(enabled: Bool) {
        timerButton?.enabled = enabled
    }
    
    func setTimerButtonTitle(title: String) {
        timerButton?.setTitle(title, forState: .Normal)
    }
    
    var onTimerButtonTap: (() -> ())?
    
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
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(ReuseId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: ReuseId)
        }
        cell?.textLabel?.text = categories[indexPath.row].title
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        categories[indexPath.row].onTap()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return timerButton
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return timerButton == nil ? 0 : 30
    }
    
    // MARK: - Private
    @objc private func onTimerButtonTap(sender: UIButton) {
        onTimerButtonTap?()
    }
}