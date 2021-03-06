// Copyright (c) 2017 Lighthouse Labs. All rights reserved.
// 
// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
// distribute, sublicense, create a derivative work, and/or sell copies of the
// Software in any work that is designed, intended, or marketed for pedagogical or
// instructional purposes related to programming, coding, application development,
// or information technology.  Permission for such use, copying, modification,
// merger, publication, distribution, sublicensing, creation of derivative works,
// or sale is expressly withheld.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class FamousPeopleViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var peopleArray: [[String: String]]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let databaseManager = DatabaseManager()
    databaseManager.openDatabase()
    peopleArray = databaseManager.getAllPeople(withNameLike: "Kennedy")
  }
  
  func searchForPeople(withName name: String) {
    print("search for people with name: \(name)")
  }
  
}

extension FamousPeopleViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (peopleArray?.count)!
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
//    ToDoTableViewCell *toDoCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    ToDo *toDoObject = self.toDoObjects[indexPath.row];
//
//    toDoCell.titleLabel.text = toDoObject.title;
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    let personDict = peopleArray![indexPath.row]
    let personName = personDict["first_name"]
    
    cell?.textLabel?.text = personName
    
    return cell!
  }
}

extension FamousPeopleViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    guard let name = searchBar.text else {
      return
    }
    searchForPeople(withName: name)
  }
}
