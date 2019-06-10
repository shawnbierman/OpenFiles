//
//  ViewController.swift
//  OpenFiles
//
//  Created by Shawn Bierman on 6/3/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    var dataSource = ObjectDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = dataSource

        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFiles()
    }

    @objc fileprivate func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
            documentPicker.delegate = self as UIDocumentPickerDelegate
            documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }

    fileprivate func getDocumentsDirectoryURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0]
        return documentsDirectory
    }

    fileprivate func loadFiles() {
        let documentsDirectoryURL = getDocumentsDirectoryURL()
        let path = documentsDirectoryURL.path

        do {
            let fm = FileManager.default
            dataSource.objects = try fm.contentsOfDirectory(atPath: path)

            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        } catch {
            dump(error.localizedDescription)
        }
    }

    fileprivate func setupNavigationBar() {
        let importButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentDocumentPicker))
        let barButtons = [importButton]

        navigationItem.rightBarButtonItems = barButtons
    }
}

// MARK: - UIDocumentPicker methods
extension ViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        guard let url = urls.first else { return } // url of picked file

        let documentsDirectoryURL = getDocumentsDirectoryURL()
        let sandboxURL = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
//        print("URL: \(url)")                                    // URL to original file
//        print("DOCSDIR: \(documentsDirectoryURL)")              // documents directory
//        print("SANDBOXURL: \(sandboxURL)")                      // a URL format to file in docsdir
//        print("SANDBOXURLPATH: \(sandboxURL.path)")             // filesystem path format of above
//        print("SANDBOXURLLASTPATHCOMPONENT: \(sandboxURL.lastPathComponent)")   // just filename
        let fm = FileManager.default

        if fm.fileExists(atPath: sandboxURL.path) {
            let ac = UIAlertController(title: "File exists", message: sandboxURL.lastPathComponent, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            do {
                try fm.copyItem(at: url, to: sandboxURL)
                loadFiles()
            } catch {
                dump(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableView methods
extension ViewController {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource.objects[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {

            let file = dataSource.objects[indexPath.row]
            controller.file = file

            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
