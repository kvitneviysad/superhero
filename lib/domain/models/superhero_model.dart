// lib/domain/models/superhero_model.dart
import 'package:flutter/foundation.dart';

class Powerstats {
  final String intelligence;
  final String strength;
  final String speed;
  final String durability;
  final String power;
  final String combat;

  const Powerstats({
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
  });

  static int parseStat(String? val) {
    if (val == null || val == 'null') return 0;
    return int.tryParse(val) ?? 0;
  }

  factory Powerstats.fromJson(Map<String, dynamic> json) => Powerstats(
    intelligence: json['intelligence']?.toString() ?? '0',
    strength:     json['strength']?.toString()     ?? '0',
    speed:        json['speed']?.toString()         ?? '0',
    durability:   json['durability']?.toString()   ?? '0',
    power:        json['power']?.toString()         ?? '0',
    combat:       json['combat']?.toString()        ?? '0',
  );

  Map<String, dynamic> toJson() => {
    'intelligence': intelligence,
    'strength':     strength,
    'speed':        speed,
    'durability':   durability,
    'power':        power,
    'combat':       combat,
  };
}

class Biography {
  final String fullName;
  final String alterEgos;
  final String placeOfBirth;
  final String firstAppearance;
  final String publisher;
  final String alignment;

  const Biography({
    required this.fullName,
    required this.alterEgos,
    required this.placeOfBirth,
    required this.firstAppearance,
    required this.publisher,
    required this.alignment,
  });

  factory Biography.fromJson(Map<String, dynamic> json) => Biography(
    fullName:        json['full-name']        ?? '-',
    alterEgos:       json['alter-egos']        ?? '-',
    placeOfBirth:    json['place-of-birth']    ?? '-',
    firstAppearance: json['first-appearance']  ?? '-',
    publisher:       json['publisher']         ?? '-',
    alignment:       json['alignment']         ?? '-',
  );

  Map<String, dynamic> toJson() => {
    'full-name':        fullName,
    'alter-egos':       alterEgos,
    'place-of-birth':   placeOfBirth,
    'first-appearance': firstAppearance,
    'publisher':        publisher,
    'alignment':        alignment,
  };
}

class Appearance {
  final String gender;
  final String race;
  final List<String> height;
  final List<String> weight;
  final String eyeColor;
  final String hairColor;

  const Appearance({
    required this.gender,
    required this.race,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hairColor,
  });

  factory Appearance.fromJson(Map<String, dynamic> json) => Appearance(
    gender:    json['gender']?.toString() ?? '-',
    race:      json['race']?.toString()   ?? '-',
    height:    List<String>.from(json['height'] ?? ['-']),
    weight:    List<String>.from(json['weight'] ?? ['-']),
    eyeColor:  json['eye-color']?.toString() ?? '-',
    hairColor: json['hair-color']?.toString() ?? '-',
  );

  Map<String, dynamic> toJson() => {
    'gender':     gender,
    'race':       race,
    'height':     height,
    'weight':     weight,
    'eye-color':  eyeColor,
    'hair-color': hairColor,
  };
}

class Work {
  final String occupation;
  final String base;

  const Work({required this.occupation, required this.base});

  factory Work.fromJson(Map<String, dynamic> json) => Work(
    occupation: json['occupation'] ?? '-',
    base:       json['base']       ?? '-',
  );

  Map<String, dynamic> toJson() => {'occupation': occupation, 'base': base};
}

class HeroImage {
  final String url;
  const HeroImage({required this.url});

  factory HeroImage.fromJson(Map<String, dynamic> json) {
    String rawUrl = json['url'] ?? '';
    // Fix: Замінюємо http на https для стабільного завантаження та уникнення cleartext блокування
    if (rawUrl.startsWith('http://')) {
      rawUrl = rawUrl.replaceFirst('http://', 'https://');
    }
    return HeroImage(url: rawUrl);
  }

  Map<String, dynamic> toJson() => {'url': url};
}

// ── Main model ────────────────────────────────────────────────

class SuperheroModel {
  final int id;
  final String name;
  final HeroImage image;
  final Powerstats powerstats;
  final Biography biography;
  final Appearance appearance;
  final Work work;

  const SuperheroModel({
    required this.id,
    required this.name,
    required this.image,
    required this.powerstats,
    required this.biography,
    required this.appearance,
    required this.work,
  });

  factory SuperheroModel.fromJson(Map<String, dynamic> json) {
    debugPrint('[Model] id=${json['id']} name=${json['name']} image=${json['image']}');

    return SuperheroModel(
      id:         int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name:       json['name'] ?? 'Unknown',
      image:      HeroImage.fromJson(json['image'] ?? {}),
      powerstats: Powerstats.fromJson(json['powerstats'] ?? {}),
      biography:  Biography.fromJson(json['biography'] ?? {}),
      appearance: Appearance.fromJson(json['appearance'] ?? {}),
      work:       Work.fromJson(json['work'] ?? {}),
    );
  }


  Map<String, dynamic> toJson() => {
    'id':         id.toString(),
    'name':       name,
    'image':      image.toJson(),
    'powerstats': powerstats.toJson(),
    'biography':  biography.toJson(),
    'appearance': appearance.toJson(),
    'work':       work.toJson(),
  };
}
