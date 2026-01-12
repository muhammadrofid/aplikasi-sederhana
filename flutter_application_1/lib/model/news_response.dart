class NewsResponse {
  final String? status;
  final int? totalResults;
  final List<Articles>? articles;
  final String? message;
  final String? code;

  NewsResponse({
    this.status,
    this.totalResults,
    this.articles,
    this.message,
    this.code,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    try {
      return NewsResponse(
        status: json['status'] as String?,
        totalResults: json['totalResults'] as int?,
        message: json['message'] as String?,
        code: json['code'] as String?,
        articles: json['articles'] != null
            ? (json['articles'] as List).map((item) {
                return Articles.fromJson(item as Map<String, dynamic>);
              }).toList()
            : null,
      );
    } catch (e) {
      print('Error parsing NewsResponse: $e');
      print('JSON received: $json');
      return NewsResponse(
        status: 'error',
        message: 'Failed to parse response: $e',
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['totalResults'] = totalResults;
    data['message'] = message;
    data['code'] = code;
    if (articles != null) {
      data['articles'] = articles!.map((x) => x.toJson()).toList();
    }
    return data;
  }

  static fromJsonDecode(String body) {}
}

class Articles {
  final Source? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  Articles({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Articles.fromJson(Map<String, dynamic> json) {
    return Articles(
      source: json['source'] != null
          ? Source.fromJson(json['source'] as Map<String, dynamic>)
          : null,
      author: json['author'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (source != null) {
      data['source'] = source!.toJson();
    }
    data['author'] = author;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['urlToImage'] = urlToImage;
    data['publishedAt'] = publishedAt;
    data['content'] = content;
    return data;
  }
}

class Source {
  final String? id;
  final String? name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}