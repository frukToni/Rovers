//
//  ProjectView.swift
//  Rovers
//
//  Created by air on 05.11.2022.
//

import UIKit
import SnapKit

protocol RoversViewDelegate: AnyObject {
    func tapAt(with rover: RoverType)
}

protocol ProjectViewProtocol {
    var controller: ViewController! { get set }
}

final class ProjectView: UIView, ProjectViewProtocol {    
    
    weak var controller: ViewController!
    
    let dataSource = [
        RoversCell.CellConfig(title: Localization.Rover.Top.title, description: Localization.Rover.Top.description),
        RoversCell.CellConfig(title: Localization.Rover.Left.title, description: Localization.Rover.Left.description),
        RoversCell.CellConfig(title: Localization.Rover.Right.title, description: Localization.Rover.Right.description)
    ]
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let roversView = RoversView()
    
    static let unit = UIScreen.main.bounds.width / 375
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        return collection
    }()
    
    private let fetchLabel: UILabel = {
        let label = UILabel()
        label.font = .getGillSansRegular(ofsize: 14)
        label.textColor = UIColor(hexString: "848B9B")
        label.text = Localization.MainScreen.subtitle.uppercased()
        return label
    }()
    
    private let fetchAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hexString: "536DFE")
        button.setTitle(Localization.MainScreen.fetchButton, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .getGillSansRegular(ofsize: 16)
        return button
    }()
    
    private let calendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hexString: "536DFE")
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        return button
    }()
    
    private lazy var stackViewButtons: UIStackView = {
        let view = UIStackView(arrangedSubviews: [fetchAllButton, calendarButton])
        view.spacing = 15
        view.axis = .horizontal
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAppearance()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureAppearance()
        addSubviews()
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [
            fetchAllButton,
            calendarButton
        ].forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
        }
    }
    
    private func configureAppearance() {
        backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RoversCell.self, forCellWithReuseIdentifier: RoversCell.id)
        
        roversView.delegate = self
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
        roversView,
        fetchLabel,
        collectionView,
        stackViewButtons
        ].forEach(contentView.addSubview)
    }
    
    private func addConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(snp.width)
        }
        
        roversView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(1.25)
        }
        
        fetchLabel.snp.makeConstraints {
            $0.top.equalTo(roversView.snp.bottom).offset(16 * ProjectView.unit)
            $0.left.right.equalToSuperview().inset(16 * ProjectView.unit)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(fetchLabel.snp.bottom).offset(15)
            $0.height.equalTo(230)
            $0.left.right.equalTo(safeAreaLayoutGuide)
        }
        
        fetchAllButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        calendarButton.snp.makeConstraints {
            $0.height.equalTo(fetchAllButton)
            $0.width.equalTo(80)
        }
        
        stackViewButtons.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(35)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        roversView.animateSegment(selectedSegmentTag: indexPath.item)
    }
}

// MARK: UICollectionViewDataSource
extension ProjectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoversCell.id, for: indexPath) as! RoversCell
        let item = dataSource[indexPath.item]
        cell.configure(with: .init(title: item.title, description: item.description))
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ProjectView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        RoversCell.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.selectedRover(RoverType(rawValue: indexPath.item)!)
    }
}

extension ProjectView: RoversViewDelegate {
    func tapAt(with rover: RoverType) {
        collectionView.scrollToItem(at: .init(row: rover.rawValue, section: 0), at: .bottom, animated: true)
    }
}
