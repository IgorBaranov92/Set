import UIKit

class SetDeckView: UIView {

    var setCardViews = [SetCardView]() { didSet {
        setCardViews.forEach { addSubview($0);$0.contentMode = .redraw }
        setNeedsLayout()
    }}

    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: .aspectRatio(Constants.setCardViewAspectRatio), frame: bounds)
        grid.cellCount = setCardViews.count
        setCardViews.forEach { cardView in
            let index = self.setCardViews.firstIndex(of: cardView)!
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0.0,
                options: .curveLinear,
                animations: { self.setCardViews[index].frame = grid[index] ?? CGRect.zero } )
        }
    }
    
    
    
    private struct Constants {
        static let setCardViewAspectRatio: CGFloat = 8.0/5.0
    }

}
