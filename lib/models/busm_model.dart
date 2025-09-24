import 'package:equatable/equatable.dart';

class Busm extends Equatable {
  final DateTime? createdAt;
  final String english;
  final String input;
  final String kana;
  final String romaji;

  const Busm({
    required this.english,
    required this.input,
    required this.kana,
    required this.romaji,
    this.createdAt,
  });

  @override
  List<Object?> get props => [createdAt, english, input, kana, romaji];

  Busm copyWith(
    DateTime? createdAt,
    String? english,
    String? input,
    String? kana,
    String? romaji,
  ) {
    return Busm(
      createdAt: createdAt ?? this.createdAt,
      english: english ?? this.english,
      input: input ?? this.input,
      kana: kana ?? this.kana,
      romaji: romaji ?? this.romaji,
    );
  }

  factory Busm.fromJson(Map<String, dynamic> json) {
    DateTime? created =
        json['created'] != null ? DateTime.parse(json['createdAt']) : null;

    return Busm(
      createdAt: created,
      english: json['english'],
      input: json['input'],
      kana: json['kana'],
      romaji: json['romaji'],
    );
  }

  Map<String, dynamic> toJson() {
    DateTime created = createdAt ?? DateTime.now();

    return {
      'createdAt': created.toIso8601String(),
      'english': english,
      'input': input,
      'kana': kana,
      'romaji': romaji,
    };
  }

  static const emptyBusm = Busm(english: '', input: '', kana: '', romaji: '');
}
