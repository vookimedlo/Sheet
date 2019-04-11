import UIKit
import Sheet

enum ShareType {
    
    case simple, tricky
    
    func sheetManager(chromeTapped: @escaping () -> Void) -> Sheet {
        let width: CGFloat = 30
        let bottom: CGFloat = 20
        let sheet: Sheet
        switch self {
        case .simple:
            sheet = Sheet(animation: .fade, widthInset: width, bottomInset: bottom)
        case .tricky:
            sheet = Sheet(animation: .custom, widthInset: width, bottomInset: bottom)
        }
        sheet.chromeTapped = chromeTapped
        return sheet
    }
    
    func loadInitialSheet() -> UIViewController {
        if networkConnectionAvailable {
            return SheetFactory.network("The internet is required to proceed.")
        }
        switch self {
        case .simple:
            return SheetFactory.welcome()
        case .tricky:
            return SheetFactory.connect()
        }
    }
}
