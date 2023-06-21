class Post {
  String post_id = '';
  String title = '';
  String content = '';
  String author_google_id = '';
  double longtitude = 0.0;
  double latitude = 0.0;

  Post(this.post_id, this.author_google_id, this.title, this.content,
      this.longtitude, this.latitude);

  Map toJson() => {
        'post_id': post_id,
        'author_google_id': author_google_id,
        'title': title,
        'content': content,
        'longtitude': longtitude,
        'latitude': latitude,
      };
}
