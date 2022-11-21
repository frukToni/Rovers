//
//  RoversView.swift
//  Rovers
//
//  Created by air on 29.10.2022.
//

import UIKit
import SnapKit

final class RoversView: UIView {
        
    weak var delegate: RoversViewDelegate!

    private let topImageView = UIImageView()
    private let leftImageView = UIImageView()
    private let rightImageView = UIImageView()
        
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
        for (type, view) in zip(RoverType.allCases, [topImageView, leftImageView, rightImageView]) {
            view.image = type.roverSegmentImage
            view.tag = type.rawValue
        }
        
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: 1.35, y: 1.35)
        transform = transform.translatedBy(x: -ProjectView.unit * 3, y: -ProjectView.unit * 32)
        topImageView.transform = transform
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlerAction)))
    }
    
    private func addSubviews() {
        [
            topImageView,
            leftImageView,
            rightImageView
        ].forEach(addSubview)
    }
    
    private func addConstraints() {
        topImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(ProjectView.unit * 16)
            $0.height.equalTo(ProjectView.unit * 268)
        }
        
        leftImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(ProjectView.unit * 16)
            $0.bottom.equalToSuperview()
            $0.size.equalTo(ProjectView.unit * 330)
        }
        
        rightImageView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(ProjectView.unit * 16)
            $0.bottom.equalToSuperview().inset(ProjectView.unit * 31)
            $0.height.equalTo(ProjectView.unit * 268)
            $0.width.equalTo(rightImageView.snp.height).multipliedBy(0.5)
        }
    }
    
    private func checTapSegment(point: CGPoint) -> UIImageView {
        let rightTriangle = (CGPoint(x: ProjectView.unit * 375, y: ProjectView.unit * 128),
                             CGPoint(x: ProjectView.unit * 375, y: ProjectView.unit * 470),
                             CGPoint(x: ProjectView.unit * 200, y: ProjectView.unit * 300))
        
        let leftTriangle = (CGPoint(x: 0, y: ProjectView.unit * 100),
                            CGPoint(x: ProjectView.unit * 375, y: ProjectView.unit * 470),
                            CGPoint(x: 0, y: ProjectView.unit * 470))
        
        if pointIsContain(at: rightTriangle) {
            return rightImageView
        } else if pointIsContain(at: leftTriangle) {
            return leftImageView
        } else {
            return topImageView
        }
        
        func pointIsContain(at triangle: (CGPoint, CGPoint, CGPoint)) -> Bool {
            let a = (triangle.0.x - point.x) * (triangle.1.y - triangle.0.y) -
            (triangle.1.x - triangle.0.x) * (triangle.0.y - point.y)
            let b = (triangle.1.x - point.x) * (triangle.2.y - triangle.1.y) -
            (triangle.2.x - triangle.1.x) * (triangle.1.y - point.y)
            let c = (triangle.2.x - point.x) * (triangle.0.y - triangle.2.y) -
            (triangle.0.x - triangle.2.x) * (triangle.2.y - point.y)
            
            return (a >= 0 && b >= 0 && c >= 0) || (a <= 0 && b <= 0 && c <= 0)
        }
    }
    
     func animateSegment(selectedSegmentTag: Int) {
        [topImageView, leftImageView, rightImageView].forEach {  segment in
            let scaleFactor = selectedSegmentTag == segment.tag ? 1.35 : 1
            let offset: CGFloat = selectedSegmentTag == segment.tag ? ProjectView.unit : 0
            
            UIView.animate(withDuration: 0.25) {
                var transform = CGAffineTransform.identity
                transform = transform.scaledBy(x: scaleFactor, y: scaleFactor)
                
                switch segment {
                case self.topImageView: transform = transform.translatedBy(x: -offset * 3, y: -offset * 32)
                case self.leftImageView: transform = transform.translatedBy(x: -offset * 37, y: -offset * 37)
                case self.rightImageView: transform = transform.translatedBy(x: offset * 17, y: 0)
                default: break
                }
                
                segment.transform = transform
            }
        }
    }
}

@objc extension RoversView {
    private func handlerAction(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: sender.view)
        let segment = checTapSegment(point: touchLocation)
        delegate.tapAt(with: RoverType(rawValue: segment.tag)!)
        animateSegment(selectedSegmentTag: segment.tag)
    }
}
