class Item {
  final int id;
  final String type; 
  final String title;
  final String author; 
  final String imageUrl;
  final String summary;
  final String publishedAt;
  final String url;

  Item({
    required this.id,
    required this.type,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.summary,
    required this.publishedAt,
    required this.url,
  });

  factory Item.fromApi(Map<String, dynamic> json, String type) {
    return Item(
      id: json['id'],
      type: type,
      title: json['title'] ?? '',
      author: json['news_site'] ?? '',
      imageUrl: json['image_url'] ?? '',
      summary: json['summary'] ?? '',
      publishedAt: json['published_at'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'summary': summary,
      'publishedAt': publishedAt,
      'url': url,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      type: map['type'],
      title: map['title'],
      author: map['author'],
      imageUrl: map['imageUrl'],
      summary: map['summary'],
      publishedAt: map['publishedAt'],
      url: map['url'],
    );
  }
}