import 'package:html/parser.dart';
import 'package:mart_vm/models/searchResult.dart';

parseSearchResults(String response) {
  var document = parse(response).body;
  var results = [];
  var i = 0;
  document.querySelectorAll('#main_content div table tbody tr').forEach((tr) {
    if (tr.attributes['valign'] == null && i > 1) {
      try {
        results.add(new SearchResult(
          tr.querySelector(".text .col1").text?.trim(),
          tr.querySelector(".text .col2").text?.trim(),
          tr.querySelector(".text .col3").text?.trim(),
          tr.querySelector(".text .col4").text?.trim(),
          tr.querySelector("a[alt='Series Info']").attributes['href']));
      } catch (e) {}
    }
    i++;
  });
  return results;
}
