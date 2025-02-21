import 'package:visualizador_charts/data/data_sources/local_data_source.dart';
import 'package:visualizador_charts/data/models/pie_model.dart';

class PieRepository {
  final LocalDataSource localDataSource;
  final tipoChart = TipoChart.pie;

  PieRepository({required this.localDataSource});

  PieModel obtenerDatosFracciones() {
    final franccionesDatos = localDataSource.obtenerDatos(tipoChart);

    return PieModel.convertirDeDataLocal(franccionesDatos);
  }

  void guardarFraccionesDatos(PieModel pieModel) async {
    await localDataSource.setEjeX(data: pieModel.etiqueta, tipo: tipoChart);
    await localDataSource.setEjeY(
      data: pieModel.valor.map((elemento) {
        return elemento.toString();
      }).toList(),
      tipo: tipoChart,
    );
  }
}

final pieRepository = PieRepository(localDataSource: localDataSource);
