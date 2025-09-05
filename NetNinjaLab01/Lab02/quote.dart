class Quote {
  String text;
  String author;
  String category; // NEW
  int likes;

  Quote({
    required this.text,
    required this.author,
    required this.category,
    this.likes = 0,
  });
}
