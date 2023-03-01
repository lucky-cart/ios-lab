//
//  LCView.swift
//  
//
//  Created by Lucky Cart on 27/01/2023.
//

import UIKit

public protocol LCViewLoadable {
    
    static func load(owner: Any?) -> Self
    static func nibName() -> String
}

extension LCViewLoadable where Self: LCView {
    
    public static func load (owner: Any?) -> Self {
        let view = Bundle.module.loadNibNamed(nibName(), owner: owner, options: nil)![0] as? Self
        return view ?? Self()
    }
    
    public static func nibName() -> String {
        return String(describing: self)
    }
}

public protocol LCViewTableViewCellDequeueable {
    static func dequeue(_ tableView: UITableView, _ indexPath: IndexPath) -> LCContainerCell
    func dequeue(_ tableView: UITableView, _ indexPath: IndexPath) -> LCContainerCell
}

extension LCViewTableViewCellDequeueable where Self: LCView {
    
    public static func dequeue(_ tableView: UITableView, _ indexPath: IndexPath) -> LCContainerCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier(), for: indexPath)
        cell.selectionStyle = .none
        load(owner: tableView).embeddedIn(tableViewCell: cell)
        return (cell as? LCContainerCell) ?? LCContainerCell()
    }
    
    public func dequeue(_ tableView: UITableView, _ indexPath: IndexPath) -> LCContainerCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.identifier(), for: indexPath)
        cell.selectionStyle = .none
        self.embeddedIn(tableViewCell: cell)
        return (cell as? LCContainerCell) ?? LCContainerCell()
    }
}

public protocol LCViewCollectionCellDequeueable {
    static func dequeue(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> LCContainerCollectionViewCell
    func dequeue(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> LCContainerCollectionViewCell
}

extension LCViewCollectionCellDequeueable where Self: LCView {
    
    public static func dequeue(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> LCContainerCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier(), for: indexPath)
        load(owner: collectionView).embeddedIn(collectionViewCell: cell)
        return (cell as? LCContainerCollectionViewCell) ?? LCContainerCollectionViewCell()
    }
    
    public func dequeue(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> LCContainerCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.identifier(), for: indexPath)
        self.embeddedIn(collectionViewCell: cell)
        return (cell as? LCContainerCollectionViewCell) ?? LCContainerCollectionViewCell()
    }
}


public class LCView: UIView, LCViewLoadable, LCViewTableViewCellDequeueable, LCViewCollectionCellDequeueable {

    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public class func identifier() -> String {
        return String(describing: self)
    }
    
    public class func load(owner: Any? = .none) -> Self {
         return Self()
     }
    
    public var contentView: UIView?
    var nibName: String? {
        if let overridedNibName {
            return overridedNibName
        }
        let name = NSStringFromClass(Self.self)
        let components = name.split(separator: ".").map(String.init)
        return components.last ?? "Unknown"
    }
    
    open var overridedNibName: String? {
        return nil
    }
    
    //MARK: - Init
    
    open override class func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        initialize()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        initialize()

        translatesAutoresizingMaskIntoConstraints = true
    }

    private func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        addSubview(view)
        contentView = view
        fill(view: view)
    }

    open func initialize() {}
    
    open func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let nib =  UINib(nibName: nibName, bundle: Bundle.module)

        let view = nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
        view?.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    @objc func fill(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        topConstraint.priority = .required
        topConstraint.isActive = true
        let bottomConstraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomConstraint.priority = .required
        bottomConstraint.isActive = true
        let leadingConstraint = leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        leadingConstraint.isActive = true
        let trailingConstraint = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        trailingConstraint.isActive = true
    }
    
    //MARK: - EnbeddedIn
    
    @objc open func embeddedIn(tableViewCell: UITableViewCell) {
        let separatorView = tableViewCell.subviews.first(where: {
            String(describing: type(of: $0)).hasSuffix("SeparatorView")
        })
        embeddedIn(view: tableViewCell)
        tableViewCell.contentView.isUserInteractionEnabled = false
        if let separatorView = separatorView {
            tableViewCell.bringSubviewToFront(separatorView)
        }
    }
    
    @objc func embeddedIn(collectionViewCell: UICollectionViewCell) {
        embeddedIn(view: collectionViewCell)
    }
    
    func embeddedIn(view: UIView) {
        removeOBOView(view: view)
        view.addSubview(self)
        fill(view: view)
    }
    
    func removeOBOView(view: UIView) {
        let embeddedView = view.subviews.first(where: {$0 is LCView})
        embeddedView?.removeFromSuperview()
    }
    
}
