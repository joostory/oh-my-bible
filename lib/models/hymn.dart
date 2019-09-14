
class Hymn {
  String version;
  String type;
  int number;
  String title;

  Hymn({
    this.version,
    this.type,
    this.number,
    this.title
  });

  static Hymn fromMap(Map<String, dynamic> item) {
    return Hymn(
        version: item['version'],
        type: item['type'],
        number: item['number'],
        title: item['title'],
    );
  }
}