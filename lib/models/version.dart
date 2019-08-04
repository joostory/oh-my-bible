
class Version {
  String vcode;
  String name;

  Version({
    this.vcode,
    this.name
  });

  static fromMap(Map<String, String> item) {
    return new Version(
      vcode: item['vcode'],
      name: item['name']
    );
  }
}