//
//  NumberKeyboardView.swift
//
//  Created by 김수겸 on 2020/02/21.
//  Copyright © 2020 myname.sg. All rights reserved.
//

import UIKit

enum NumberKeyboardMode {
    case none
    case shuffle
    case dot
    case negative
    case positive
}

struct NumberKeyboardTheme {
    var color:UIColor
    var font:UIFont
    var background:UIColor
    
    mutating func apply(button: UIButton) {
        button.tintColor = self.color
        button.titleLabel?.font = self.font
        button.backgroundColor = self.background
    }
}

class NumberKeyboardView: UIView {
    private let keyboardBackground = UIColor.red
    private var numberTheme = NumberKeyboardTheme(color: .red,
                                                  font: .systemFont(ofSize: 14),
                                                  background: .blue)
    private var funcTheme = NumberKeyboardTheme(color: .blue,
                                                font: .systemFont(ofSize: 12),
                                                background: .yellow)
    private var backTheme = NumberKeyboardTheme(color: .green,
                                                font: .systemFont(ofSize: 16),
                                                background: .cyan)
    
    //shuffle, negative, input, none, positive
    
    var mode:NumberKeyboardMode = .none {
        didSet {
            shuffle(false)
            funcButton.isEnabled = true
            switch mode {
            case .none:
                funcButton.isEnabled = false
                funcButton.setTitle("", for: .normal)
            case .shuffle:
                shuffle(true)
                funcButton.setTitle("Shuffle", for: .normal)
            case .dot:
                funcButton.setTitle(".", for: .normal)
            case .negative:
                funcButton.setTitle("-", for: .normal)
            case .positive:
                funcButton.setTitle("+", for: .normal)
            }
        }
    }
    
    private var numberButtons = Array<UIButton>() {
        didSet {
            for button in numberButtons {
                numberTheme.apply(button: button)
                button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
            }
        }
    }
    
    @IBOutlet weak var funcButton: UIButton! {
        didSet {
            funcTheme.apply(button: funcButton)
            funcButton.addTarget(self, action: #selector(self.functionPressed(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backTheme.apply(button: backButton)
            backButton.addTarget(self, action: #selector(self.backPressed(_:)), for: .touchUpInside)
        }
    }
    
    private var field:UITextField?
    
    @objc private func buttonPressed(_ sender: UIButton) {
        pressed(text: sender.titleLabel?.text ?? "")
    }
    
    @objc private func functionPressed(_ sender: Any) {
        switch mode {
        case .none:
            //none
            break
        case .shuffle:
            shuffle(true)
        case .dot:
            pressed(text: ".")
        case .negative:
            pressed(text: "-")
        case .positive:
            pressed(text: "+")
        }
        
    }
    
    @objc private func backPressed(_ sender: Any) {
        guard let field = self.field,
            let selectedRange = self.field?.selectedTextRange else {
            return
        }

        if selectedRange.isEmpty {
            guard let start = field.position(from: selectedRange.start, offset: -1),
                let end = field.position(from: selectedRange.start, offset: 0),
                let range = field.textRange(from: start, to: end) else {
                    return
            }
            field.replace(range, withText: "")
        } else {
            field.replace(selectedRange, withText: "")
        }
    }
    
    private func pressed(text:String) {
        field?.insertText(text)
    }
    
    private func shuffle(_ doShuffle:Bool) {
        var keys = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        if doShuffle {
            keys.shuffle()
        }
        
        guard numberButtons.count == keys.count else {
            return
        }
        
        for i in 0..<numberButtons.count {
            let button = numberButtons[i]
            button.setTitle(keys[i], for: .normal)
        }
    }
    
    
    
    func set(_ mode:NumberKeyboardMode, _ field:UITextField) {
        
        var buttons = Array<UIButton>()
        if let wrapper = self.subviews.first {
            for stackView in wrapper.subviews {
                for v in stackView.subviews {
                    if 100...109 ~= v.tag, let button = v as? UIButton{
                        buttons.append(button)
                    }
                }
            }
        }
        
        buttons.sort { (button1, button2) -> Bool in
            return button1.tag < button2.tag
        }
        
        self.backgroundColor = keyboardBackground
        self.numberButtons = buttons
        self.mode = mode
        self.field = field
    }
}



extension NumberKeyboardView {
    static func set(field:UITextField, mode:NumberKeyboardMode) {
        let view = Bundle.main.loadNibNamed("NumberKeyboardView", owner: self, options: nil)?.first as! NumberKeyboardView
        
        field.inputView = view
        view.set(mode, field)
    }
}
