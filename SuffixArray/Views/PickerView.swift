
import SwiftUI

struct PickerView: View {
    
    @Binding var listMode: ListMode
    
    @Namespace var animation
    var body: some View {
        HStack {
            ForEach(ListMode.allCases, id: \.hashValue) { mode in
                PickerItem(isSelected: listMode, caption: mode.description, namespace: animation)
                    .onTapGesture {
                        listMode = mode
                    }
                    .transition(.slide)
                    .animation(.default, value: listMode)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct PickerItem: View {
    var isSelected: ListMode
    var caption: String
    let namespace: Namespace.ID
    
    var body: some View {
        Text(caption)
            .padding(16)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background{
                if isSelected.description == caption {
                    Color.green
                        .clipShape(Capsule())
                        .matchedGeometryEffect(id: "picker", in: namespace)
                } else {
                    Color.lightGray
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
    }
}
