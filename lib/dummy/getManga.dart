import 'dart:io';

getMangaHtml() {
  final file = new File('lib/dummy/mangaPage.txt');
  var html = file.readAsStringSync();
  return html;
}
