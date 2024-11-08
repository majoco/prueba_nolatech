class BookModel {
  final int? bookId;
  final int canchaId;
  final int userId;
  final String fecha;
  final String horaInicio;
  final String horaFin;
  final String createdAt;

  const BookModel(
      {this.bookId,
      required this.canchaId,
      required this.userId,
      required this.fecha,
      required this.horaInicio,
      required this.horaFin,
      required this.createdAt});

  factory BookModel.fromMap(Map<String, dynamic> json) => BookModel(
      bookId: json["bookId"],
      canchaId: json["canchaId"],
      userId: json["userId"],
      fecha: json["fecha"],
      horaInicio: json["horaInicio"],
      horaFin: json["horaFin"],
      createdAt: json["createdAt"]);

  Map<String, dynamic> toMap() => {
        "bookId": bookId,
        "canchaId": canchaId,
        "userId": userId,
        "fecha": fecha,
        "horaInicio": horaInicio,
        "horaFin": horaFin,
        "createdAt": createdAt
      };
}
