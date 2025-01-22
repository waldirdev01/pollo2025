class FetchDataException implements Exception {
  final String message;

  FetchDataException(this.message);

  @override
  String toString() {
    return 'Erro ao buscar dados: $message';
  }
}
