
class Bible {
  String vcode;
  int bcode;
  String type;
  String name;
  int chapterCount;

  Bible({
    this.vcode,
    this.bcode,
    this.type,
    this.name,
    this.chapterCount
  });

  String getTypeLabel() {
    return type == 'old'? '구약' : '신약';
  }

  static Bible fromMap(Map<String, dynamic> item) {
    return Bible(
      vcode: item['vcode'],
      bcode: item['bcode'],
      type: item['type'],
      name: item['name'],
      chapterCount: item['chapter_count']
    );
  }
}
