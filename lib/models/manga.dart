import 'package:mart_vm/models/genericLink.dart';
import 'package:mart_vm/models/listInfo.dart';

class Manga {
  String title;
  String type;
  String imgUrl;
  String description;
  String status;
  String year;
  String lastUpdated;
  
  bool scanlated;
  bool licensed = false;

  List<String> associatedNames = [];
  
  List<Map> latestReleases = [];
  UserRating score;
  List<GenericLink> genres = [];
  List<GenericLink> tags = [];
  List<GenericLink> authors = [];
  List<GenericLink> artists = [];
  List<GenericLink> groupsScanlating = [];
  List<GenericLink> categoryRecommendations = [];
  List<GenericLink> recommendations = [];
  GenericLink originalPublisher;
  GenericLink englishPublisher;
  List<GenericLink> categories = [];

  ListInfo listInfo = new ListInfo();

  String id;
}

class UserRating {
  String voters;
  String average;
  String bayesianAverage;
  List<Map> distribution = [];
}