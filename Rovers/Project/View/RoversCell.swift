//
//  RoversCell.swift
//  Rovers
//
//  Created by air on 29.10.2022.
//

import UIKit
import SnapKit

extension RoversCell {
    struct CellConfig {
        let title: String
        let description: String
    }
}

final class RoversCell: UICollectionViewCell {
    
    static let id = "rover"
    static let size = CGSize(width: UIScreen.main.bounds.width, height: 230)
    
    private let container = UIView()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .getGillSansRegular(ofsize: 32)
        label.textColor = UIColor(hexString: "2C2E30")
        return label
    }()
    
    private let missionLable: UILabel = {
        let label = UILabel()
        label.font = .getGillSansRegular(ofsize: 14)
        label.textColor = UIColor(hexString: "848B9B")
        label.text = Localization.MainScreen.mission.uppercased()
        return label
    }()
    
    private let descriptionLable: UILabel = {
      let label = UILabel()
        label.font = .getGillSansRegular(ofsize: 14)
        label.textColor = UIColor(hexString: "6E7584")
        label.numberOfLines = 5
        return label
    }()
    
    private let moreLabel: UILabel = {
        let label = UILabel()
        label.font = .getGillSansRegular(ofsize: 14)
        label.textColor = UIColor(hexString: "848B9B")
        label.text = Localization.MainScreen.moreButton.uppercased()
        return label
    }()
    
    private let circleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.tintColor = UIColor(hexString: "848B9B")
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [moreLabel, circleButton])
        view.spacing = 5
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
    
    private func configureAppearance() {
        backgroundColor = .white
    }
    
    private func addSubviews() {
        addSubview(container)
        
        [
        titleLabel,
        missionLable,
        descriptionLable,
        stackView
        ].forEach(container.addSubview)
    }
    
    private func addConstraints() {
        container.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16 * ProjectView.unit)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        missionLable.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
        }
        
        descriptionLable.snp.makeConstraints {
            $0.top.equalTo(missionLable.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(5 * ProjectView.unit)
        }
    }
    
    func configure(with item: CellConfig) {
        titleLabel.text = item.title.uppercased()
        descriptionLable.text = item.description
    }
}
