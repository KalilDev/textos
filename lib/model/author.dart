class Author {
  Author({this.authorName, this.title, this.tags, this.authorID});

  factory Author.fromFirestore(Map<String, dynamic> data, String authorID) {
    
    return Author(
        authorName: data['authorName'],
        title: data['title'],
        tags: List<String>.from(data['tags']),
        authorID: authorID);
  }

  final String authorName;
  final String title;
  final List<String> tags;
  final String authorID;
}
