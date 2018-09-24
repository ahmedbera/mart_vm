List<FilterOption> filterOptionsList = [
  new FilterOption("Show all manga", null),
  new FilterOption("Only show completely scanlated manga", "scanlated"),
  new FilterOption("Only show completed (including oneshots) manga", "completed"),
  new FilterOption("Only show one shots", "oneshots"),
  new FilterOption("Exclude one shots", "no_oneshots"),
  new FilterOption("Only show manga with at least one release", "some_releases"),
  new FilterOption("Only show manga with no releases", "no_releases")
];

class FilterOption {
  String label;
  String value;

  FilterOption(this.label, this.value);
}
