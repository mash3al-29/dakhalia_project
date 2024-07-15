class OrchardModel {
  final int id;
  final String crop;
  final int feddans;
  final int mm;
  final String pestState;

  OrchardModel({
    required this.id,
    required this.crop,
    required this.feddans,
    required this.mm,
    required this.pestState,
  });

  factory OrchardModel.fromJson(Map<String, dynamic> json) {
    return OrchardModel(
      id: json['id'],
      crop: json['crop'],
      feddans: json['feddans'],
      mm: json['mm'],
      pestState: json['pestState'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'crop': crop,
      'feddans': feddans,
      'mm': mm,
      'pestState': pestState,
    };
  }
}
