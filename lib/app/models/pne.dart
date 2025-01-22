enum PneType { visualImpairment, wheelchairUser, autistic, other, none }

String describePne(PneType type) {
  switch (type) {
    case PneType.visualImpairment:
      return 'Deficiente Visual';
    case PneType.wheelchairUser:
      return 'Cadeirante';
    case PneType.autistic:
      return 'Autista';
    case PneType.other:
      return 'Outros';
    case PneType.none:
      return 'Nenhum';
  }
}

class PNE {
  PneType type;
  PNE({required this.type});

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
    };
  }

  factory PNE.fromJson(Map<String, dynamic> json) {
    // Este método assume que 'none' será usado quando não houver dados específicos de PNE
    return PNE(
      type: PneType.values.firstWhere(
          (e) => e.toString() == 'PneType.${json['type']}',
          orElse: () => PneType.none),
    );
  }
}
