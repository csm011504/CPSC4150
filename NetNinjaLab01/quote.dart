class Quote {
  String text;
  String author;
  int likes;

  Quote({
    required this.text,
    required this.author,
    this.likes = 0,
  });
}
