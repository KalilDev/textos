class Author {
  Author({this.authorName, this.title, this.tags, this.authorID, this.canEdit = false});

  factory Author.fromFirestore(Map<String, dynamic> data, {String authorID, String currentUID}) {
    
    return Author(
        authorName: data['authorName'],
        title: data['title'],
        tags: List<String>.from(data['tags']),
        authorID: authorID,
        canEdit: currentUID == authorID);
  }

  final String authorName;
  final String title;
  final List<String> tags;
  final String authorID;
  final bool canEdit;
}
