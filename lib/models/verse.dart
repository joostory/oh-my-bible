
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

class SearchVerse extends Verse {
  String bibleName;

  SearchVerse({
    vcode,
    bcode,
    cnum,
    vnum,
    content,
    this.bibleName
  }): super(
        vcode: vcode,
        bcode: bcode,
        cnum: cnum,
        vnum: vnum,
        content: content
      );


  static SearchVerse fromMap(Map<String, dynamic> item) {
    return SearchVerse(
      vcode: item['vcode'],
      bcode: item['bcode'],
      cnum: item['cnum'],
      vnum: item['vnum'],
      content: item['content'],
      bibleName: item['bibleName']
    );
  }
}