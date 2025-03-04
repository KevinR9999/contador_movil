import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String entrada = "0";
  String proceso = "";
  final formatter = NumberFormat('#,###', 'en_US');

  String formatResult(double result) {
    if (result % 1 == 0) {
      return formatter.format(result.toInt());
    } else {
      return NumberFormat('#,###.##', 'en_US').format(result);
    }
  }

  void calcularResultado() {
    try {
      String expresion = proceso.replaceAll('%', '/100').replaceAll(',', '');
      Parser p = Parser();
      Expression exp = p.parse(expresion);
      ContextModel cm = ContextModel();
      double resultado = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        entrada = formatResult(resultado);
      });
    } catch (e) {
      setState(() {
        entrada = "Error";
      });
    }
  }

  void onPressed(String valor) {
    setState(() {
      if (valor == "AC") {
        entrada = "0";
        proceso = "";
      } else if (valor == "⌫") {
        if (proceso.isNotEmpty) {
          proceso = proceso.substring(0, proceso.length - 1);
        }
      } else if (valor == "=") {
        calcularResultado();
      } else {
        if (valor == "%") {
          proceso += "%";
        } else if (valor == ",") {
          proceso += ",";
        } else {
          if (proceso.isEmpty && ["+", "-", "*", "/"].contains(valor)) {
            return;
          }
          proceso += valor;
        }
      }
    });
  }

  Widget boton(String valor, Color colorFondo, Color colorTexto) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => onPressed(valor),
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.all(24),
            backgroundColor: colorFondo,
          ),
          child: Text(valor, style: TextStyle(fontSize: 24, color: colorTexto)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      proceso,
                      style: TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                  ),
                  Text(
                    entrada,
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(children: [
                boton("AC", Colors.grey, Colors.black),
                boton("⌫", Colors.grey, Colors.black),
                boton("%", Colors.grey, Colors.black),
                boton("/", Colors.orange, Colors.white),
              ]),
              Row(children: [
                boton("7", Colors.grey[850]!, Colors.white),
                boton("8", Colors.grey[850]!, Colors.white),
                boton("9", Colors.grey[850]!, Colors.white),
                boton("*", Colors.orange, Colors.white),
              ]),
              Row(children: [
                boton("4", Colors.grey[850]!, Colors.white),
                boton("5", Colors.grey[850]!, Colors.white),
                boton("6", Colors.grey[850]!, Colors.white),
                boton("-", Colors.orange, Colors.white),
              ]),
              Row(children: [
                boton("1", Colors.grey[850]!, Colors.white),
                boton("2", Colors.grey[850]!, Colors.white),
                boton("3", Colors.grey[850]!, Colors.white),
                boton("+", Colors.orange, Colors.white),
              ]),
              Row(children: [
                boton("0", Colors.grey[850]!, Colors.white),
                boton(",", Colors.grey[850]!, Colors.white),
                boton("=", Colors.orange, Colors.white),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
