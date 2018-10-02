class UserList {
  List<UserListItem> list = [];
  List otherLists = [];
  String type;
  String totalChapters;
}

class UserListItem {
  String muId;
  String title;
  String newestChapter;
  String readVolumes;
  String readChapters;
  String average;
  String userRating;
  String dateChanged;
}