class PieModel {
  final List<String> etiqueta;
  final List<double> valor;

  PieModel({required this.etiqueta, required this.valor});

  factory PieModel.convertirDeDataLocal(
      ({List<String> datosEjeX, List<String> datosEjeY}) data) {
    final fraccionesDatosEjeX = data.datosEjeX;
    final fraccionesDatosEjeY = data.datosEjeY.map((elemento) {
      return double.parse(elemento);
    }).toList();

    return PieModel(etiqueta: fraccionesDatosEjeX, valor: fraccionesDatosEjeY);
  }
}
