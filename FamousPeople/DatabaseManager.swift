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
import SQLite3

class DatabaseManager: NSObject {

  var database: OpaquePointer?
  
  func openDatabase() {
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("famous_people.db")
    
    let status = sqlite3_open(fileURL.path, &database)
    if status != SQLITE_OK {
      print("error opening database" )
    }
  }
  
  
  func closeDatabase() {
    let status = sqlite3_close(database)
    if status != SQLITE_OK {
      print("error closing database")
    }
  }
  
  func setupData() {
    let createPeople = """
      CREATE TABLE famous_people (
        id INTEGER PRIMARY KEY,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        birthdate VARCHAR(50)
        );

      INSERT INTO famous_people (first_name, last_name, birthdate)
        VALUES ('Chris', 'Dean', 'Oct 28, 1990'),('Mike', 'Smith', 'Oct 19, 1995'), ('John', 'Doe', 'Mar 28, 1970'),
    ('Fred', 'George', 'May 15, 2000'), ('Dan', 'Danger', 'FEb 28, 1990'), ('Kelly', 'Dean', 'Oct 7, 1990'),
    ('Hannah', 'Wilson', 'March 28, 1990'), ('Brian', 'Kennedy', 'Oct 28, 1990'), ('Cailyn', 'Kennedy', 'Oct 28, 1990'), ('Kiera', 'Kennedy', 'Oct 01, 2010');

  """

    let status = sqlite3_exec(database, createPeople, nil, nil, nil) // 2
    if status != SQLITE_OK { // 3
      let errmsg = String(cString: sqlite3_errmsg(database)!)
      print("error: \(errmsg)")
    }
  }
  
  func getAllPeople(withNameLike name: String) -> [[String: String]]? {
    
    let queryString = """
    SELECT first_name, last_name, birthdate
    FROM famous_people
    WHERE last_name LIKE '\(name)';
  """ // 1
    
    var queryStatement: OpaquePointer? = nil // 2
    let prepareStatus = sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil)
    
    guard prepareStatus == SQLITE_OK else { // 3
      let errmsg = String(cString: sqlite3_errmsg(database)!)
      print("perpare error: \(errmsg)")
      return nil
    }
    
    var stepStatus = sqlite3_step(queryStatement) // 4
    let numberOfColumns = sqlite3_column_count(queryStatement)
    
    var people = [[String: String]]() // 5
    
    while(stepStatus == SQLITE_ROW) { // 6
      var person = [String: String]()
      
      for i in 0..<numberOfColumns { // 7
        let columnName = String(cString: sqlite3_column_name(queryStatement, Int32(i)))
        let columnText = String(cString: sqlite3_column_text(queryStatement, Int32(i)))
        person[columnName] = columnText
      }
      
      people.append(person) // 8
      
      stepStatus = sqlite3_step(queryStatement) // 9
    }
    
    if stepStatus != SQLITE_DONE { // 10
      print("Error stepping")
    }
    
    let finalizeStatus = sqlite3_finalize(queryStatement) // 11
    if finalizeStatus != SQLITE_OK {
      print("Error finalizing")
    }
    
    return people // 12
  }
  
  func getAllPeople() -> [[String: String]]? {
    let queryString = """
    SELECT first_name, last_name, birthdate
    FROM famous_people;
  """ // 1
    
    var queryStatement: OpaquePointer? = nil // 2
    let prepareStatus = sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil)
    
    guard prepareStatus == SQLITE_OK else { // 3
      let errmsg = String(cString: sqlite3_errmsg(database)!)
      print("perpare error: \(errmsg)")
      return nil
    }
    
    var stepStatus = sqlite3_step(queryStatement) // 4
    let numberOfColumns = sqlite3_column_count(queryStatement)
    
    var people = [[String: String]]() // 5
    
    while(stepStatus == SQLITE_ROW) { // 6
      var person = [String: String]()
      
      for i in 0..<numberOfColumns { // 7
        let columnName = String(cString: sqlite3_column_name(queryStatement, Int32(i)))
        let columnText = String(cString: sqlite3_column_text(queryStatement, Int32(i)))
        person[columnName] = columnText
      }
      
      people.append(person) // 8
      
      stepStatus = sqlite3_step(queryStatement) // 9
    }
    
    if stepStatus != SQLITE_DONE { // 10
      print("Error stepping")
    }
    
    let finalizeStatus = sqlite3_finalize(queryStatement) // 11
    if finalizeStatus != SQLITE_OK {
      print("Error finalizing")
    }
    
    return people // 12
  }
  
  deinit {
    closeDatabase()
  }
  
}
