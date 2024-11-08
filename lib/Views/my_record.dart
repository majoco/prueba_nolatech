import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_nolatech2/JsonModels/book_model.dart';
import 'package:flutter_nolatech2/JsonModels/cancha_model.dart';
import 'package:flutter_nolatech2/SQLite/sqlite.dart';

class MyRecord extends StatefulWidget {
  final CanchaModel cancha;
  const MyRecord({super.key, required this.cancha});

  @override
  MyRecordState createState() => MyRecordState();
}

class MyRecordState extends State<MyRecord> {
  final db = DatabaseHelper();

  final formKey = GlobalKey<FormState>();

  final fecha = TextEditingController();
  final horaInicio = TextEditingController();
  final horaFin = TextEditingController();

  String _selectedItem = '08:00';
  String _selectedItem2 = '08:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Reservar Cancha"),
        ),
        body: Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset(
                      widget.cancha.canchaImagen,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(widget.cancha.canchaTitle,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(widget.cancha.canchaType),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Disponible 7:00 am a 4:00 pm'),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Establecer Fecha y Hora",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Form(
                      //I forgot to specify key
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          color: const Color.fromRGBO(244, 247, 252, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                /*TextFormField(
                                            controller: canchaId,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Cancha is required";
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              label: Text("Cancha"),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: userId,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "User is required";
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              label: Text("User"),
                                            ),
                                          ),*/
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      TextField(
                                          controller: fecha,
                                          decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            labelText: 'Fecha',
                                            prefixIcon:
                                                Icon(Icons.calendar_today),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          readOnly: true,
                                          onTap: () {
                                            _selectDate();
                                          }),
                                      const SizedBox(height: 10),
                                      DropdownButtonFormField<String>(
                                        value: _selectedItem,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _selectedItem = value!;
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          labelText: 'Hora de inicio',
                                          border: OutlineInputBorder(),
                                        ),
                                        items: [
                                          "08:00",
                                          "09:00",
                                          "10:00",
                                          "11:00",
                                          "12:00",
                                          "13:00",
                                          "14:00",
                                          "15:00",
                                          "16:00",
                                          "17:00",
                                          "18:00"
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(height: 10),
                                      DropdownButtonFormField<String>(
                                        value: _selectedItem2,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _selectedItem2 = value!;
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          labelText: 'Hora de fin2',
                                          border: OutlineInputBorder(),
                                        ),
                                        items: [
                                          "08:00",
                                          "09:00",
                                          "10:00",
                                          "11:00",
                                          "12:00",
                                          "13:00",
                                          "14:00",
                                          "15:00",
                                          "16:00",
                                          "17:00",
                                          "18:00"
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 0.0, top: 10, bottom: 20),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: const Color(0xF082BC00)),
                                        child: TextButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              //print(fecha.text);

                                              db
                                                  .createBook(BookModel(
                                                      canchaId: widget
                                                          .cancha.canchaId,
                                                      userId: 1,
                                                      fecha: fecha.text,
                                                      horaInicio: _selectedItem,
                                                      horaFin: _selectedItem2,
                                                      createdAt: DateTime.now()
                                                          .toIso8601String()))
                                                  .whenComplete(() {
                                                //When this value is true
                                                Navigator.of(context).pop(true);
                                              });
                                            }

                                            //Navigate to sign up
                                            /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CanchaDetalle(
                                                  canchaId: 1,
                                                  canchaTitle: 'titulo')));*/
                                          },
                                          child: const Text(
                                            "Reservar",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));

    /*Text(
        widget.cancha.canchaTitle);*/ // Here you direct access using widget
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        fecha.text = picked.toString().split(" ")[0];
      });
    }
  }
}
