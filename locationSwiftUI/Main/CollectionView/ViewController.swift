//
//  ViewController.swift
//  CustomCollectionView
//
//  Created by TsuiWingLok on 27/10/2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var customCollectionView: UICollectionView!
    {
        didSet{
            customCollectionView.delegate = self
            customCollectionView.dataSource = self
//            customCollectionView.dragDelegate = self
//            customCollectionView.dropDelegate = self
            customCollectionView.dragInteractionEnabled = true
            customCollectionView.alwaysBounceVertical = false
        }
    }
    
    var isSimpleLayout:Bool = true{
        didSet{
            self.customCollectionView.reloadData()
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    let customCellConfig = UICollectionView.CellRegistration<CustomCollectionViewCell, CustomModel> { (cell, indexPath, model) in
        cell.label.text = model.text
    }
    
    let headerRegistration = UICollectionView.SupplementaryRegistration<CustomHeaderView>(elementKind: UICollectionView.elementKindSectionHeader){
        supplementaryView, string, indexPath in
        supplementaryView.label.text = (indexPath.section == 0) ? "Card Flat CollectionView" : "Simple CollectionView"
        supplementaryView.backgroundColor = .lightGray
    }
    
    var numListS0 = Array(0...9).map({String($0)})
    var numListS1 = Array(10...19).map({String($0)})
    
    struct CustomModel{
        var text: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customCollectionView.collectionViewLayout = collectionViewLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func simpleCollectionViewLayout() -> NSCollectionLayoutSection  {
        let edgeInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = edgeInsets
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
//        section.orthogonalScrollingBehavior = .groupPagingCentered

//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//
//        //        header.pinToVisibleBounds = true
//        section.boundarySupplementaryItems = [header]

        return section

    }
    
    private func cardFlatCollectionViewLayout() -> NSCollectionLayoutSection  {
        let edgeInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.4))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = edgeInsets
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//
//        header.pinToVisibleBounds = true
//        section.boundarySupplementaryItems = [header]
        
        section.visibleItemsInvalidationHandler = { (visibleItems, point, env) -> Void in
            
            if let firstItem = visibleItems.first{
                if (point.x + firstItem.frame.midX) < 0{
                    DispatchQueue.main.async {
                        self.customCollectionView.scrollToItem(at: IndexPath(row: self.numListS0.count * 500, section: firstItem.indexPath.section), at: .centeredHorizontally, animated: false)
//                        self.customCollectionView.scrollToItem(at: firstItem.indexPath, at: .centeredHorizontally, animated: false)
                    }
                }
            }
            
            visibleItems.forEach { (item) in
                let midPointX = (point.x + self.customCollectionView.frame.width / 2)
                var alpha = abs(item.frame.midX-midPointX) / item.frame.width
                
                var vectorAlpha = (item.frame.midX-midPointX) / item.frame.width
                vectorAlpha = (vectorAlpha < -1) ? -1 : vectorAlpha
                vectorAlpha = (vectorAlpha > 1) ? 1 : vectorAlpha
                
                alpha = (alpha > 1) ? 1 : alpha
                let scaleFactor = 1 - (0.3 * alpha)
                
                var trans3D = CATransform3DIdentity
                trans3D.m34  = -1/500
                
                let angular = CGFloat.pi * (25 / 180) * vectorAlpha
                
                let rotate3D = CATransform3DRotate(trans3D, angular, 0, 1, 0)
                let scale3D = CATransform3DScale(trans3D, scaleFactor, scaleFactor, 1.0)
                
                item.transform3D = CATransform3DConcat(scale3D, rotate3D)
                
                item.alpha = 1 - (0.3 * alpha)
                
            }
        }
        
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//
////        header.pinToVisibleBounds = true
//        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func customCollectionViewLayout() -> NSCollectionLayoutSection {
        
        let edgeInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        
        let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        
        let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4))
        
        let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
        let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
        
        leadingItem.contentInsets = edgeInsets
        trailingItem.contentInsets = edgeInsets
        
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize,
                                                             subitem: trailingItem,
                                                             count: 4)
        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize,
                                                                subitems: [leadingItem,
                                                                           trailingGroup])
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

//        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in
            return (sectionIndex == 0) ? self.cardFlatCollectionViewLayout() : self.simpleCollectionViewLayout()
        }
        return layout
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    // MARK:- CollectionView Delegate, DateSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0{
            return numListS0.count * 1000
        }else if section == 1{
            return numListS1.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model:CustomModel
        
        let row = indexPath.row % numListS0.count
        
        if indexPath.section == 0{
            model = CustomModel(text: (numListS0[row]))
        }else{
            model = CustomModel(text: (numListS1[row]))
        }
        
        return collectionView.dequeueConfiguredReusableCell(using: customCellConfig,
                                                            for: indexPath,
                                                            item: model)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        print("indexPath : \(indexPath)")
        
        let selectedPath = (indexPath.section == 0) ? IndexPath(row: indexPath.row % numListS0.count, section: indexPath.section) : indexPath
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        var trans3D = CATransform3DIdentity
        trans3D.m34  = -1/500
        
        if let trans = cell?.layer.transform{
            trans3D.m11 = -trans.m11
            trans3D.m33 = -trans.m33
        }
        
        let rotate3D = trans3D
        
        UIView.animate(withDuration: 0.5) {
            if let customCell = cell as? CustomCollectionViewCell{
                customCell.layer.transform = rotate3D
            }
        }
    }
    
}

