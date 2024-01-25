
import SwiftUI
import Combine

struct SuffixesView: View {
    @State var suffixText: String = .init()
    @State var suffixArray: Suffixes = .init()
    @State var sort: Suffixes.Sort = .Asc
    @State var listMode: ListMode = .all
    @State var searchText: String = .init()
    @State var debouncedSearchText: String = .init()
    @State var dataArray: [(String, Int)] = .init()
    @FocusState var isFocused: Bool
    let searchTextPublisher = PassthroughSubject<String, Never>()
    
    let width: CGFloat = 100
    
    var body: some View {
        ZStack {
            Color.darkGray
                .ignoresSafeArea()
            
            VStack {
                title
                textField
                Spacer()
                countLabels
                
                PickerView(listMode: $listMode)
                
                switch listMode {
                case .all:
                    listViewAll
                case .top10Triple:
                    top10Triple
                }
            }
        }
        .animation(.easeInOut, value: listMode)
        .onChange(of: suffixText) { newValue in
            suffixArray = Suffixes(text: newValue)
            Task {
                dataArray = await suffixArray.getSorted(sort, search: debouncedSearchText)
            }
        }
        .onChange(of: searchText, perform: { newValue in
            searchTextPublisher.send(newValue)
        })
        .onReceive(
            searchTextPublisher
                .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
        ) { receive in
            debouncedSearchText = receive
            Task {
                dataArray = await suffixArray.getSorted(sort, search: debouncedSearchText)
            }
        }
        .onAppear{
            UITextField.appearance().clearButtonMode = .whileEditing
        }
        
    }
    
    @ViewBuilder
    var title: some View {
        Text("Suffix Array")
            .font(.largeTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    @ViewBuilder
    var textField: some View {
        TextField("type text...",
                  text: Binding(
                                          get: { suffixText },
                                          set:
                                              { (newValue, _) in
                                                  if let _ = newValue.lastIndex(of: "\n") {
                                                      isFocused = false
                                                  } else {
                                                      suffixText = newValue
                                                  }
                                              }
                                        ), axis: .vertical)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .submitLabel(.return)
            .foregroundColor(.black)
            .padding()
            .font(.system(size: 24, weight: .light))
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .shadow(radius: 0.9)
            )
            .padding(.horizontal)
            .focused($isFocused)
            
    }
    
    @ViewBuilder
    var countLabels: some View {
        Group {
            labelWith(title: "All suffixes:", value: suffixArray.allCount)
            labelWith(title: "Unique suffixes:", value: suffixArray.uniqueCount)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    func labelWith(title: String, value: Int) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.black.opacity(0.6))
                .font(.title3)
            Text(value > 0 ? "\(value)" : "_")
        }
        .font(.title2)
    }
    
    @ViewBuilder
    var listViewAll: some View {
        
        let max = suffixArray.max
 
        VStack {
            ScrollView {
                
                if suffixText.isEmpty {
                    Text("No data")
                        .font(.callout)
                } else {
                    HStack(spacing: 0) {
                        
                        Button {
                            sort.toogle()
                        } label: {
                            Image(systemName: "cellularbars")
                                .rotationEffect(.degrees(sort == .Asc ? 90 : 270))
                                .scaleEffect(x: sort == .Asc ? 1 : -1, y: 1, anchor: .center)
                        }
                        .font(.title3)
                        .foregroundColor(.green)
                        .padding(.leading, 14)
                        
                        RoundedRectangle(cornerRadius: 52)
                            .fill(Color.lightGray)
                            .frame(height: 50)
                            .shadow(radius: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 52)
                                    .stroke()
                                    .fill(.gray)
                            )
                           
                            .overlay {
                                HStack(spacing: 0) {
                                    Image(systemName: "magnifyingglass.circle")
                                        .font(.title)
                                        .padding(.leading, 6)
                                    TextField("search", text: $searchText)
                                        .textFieldStyle(.plain)
                                        .padding(.horizontal, 4)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .padding(.trailing, 24)
                                }
                                .padding(.leading)
                            }
                            .padding()
                        
                    }
                    
                    if dataArray.isEmpty {
                        Text("No filtered data")
                            .font(.callout)
                    } else {
                        VStack(spacing: 4) {
                            ForEach(dataArray, id: \.self.0) {suffix in
                                
                                let w = Double(suffix.1) / Double(max) * width
                                
                                HStack {
                                    Text(suffix.0)
                                        .font(.title3)
                                    Spacer()
                                    HStack {
                                        Capsule()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(maxWidth: w, alignment: .trailing)
                                            .padding(.trailing, 4)
                                        
                                        Text("\(suffix.1)")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
            .background(Color.lightGray)
        }
    }
    
    @ViewBuilder
    var top10Triple: some View {
        let max = suffixArray.max
        
        ScrollView {
            VStack(spacing: 4) {
                ForEach(suffixArray.getTop10Triple(), id: \.0) { suffix in
                    
                    let w = Double(suffix.1) / Double(max) * width

                    HStack {
                        Text(suffix.0)
                            .font(.title3)
                        Spacer()
                        HStack {
                            Capsule()
                                .fill(Color.gray.opacity(0.2))
                                .frame(maxWidth: w, alignment: .trailing)
                                .padding(.trailing, 4)

                            Text("\(suffix.1)")
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.top)
        .background(Color.lightGray)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SuffixesView()
    }
}
