
import 'package:html/parser.dart';

parseSeriesStatsPage(response) {
  var document = parse(response).body;
  List<StatItem> statsList = [];

  document.querySelectorAll('#main_content table table tr').forEach((row){
    try {
      StatItem statItem = new StatItem();
      statItem.change = row.querySelector('.stat1').text.trim();
      statItem.rank = row.querySelector('.stat2').text.trim();
      statItem.title = row.querySelector('.stat3 a u').text.trim();
      statItem.muId = row.querySelector('.stat3 a').attributes['href'].split('=').last;
      statItem.genres =  row.querySelector('.stat3 i') == null ? null: row.querySelector('.stat3 i').text.trim();
      statsList.add(statItem);
    } catch (e) {}
  });

  return statsList;
}

class StatItem {
  String title;
  String muId;
  String genres;
  String rank;
  String change;
}