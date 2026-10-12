class ArticleModel {
  const ArticleModel({
    required this.id,
    required this.title,
    required this.author,
    required this.readTime,
    required this.views,
    required this.date,
    required this.content,
    required this.imageUrl,
    this.isLiked = false,
    this.likesCount = 50,
  });

  final String id;
  final String title;
  final String author;
  final String readTime;
  final String views;
  final String date;
  final String content;
  final String imageUrl;
  final bool isLiked;
  final int likesCount;

  ArticleModel copyWith({
    String? id,
    String? title,
    String? author,
    String? readTime,
    String? views,
    String? date,
    String? content,
    String? imageUrl,
    bool? isLiked,
    int? likesCount,
  }) => ArticleModel(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author ?? this.author,
    readTime: readTime ?? this.readTime,
    views: views ?? this.views,
    date: date ?? this.date,
    content: content ?? this.content,
    imageUrl: imageUrl ?? this.imageUrl,
    isLiked: isLiked ?? this.isLiked,
    likesCount: likesCount ?? this.likesCount,
  );
}
