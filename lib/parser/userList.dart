import 'package:html/parser.dart';
import 'package:mart_vm/models/userList.dart';
import 'package:mart_vm/models/genericLink.dart';

parseUserList(String response) {
  var document = parse(response).body;

  UserList list = new UserList();

  RegExp intParser = RegExp(r'\d+');
  String totalChapterString = document.querySelector('.low_col1').text.trim();
  list.totalChapters = intParser.stringMatch(totalChapterString);
  if(list.totalChapters == "0") {
    return list;
  }

  // Dart please
  document.querySelector('p.text').querySelectorAll('a').forEach((link) {
    list.otherLists.add(
      new GenericLink(
        link.text.trim(), 
        link.attributes['href'].split("=")[1]
      )
    );
  });


  try {
    var img = document.querySelector('#list_image').attributes["src"];
    switch (intParser.stringMatch(img)) {
      case "0":
        list.type = "read";
        break;
      case "1":
        list.type = "wish";
        break;
      case "2":
        list.type = "complete";
        break;
      case "3":
        list.type = "unfinished";
        break;
      case "4":
        list.type = "onhold";
        break;
      default:
    }
  } catch (e) {}

  document.querySelectorAll('.lrow').forEach((row) {
    UserListItem userListItem = new UserListItem();

    userListItem.muId = row.id.substring(1);
    userListItem.title = row.querySelector('a > u').text.trim();
    try {
      userListItem.newestChapter = row.querySelector('.newlist > a').text.trim(); // try catch
    } catch (e) {}

    userListItem.userRating = row.querySelector('.lcol5').text.trim();
    userListItem.average = row.querySelector('.lcol6').text.trim();

    if(list.type == "read") {
      userListItem.readVolumes = row.querySelector('[title="Increment Volume"] b').text.trim();
      userListItem.readChapters = row.querySelector('[title="Increment Chapter"] b').text.trim();
    } else {
      try {
        userListItem.dateChanged = row.querySelector('.lcol4_top').text.trim();
      } catch (e) {}
    }

    list.list.add(userListItem);
  });

  return list;
}