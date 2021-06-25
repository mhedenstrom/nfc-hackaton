
import Foundation
import UIKit


extension CGRect {
    func aspect(viewRect: CGRect, mode: UIView.ContentMode) -> CGRect {
        var scaledImageRect: CGRect = .zero
        let aspectWidth = viewRect.width / self.size.width
        let aspectHeight = viewRect.height / self.size.height

        let aspectRatio: CGFloat
        switch mode {
        case .scaleAspectFit:
            aspectRatio = min(aspectWidth, aspectHeight)
        case .scaleAspectFill:
            aspectRatio = max(aspectWidth, aspectHeight)
        default:
            aspectRatio = 1.0
        }

        scaledImageRect.size.width = self.width * aspectRatio
        scaledImageRect.size.height = self.height * aspectRatio
        scaledImageRect.origin.x = (viewRect.width - scaledImageRect.width) / 2.0
        scaledImageRect.origin.y = (viewRect.height - scaledImageRect.height) / 2.0

        return scaledImageRect
    }
}
