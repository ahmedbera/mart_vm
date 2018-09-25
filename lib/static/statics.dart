import 'package:mart_vm/static/genres.dart';
import 'package:mart_vm/static/licenseOptions.dart';
import 'package:mart_vm/static/filterOptions.dart';
import 'package:mart_vm/static/typeOptions.dart';
import 'package:mart_vm/models/options.dart';

class Statics {
  static List<LicenseOption> licenseOptions = licenseOptionsMap;
  static List<String> genreList = genres;
  static List<FilterOption> filterOptions = filterOptionsList;
  static List<TypeOption> typeOptions = typeOptionsList;
}