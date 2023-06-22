class Post {
  String post_id = '';
  String title = '';
  String content = '';
  String author_google_id = '';
  double longitude = 0.0;
  double latitude = 0.0;

  Post(this.post_id, this.author_google_id, this.title, this.content,
      this.longitude, this.latitude);

  Map toJson() => {
        'post_id': post_id,
        'author_google_id': author_google_id,
        'title': title,
        'content': content,
        'longitude': longitude.toString(),
        'latitude': latitude.toString(),
      };
}
