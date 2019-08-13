
class Verse {
  String vcode;
  int bcode;
  int cnum;
  int vnum;
  String content;

  Verse({this.vcode, this.bcode, this.cnum, this.vnum, this.content});

  static Verse fromMap(Map<String, dynamic> item) {
    return Verse(
      vcode: item['vcode'],
      bcode: item['bcode'],
      cnum: item['cnum'],
      vnum: item['vnum'],
      content: item['content']
    );
  }
}
