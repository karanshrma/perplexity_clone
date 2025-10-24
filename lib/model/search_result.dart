class SearchResult {
  final String title;
  final String url;

  SearchResult({required this.title, required this.url});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
