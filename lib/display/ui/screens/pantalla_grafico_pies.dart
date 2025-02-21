import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:visualizador_charts/data/models/pie_model.dart';
import 'package:visualizador_charts/data/repositories/pie_repository.dart';
import 'package:visualizador_charts/display/ui/components/input_grafico.dart';
import 'package:visualizador_charts/display/ui/utils/utils.dart';

class PantallaGraficoPies extends StatefulWidget {
  const PantallaGraficoPies({super.key});

  @override
  State<PantallaGraficoPies> createState() => _PantallaGraficoPiesState();
}

class _PantallaGraficoPiesState extends State<PantallaGraficoPies> {
  final _identificadorFormulario = GlobalKey<FormState>();
  final _etiquetaTextController = TextEditingController();
  final _valorTextController = TextEditingController();
  int touchedIndex = 0;

  PieModel? _pieModel;

  @override
  void initState() {
    super.initState();
    setState(() {
      _pieModel = pieRepository.obtenerDatosFracciones();
    });
  }

  Widget build(BuildContext context) {
    if (_pieModel == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Grafico de Pies'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 180,
              child: (_pieModel!.etiqueta.isNotEmpty)
                  ? _pieChartOk()
                  : Text('No existe datos a mostrar'),
            ),
          ),
          Form(
            key: _identificadorFormulario,
            child: Column(
              spacing: 8,
              children: [
                InputGrafico(
                  label: 'Etiqueta',
                  autocorrect: false,
                  textInputType: TextInputType.number,
                  controller: _etiquetaTextController,
                  validator: (valor) {
                    return ValidacionDeData.validarCampoObligatorio(valor);
                  },
                ),
                InputGrafico(
                  label: 'Valor',
                  autocorrect: false,
                  textInputType: TextInputType.number,
                  controller: _valorTextController,
                  validator: (valor) {
                    return ValidacionDeData.validarNumero(valor);
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final esValido =
                        _identificadorFormulario.currentState?.validate();
                    final pieModel = _pieModel;
                    if (esValido == true && pieModel != null) {
                      setState(() {
                        pieModel.etiqueta.add(_etiquetaTextController.text);
                        pieModel.valor
                            .add(double.parse(_valorTextController.text));
                      });

                      pieRepository.guardarFraccionesDatos(pieModel);
                    }
                  },
                  label: const Text('Agregar'),
                  icon: Icon(Icons.add),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Alertas.mostrarAlertaDeConfirmacion(context,
                        alBorrar: (ctx) {
                      final pieModel = _pieModel;
                      if (pieModel != null) {
                        setState(() {
                          pieModel.etiqueta.removeLast();
                          pieModel.valor.removeLast();
                        });

                        pieRepository.guardarFraccionesDatos(pieModel);

                        Navigator.pop(ctx);
                      }
                    });
                  },
                  label: const Text('Borrar último'),
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  PieChart _pieChartOk() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 0,
        sections: showingSections(),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return _pieModel!.valor.asMap().entries.map((elemento) {
      final isTouched = elemento.key == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        color: Colors.blue,
        value: 40,
        title: '40%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
    _etiquetaTextController.dispose();
    _valorTextController.dispose();
  }
}
