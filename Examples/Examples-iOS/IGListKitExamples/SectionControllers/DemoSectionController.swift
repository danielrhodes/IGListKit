/**
 Copyright (c) 2016-present, Facebook, Inc. All rights reserved.

 The examples provided by Facebook are for non-commercial testing and evaluation
 purposes only. Facebook reserves all rights not expressly granted.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit
import IGListKit

class DemoItem: NSObject {

    let name: String
    let controllerClass: UIViewController.Type
    let controllerIdentifier: String?

    init(
        name: String,
        controllerClass: UIViewController.Type,
        controllerIdentifier: String? = nil
        ) {
        self.name = name
        self.controllerClass = controllerClass
        self.controllerIdentifier = controllerIdentifier
    }

}

extension DemoItem: IGListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return name as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? DemoItem else { return false }
        return controllerClass == object.controllerClass && controllerIdentifier == object.controllerIdentifier
    }

}

final class DemoSectionController: IGListSectionController, IGListSectionType {

    var object: DemoItem?

    func numberOfItems() -> Int {
        return 1
    }

    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 55)
    }

    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: LabelCell.self, for: self, at: index) as! LabelCell
        cell.label.text = object?.name
        return cell
    }

    func didUpdate(to object: Any) {
        self.object = object as? DemoItem
    }

    func didSelectItem(at index: Int) {
        if let identifier = object?.controllerIdentifier {
            let storyboard = UIStoryboard(name: "Demo", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: identifier)
            controller.title = object?.name
            viewController?.navigationController?.pushViewController(controller, animated: true)
        } else if let controller = object?.controllerClass.init() {
            controller.title = object?.name
            viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }

}
