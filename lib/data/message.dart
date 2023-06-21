class Message {
  String? id;
  double? long;
  double? lat;
  bool? readable;

  Message(this.id, this.long, this.lat, this.readable);

  Map toJson() => {'id': id, 'long': long, 'lat': lat, 'readable': readable};
}
