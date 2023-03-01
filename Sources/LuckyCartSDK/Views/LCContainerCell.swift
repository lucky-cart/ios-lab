//
//  LCContainerCell.swift
//  
//
//  Created by Lucky Cart on 27/01/2023.
//

import UIKit

public class LCContainerCell: UITableViewCell {

    public func embeddedView<T: LCView>(_: T.Type) -> T? {
        
        return subviews.first(where: {$0 is T}) as? T
    }

}

public class LCContainerCollectionViewCell: UICollectionViewCell {

    public func embeddedView<T: LCView>(_: T.Type) -> T? {
        
        return subviews.first(where: {$0 is T}) as? T
    }

}
