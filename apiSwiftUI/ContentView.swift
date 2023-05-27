//
//  ContentView.swift
//  apiSwiftUI
//
//  Created by Naman Dhiman on 27/05/23.
//

import SwiftUI


let getUrl = "https://jsonplaceholder.typicode.com/todos";
let postUrl = "https://jsonplaceholder.typicode.com/posts";

//Model
struct DataModel: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}


//Model
struct PostModel: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}


//ViewModel
class ViewModel: ObservableObject {
    @Published var items = [DataModel]()
    
    /// Get function to fetch the data from api
    func loadData(){
        
        guard let url = URL(string: getUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, res, error) in
            
            do{
                if let data = data {
                
                    let result = try JSONDecoder().decode([DataModel].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.items = result
                    }
                }else{
                    print("No data")
                }
            }catch (let error){
                print(error)
            }
        }.resume()
        
            }
    
    
    
    /// Get function to post the data
    func postData(){
        
        guard let url = URL(string: postUrl) else {return}
        
        
        let title = "foo"
        let bar = "Test"
        let userId = 1
        

        let body : [String : Any] = ["title":title, "body": bar, "userId":userId]
        
        let finalData = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            
            do{
                if let data = data {
                
                    let result = try JSONDecoder().decode(PostModel.self, from: data)
                   
                    print(result);
                    
                }else{
                    print("No data")
                }
            }catch (let error){
                print(error)
            }
        }.resume()
        
            }
    
    
        }


struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
   
    var body: some View {
        NavigationView{
            
            VStack{
                List(viewModel.items, id: \.id) { item in
         Text(item.title)

     }
            }.onAppear(perform: {
                viewModel.loadData()
                viewModel.postData()
            })
            .navigationTitle("Data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
