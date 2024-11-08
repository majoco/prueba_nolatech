class CanchaModel {
  final int canchaId;
  final String canchaTitle;
  final String canchaType;
  final String canchaImagen;
  final String createdAt;

  const CanchaModel(
      {required this.canchaId,
      required this.canchaTitle,
      required this.canchaType,
      required this.canchaImagen,
      required this.createdAt});

  factory CanchaModel.fromMap(Map<String, dynamic> json) => CanchaModel(
      canchaId: json["canchaId"],
      canchaTitle: json["canchaTitle"],
      canchaType: json["canchaType"],
      canchaImagen: json["canchaImagen"],
      createdAt: json["createdAt"]);

  Map<String, dynamic> toMap() => {
        "canchaId": canchaId,
        "canchaTitle": canchaTitle,
        "canchaType": canchaType,
        "canchaImagen": canchaImagen,
        "createdAt": createdAt
      };
}
