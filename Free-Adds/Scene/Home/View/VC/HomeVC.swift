//
//  HomeVCViewController.swift
//  Free-Adds
//
//  Created by Amin on 25/11/2023.
//

import UIKit
import Combine

class HomeVC: UIViewController {
    @IBOutlet weak var uiCollection: UICollectionView!
    
    private var viewModel: HomeViewModelInterface
    private var cancellables: Set<AnyCancellable> = []
    init(viewModel: HomeViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var snapshot: NSDiffableDataSourceSnapshot<HomeSection, HomeIdentifier> = .init()
    var datasource: UICollectionViewDiffableDataSource<HomeSection, HomeIdentifier>?
    
    var personCell: UICollectionView.CellRegistration<PersonCell, HomeIdentifier>?
    var labeledCell: UICollectionView.CellRegistration<LabeledTag, HomeIdentifier>?
    var addCell: UICollectionView.CellRegistration<AddCell, HomeIdentifier>?
    var header: UICollectionView.SupplementaryRegistration<Header>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCollection()
        viewModel.onScreenAppeared.send()
    }
    private func setupView() {
        bind()
        registerCell()
        configureNavigationItem()
    }
    // MARK: - navigation
    private func configureNavigationItem() {
        let image = UIImageView(frame: .init())
        image.image = UIImage(named: "logo")
        navigationItem.titleView = image
        
        let message = UIBarButtonItem(image: #imageLiteral(resourceName: "message"), style: .plain, target: self, action: #selector(messageTapped))
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(messageTapped))
        navigationItem.leftBarButtonItems = [back, message]
        
        let video = UIBarButtonItem(image: #imageLiteral(resourceName: "video"), style: .plain, target: self, action: #selector(messageTapped))
        let profile = UIBarButtonItem(image: #imageLiteral(resourceName: "profile"), style: .done, target: self, action: #selector(messageTapped))
        navigationItem.rightBarButtonItems = [profile, video]
        
    }
    // MARK: - cell registration
    private func registerCell() {
        personCell = UICollectionView.CellRegistration(
            cellNib: UINib(nibName: PersonCell.nibName, bundle: nil)
        ) { cell, _, itemIdentifier in
            cell.configure(model: itemIdentifier)
        }
        labeledCell = UICollectionView.CellRegistration(
            cellNib: .init(
                nibName: LabeledTag.nibName,
                bundle: nil
            )
        ) { cell, indexPath, itemIdentifier in
            guard let section = HomeSection(rawValue: indexPath.section) else {return}
            cell.configure(model: itemIdentifier)
        }
        addCell = UICollectionView.CellRegistration(
            cellNib: .init(nibName: AddCell.nibName, bundle: nil)
        ) { cell, _, itemIdentifier in
            cell.configure(model: itemIdentifier)
        }
        
        header = UICollectionView.SupplementaryRegistration(
            supplementaryNib: UINib(nibName: Header.nibName, bundle: nil),
            elementKind: UICollectionView.elementKindSectionHeader
        ) { supplementaryView, elementKind, indexPath in
            if elementKind == UICollectionView.elementKindSectionHeader {
                let supp = supplementaryView as Header
                let section = HomeSection(rawValue: indexPath.section)
                supp.configure(title: section?.description ?? "")
            }
        }
    }
    // MARK: - configure ceollection
    private func configureCollection() {
        uiCollection.collectionViewLayout = generateLayout()
        datasource = .init(
            collectionView: uiCollection) {[weak self] collectionView, indexPath, itemIdentifier in
                guard let self = self else {return .init()}
                guard let section = self.datasource?.sectionIdentifier(for: indexPath.section) else {
                    print("unable to extract section")
                    return .init()
                }
                
                var cell: UICollectionViewCell = .init()
                switch section {
                    case .discover:
                        guard let personCell = personCell else {return cell}
                        cell = collectionView.dequeueConfiguredReusableCell(
                            using: personCell,
                            for: indexPath,
                            item: itemIdentifier
                        )
                    case .category:
                        guard let labeledCell = labeledCell else {return cell}
                        cell = collectionView.dequeueConfiguredReusableCell(
                            using: labeledCell,
                            for: indexPath,
                            item: itemIdentifier
                        )
                    case .list:
                        guard let addCell = addCell else {return cell}
                        cell = collectionView.dequeueConfiguredReusableCell(
                            using: addCell,
                            for: indexPath,
                            item: itemIdentifier
                        )
                        
                }
                return cell
        }
        
        datasource?.supplementaryViewProvider = { [weak self] collection, key, index in
            guard let self = self else {return .init()}
            if key == UICollectionView.elementKindSectionHeader {
                guard let header = self.header else {return .init()}
                let cell = collection.dequeueConfiguredReusableSupplementary(
                    using: header,
                    for: index
                )
                return cell
            }
            return .init()
        }
        initialSnapshot()
    }
    private func initialSnapshot() {
        snapshot = .init()
        snapshot.appendSections([])
        datasource?.apply(snapshot)
    }
    // MARK: - bind view model
    private func bind() {
        viewModel.discoverData.sink {[weak self] model in
            guard let self = self else {return}
            snapshot.appendSections([.discover])
            snapshot.appendItems(model, toSection: .discover)
            datasource?.apply(snapshot)
        }.store(in: &cancellables)
        
        viewModel.categoryData.sink {[weak self] model in
            guard let self = self else {return}
            self.snapshot.appendSections([.category])
            self.snapshot.appendItems(model, toSection: .category)
            self.datasource?.apply(self.snapshot, animatingDifferences: true) {[weak self] in
                guard let self = self else {return}
                self.uiCollection.selectItem(at: .init(item: 0, section: 1), animated: true, scrollPosition: .top)
                self.uiCollection.delegate?.collectionView?(uiCollection, didSelectItemAt: .init(item: 0, section: 1))
            }
        }.store(in: &cancellables)
        viewModel.adsData.sink { [weak self] model in
            guard let self = self else {return}
            self.snapshot.deleteSections([.list])
            self.snapshot.appendSections([.list])
            self.snapshot.appendItems(model, toSection: .list)
            self.datasource?.apply(self.snapshot, animatingDifferences: true)
        }.store(in: &cancellables)
    }
    @objc func messageTapped() {
        
    }
    
    @IBAction func addFreeAdPressed(_ sender: UIButton) {
        viewModel.addFreeAdPressed.send()
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let section = HomeSection(rawValue: indexPath.section) else {return true}
        switch section {
            case .discover:
                return false
            default:
                break
        }
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = HomeSection(rawValue: indexPath.section) else {return}
        switch section {
            case .category:
                viewModel.onCategorySelected.send(indexPath.item)
            default:
                break
                
        }
    }
}
