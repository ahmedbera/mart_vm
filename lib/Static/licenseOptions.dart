List<LicenseOption> licenseOptionsMap = [
  new LicenseOption("Show all licensed/unlicensed manga", null),
  new LicenseOption("Show only licensed manga", true),
  new LicenseOption("Show only unlicensed manga", false)
];

class LicenseOption {
  String label;
  bool value;

  LicenseOption(this.label, this.value);
}

