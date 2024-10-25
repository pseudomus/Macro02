import SwiftUI

struct NumberOfErrorsComponent: View {
    
    @Binding var numberOfErrors: Int
    
    var body: some View {
        NumberOfErrorsText()
    }
    
    // Use a computed property for the text
    private func NumberOfErrorsText() -> some View {
        Text("\(numberOfErrors) \(numberOfErrors == 1 ? "erro" : "erros")")
            .padding(10)
            .background(numberOfErrors > 0 ? Color.red : Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    NumberOfErrorsComponent(numberOfErrors: .constant(1))
}

