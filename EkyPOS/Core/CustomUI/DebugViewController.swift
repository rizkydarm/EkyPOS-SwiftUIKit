import UIKit

class DebugViewController: UIViewController {
    
    // Customizable properties
    @IBInspectable var debugBorder: Bool = false
    @IBInspectable var debugBorderColor: UIColor = .systemBlue
    @IBInspectable var debugBorderWidth: CGFloat = 5.0
    
    private var className: String {
        return String(describing: type(of: self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugLog("viewDidLoad")
        setupDebugBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugLog("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugLog("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // debugLog("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // debugLog("viewDidDisappear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // debugLog("viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        debugLog("viewDidLayoutSubviews")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // debugLog("didReceiveMemoryWarning")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        debugLog("traitCollectionDidChange")
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        debugLog("willTransition")
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        debugLog("viewWillTransition")
    }
    
    private func debugLog(_ methodName: String) {
        #if DEBUG
        debugPrint("\(className) \(methodName)")
        #endif
    }
    
    private func setupDebugBorder() {
        #if DEBUG
        if debugBorder {
            view.layer.borderColor = debugBorderColor.cgColor
            view.layer.borderWidth = debugBorderWidth
        }
        #endif
    }
}