class Manga {
  var title = "";
  var type = '';
  var imgUrl = null;
  var description = '';
  var status = '';
  bool scanlated;
  var genres = [];
  var tags = [];
  var authors = []; // { name: "", url : "" }
  var artists = []; // { name: "", url : "" }
  var year = '';
  var associatedNames = [];
  var groupsScanlating = [];
  var categoryRecommendations = [];
  var recommendations = [];
  var latestReleases = [];
  var originalPublisher;
  bool licensed = false;
  var englishPublisher;
  UserRating score;
  var lastUpdated;
  var categories = [];
}

class UserRating {
  var voters;
  var average;
  var bayesianAverage;
  var distribution = [];
}

class GenericLink {
  var name;
  var url;

  GenericLink(this.name, this.url);
}
