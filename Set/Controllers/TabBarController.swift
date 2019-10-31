import UIKit

class TabBarController: UITabBarController {

    override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        return UIDevice.current.userInterfaceIdiom != .pad ? UITraitCollection(horizontalSizeClass: .compact) : super.traitCollection
}

}
