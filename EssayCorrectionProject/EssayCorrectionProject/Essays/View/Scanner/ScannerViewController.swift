import UIKit
import WeScan

class MyViewController: UIViewController {
    
    var scanner: ImageScannerController = {
        let scanner = ImageScannerController()
        return scanner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add `scanner` as a child view controller
        addChild(scanner)
        view.addSubview(scanner.view)
        scanner.didMove(toParent: self)
        
        // Set up constraints for `scanner.view`
        scanner.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scanner.view.topAnchor.constraint(equalTo: view.topAnchor),
            scanner.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scanner.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scanner.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
