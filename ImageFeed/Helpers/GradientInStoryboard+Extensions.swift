//
//  GradientInStoryboardExtension.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 09.11.2023.
//

import UIKit

private var startGradientColorAssociatedKey : UIColor = .black
private var endGradientColorAssociatedKey : UIColor = .black
private var observationGradientView: NSKeyValueObservation?

@IBDesignable
class MyGradientView: UIView {
    
    @IBInspectable var color1: UIColor = .red {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var color2: UIColor = .yellow {
        didSet { setNeedsDisplay() }
    }
    
    private var gradientLayer: CAGradientLayer!
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() -> Void {
        // use self.layer as the gradient layer
        gradientLayer = self.layer as? CAGradientLayer
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
    }
}
