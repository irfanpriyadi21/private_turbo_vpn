class ModelConfig {
  bool? status;
  String? config;

  ModelConfig({this.status, this.config});

  ModelConfig.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    config = json['config'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['config'] = this.config;
    return data;
  }
}
