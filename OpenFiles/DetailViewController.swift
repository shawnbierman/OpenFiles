//
//  DetailViewController.swift
//  OpenFiles
//
//  Created by Shawn Bierman on 6/8/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var textview: UITextView!

    var file: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let documentsDirectoryURL = getDocumentsDirectoryURL()
        guard let file = file else { return }
        let path = documentsDirectoryURL.appendingPathComponent(file)

        do {
            let contents = try String(contentsOf: path, encoding: .utf8)
            textview.text = contents
        } catch {
            dump(error.localizedDescription)
        }
    }

    fileprivate func getDocumentsDirectoryURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectoryURL = urls[0]
        return documentsDirectoryURL
    }
}
