class AppConfig {
  int? version;
  String? apiKey;
  bool? isLegalFilterEnabled;
  List<String>? filterKeywords;

  AppConfig(
      {this.version,
      this.apiKey,
      this.isLegalFilterEnabled,
      this.filterKeywords});

  AppConfig.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    apiKey = json['apiKey'];
    isLegalFilterEnabled = json['isLegalFilterEnabled'];
    filterKeywords = json['filterKeywords'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    data['apiKey'] = apiKey;
    data['isLegalFilterEnabled'] = isLegalFilterEnabled;
    data['filterKeywords'] = filterKeywords;
    return data;
  }
}
