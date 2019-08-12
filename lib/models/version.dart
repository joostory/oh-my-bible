
class Version {
  String vcode;
  String name;

  Version({
    this.vcode,
    this.name
  });

  static fromMap(Map<String, dynamic> item) {
    return new Version(
      vcode: item['vcode'].toString(),
      name: item['name'].toString()
    );
  }
}