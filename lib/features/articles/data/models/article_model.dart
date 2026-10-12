class ArticleModel {
  const ArticleModel({
    required this.title,
    required this.imageUrl,
    required this.views,
    required this.publishedAt,
    required this.body,
  });

  final String title;
  final String imageUrl;
  final String views;
  final String publishedAt;
  final String body;
}