//extension ViewController : UICollectionViewDragDelegate{
//
//    // MARK:- CollectionView Drag Delegate
//
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
//    {
//        let item = (indexPath.section == 0) ? self.numListS0[indexPath.row] : self.numListS1[indexPath.row]
//        let itemProvider = NSItemProvider(object: item as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//        return [dragItem]
//    }
//
//    // Multiple drag
//    //    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem]
//    //    {
//    //        let item = (indexPath.section == 0) ? self.numListS0[indexPath.row] : self.numListS1[indexPath.row]
//    //        let itemProvider = NSItemProvider(object: item as NSString)
//    //        let dragItem = UIDragItem(itemProvider: itemProvider)
//    //        dragItem.localObject = item
//    //        return [dragItem]
//    //    }
//
////        func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters?{
////            let previewParameters = UIDragPreviewParameters()
////            previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 150, height: 150))
////            return previewParameters
////        }
//}
//
//extension ViewController: UICollectionViewDropDelegate{
//    // MARK:- CollectionView Drop Delegate
//
//    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool{
//        return session.canLoadObjects(ofClass: NSString.self)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,dropSessionDidUpdate session: UIDropSession,
//                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal{
//
//        if collectionView.hasActiveDrag{
//            return UICollectionViewDropProposal(operation: .move,
//                                                intent: .insertAtDestinationIndexPath)
//        }
//
//        return UICollectionViewDropProposal(operation: .forbidden)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        var dest:IndexPath
//
//        if let indexPath = coordinator.destinationIndexPath{
//            dest = indexPath
//        }else{
//            return
//        }
//
//        switch coordinator.proposal.operation
//        {
//        case .move:
//            self.reorderItems(coordinator: coordinator, destinationIndexPath: dest, collectionView: collectionView)
//        //        case .copy:
//        //            self.moveItems(coordinator: coordinator, destinationIndexPath: dest, collectionView: collectionView)
//        default:
//            return
//        }
//
//    }
//
//    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
//    {
//        let items = coordinator.items
//        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
//        {
//            var dIndexPath = destinationIndexPath
//            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
//            {
//                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
//            }
//            collectionView.performBatchUpdates({
//                if(sourceIndexPath.section == 0){
//                    numListS0.remove(at: sourceIndexPath.item)
//                }else{
//                    numListS1.remove(at: sourceIndexPath.item)
//                }
//
//                if(dIndexPath.section == 0){
//                    numListS0.insert(item.dragItem.localObject as? String ?? "", at: dIndexPath.item)
//                }else{
//                    numListS1.insert(item.dragItem.localObject as? String ?? "", at: dIndexPath.item)
//                }
//
//                collectionView.deleteItems(at: [sourceIndexPath])
//                collectionView.insertItems(at: [dIndexPath])
//            })
//            //            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
//        }
//    }
    
    // bug exist
    
    //    private func moveItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView){
    //        collectionView.performBatchUpdates({
    //            var indexPaths = [IndexPath]()
    //            var sourceIndexPath = [IndexPath]()
    //
    //            for (index, item) in coordinator.items.enumerated()
    //            {
    //
    //                var dIndexPath = destinationIndexPath
    //
    //                if let object = item.dragItem.localObject as? String,
    //                   let index = (item.sourceIndexPath?.section == 0) ? numListS0.firstIndex(of: object) : numListS1.firstIndex(of: object){
    //                    if let sourcePath = item.sourceIndexPath {
    //                        if(sourcePath.section == 0){
    //                            numListS0.remove(at: index)
    //                        }else{
    //                            numListS1.remove(at: index)
    //                        }
    //                        sourceIndexPath.append(sourcePath)
    //                    }
    //
    //                    if(dIndexPath.section == 0){
    //                        numListS0.insert(item.dragItem.localObject as? String ?? "", at: dIndexPath.item)
    //                    }else{
    //                        numListS1.insert(item.dragItem.localObject as? String ?? "", at: dIndexPath.item)
    //                    }
    //                    indexPaths.append(dIndexPath)
    //                }
    //                collectionView.deleteItems(at: sourceIndexPath)
    //                collectionView.insertItems(at: indexPaths)
    //            }
    //        })
    //    }
//}
