import SwiftUI

struct PostHeader: View {
    let post: Post
    var contentMode: ContentMode = .fit

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            if let path = post.imagePath {
                HStack {
                    Spacer()

                    AsyncImage(url: .image(path: path), content: {
                        $0
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }, placeholder: { Color.accentColor })
                    .cornerRadius(12)
                    .frame(maxWidth: 200)

                    Spacer()
                }
            }

            Text(post.title)
                .foregroundColor(post.color == nil ? .black : .white)
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)

            Text("Posted on \(DateFormatter.humanReadable.string(from: post.date))")
                .font(.headline)
                .foregroundColor(.accentColor)

            Text("\(post.readingTime) min to read")
                .font(.headline)
                .foregroundColor(.accentColor)
            
        }
        .readableGuidePadding()
        .padding(.vertical)
        .background(post.color.flatMap(Color.init(hex:)) ?? Color.white)

    }
}

struct PostHeader_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
