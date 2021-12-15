//
//  CreatePostViewController.swift
//  Facebook
//
//  Created by 김우성 on 2021/12/15.
//

import UIKit

class CreatePostViewController<View: CreatePostView>: UIViewController {

    override func loadView() {
        view = View()
    }
    
    var creatPostView: View {
        guard let view = view as? View else { return View() }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
