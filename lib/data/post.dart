class Post {
  String id = '';
  DateTime dateTime;
  String title = '';
  String message = '';
  String user = '';
  double longtitude = 0.0;
  double latitude = 0.0;

  Post(this.id, this.dateTime, this.title, this.message, this.user,
      this.longtitude, this.latitude);

  Map toJson() => {
        'id': id,
        'dateTime': dateTime,
        'title': title,
        'message': message,
        'user': user,
        'longtitude': longtitude,
        'latitude': latitude,
      };
}
