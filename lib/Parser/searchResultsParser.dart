import 'package:html/parser.dart';
import 'package:mart_vm/Models/searchResult.dart';

parseSearchResults(String response) {
  var document = parse(response).body;
  var results = [];
  var i = 0;
  document.querySelectorAll('#main_content div table tbody tr').forEach((tr) {
    if (tr.attributes['valign'] == null && i > 1) {
      results.add(new SearchResult(
          tr.querySelector(".text .col1").text,
          tr.querySelector(".text .col2").text,
          tr.querySelector(".text .col3").text,
          tr.querySelector(".text .col4").text,
          tr.querySelector("a[alt='Series Info']").attributes['href']));
    }
    i++;
  });
  return results;
}
