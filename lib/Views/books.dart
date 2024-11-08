import 'package:flutter/material.dart';
import 'package:flutter_nolatech2/Authentication/login.dart';
import 'package:flutter_nolatech2/JsonModels/book_model.dart';
import 'package:flutter_nolatech2/SQLite/sqlite.dart';
import 'package:intl/intl.dart';

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  late DatabaseHelper handler;
  late Future<List<BookModel>> books;

  final db = DatabaseHelper();

  final bookId = TextEditingController();
  final canchaId = TextEditingController();
  final userId = TextEditingController();
  final fecha = TextEditingController();
  final horaInicio = TextEditingController();
  final horaFin = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    handler = DatabaseHelper();
    books = handler.getBooks();
    //reservas = handler.getReservas();

    handler.initDB().whenComplete(() {
      books = getAllBooks();
    });
    /*handler.initDB().whenComplete(() {
      reservas = getAllReservas();
    });*/
    super.initState();
  }

  Future<List<BookModel>> getAllBooks() {
    return handler.getBooks();
  }

  /*Future<List<dynamic>> getAllReservas() {
    return handler.getReservas();
  }*/

  //Search method here
  //First we have to create a method in Database helper class
  Future<List<BookModel>> searchBook() {
    return handler.searchBooks(keyword.text);
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      books = getAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List imageList = [
      'lib/assets/cancha1.png',
      'lib/assets/cancha2.png',
      'lib/assets/cancha3.png'
    ];

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'lib/assets/logo_tennis_court.png',
                fit: BoxFit.contain,
                height: 30,
              ),
              Container(
                  padding: const EdgeInsets.all(0.0), child: const Text(''))
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xFF3D3D3D), Color(0xFF82BC00)]),
            ),
          ),
          actions: <Widget>[
            Image.asset(
              'lib/assets/thumb.png',
              fit: BoxFit.contain,
              height: 30,
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              color: Colors.white,
              tooltip: 'Notificaciones',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is a snackbar')));
              },
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              tooltip: 'Menu',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Menu'),
                      ),
                      body: Center(
                        child: TextButton(
                          onPressed: () {
                            //Navigate to sign up
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text('Logout',
                              style: TextStyle(
                                color: Color(0xFF346BC3),
                              )),
                        ),
                      ),
                    );
                  },
                ));
              },
            ),
          ],
        ),
        /*floatingActionButton: FloatingActionButton(
          onPressed: () {
            //We need call refresh method after a new book is created
            //Now it works properly
            //We will do delete now
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CreateBook()))
                .then((value) {
              if (value) {
                //This will be called
                _refresh();
              }
            });
          },
          child: const Icon(Icons.add),
        ),*/
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Color(0xFF82BC00),
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_month_outlined, color: Colors.white),
                      SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "Reservas",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Mis Reservas",
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: books,
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data"));
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ?? <dynamic>[];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              var can = '';
                              var cant = '';
                              if (items[index].canchaId == 1) {
                                can = 'Epic Box';
                                cant = 'Cancha tipo A';
                              } else if (items[index].canchaId == 2) {
                                can = 'Rusty Tenis';
                                cant = 'Cancha tipo C';
                              } else if (items[index].canchaId == 3) {
                                can = 'Cancha Multiple';
                                cant = 'Cancha tipo B';
                              }

                              String ds = items[index].fecha;
                              DateTime dt = DateTime.parse(ds);
                              //print(dt);

                              var split = ds.split(' ');

                              //print(split[0]);

                              var split2 = split[0].split('-');

                              //print(split2[2]);

                              var mes = '';
                              if (split2[1] == '01') {
                                mes = 'enero';
                              } else if (split2[1] == '02') {
                                mes = 'febrero';
                              } else if (split2[1] == '02') {
                                mes = 'febrero';
                              } else if (split2[1] == '03') {
                                mes = 'marzo';
                              } else if (split2[1] == '04') {
                                mes = 'abril';
                              } else if (split2[1] == '05') {
                                mes = 'mayo';
                              } else if (split2[1] == '06') {
                                mes = 'junio';
                              } else if (split2[1] == '07') {
                                mes = 'julio';
                              } else if (split2[1] == '08') {
                                mes = 'agosto';
                              } else if (split2[1] == '09') {
                                mes = 'septiembre';
                              } else if (split2[1] == '10') {
                                mes = 'octubre';
                              } else if (split2[1] == '11') {
                                mes = 'noviembre';
                              } else if (split2[1] == '12') {
                                mes = 'diciembre';
                              }

                              var fechaf =
                                  split2[2] + ' de ' + mes + ' de ' + split2[0];

                              //print(fechaf);

                              return ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    //color: Colors.deepPurple.withOpacity(.2),
                                    color: Colors.white,
                                  ),
                                  child: Image.asset(
                                    imageList[items[index].canchaId - 1],
                                    fit: BoxFit.fill,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                subtitle: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('${fechaf}'),
                                    ),
                                    SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Reservador por '),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'lib/assets/thumb.png',
                                                fit: BoxFit.contain,
                                                height: 20,
                                              ),
                                              Text('Andrea Gomez'),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_view_week),
                                              SizedBox(width: 10),
                                              Text('2 Horas  |  USD 25'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(can,
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(cant)),
                                    ],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    //We call the delete method in database helper
                                    db
                                        .deleteBook(items[index].bookId!)
                                        .whenComplete(() {
                                      //After success delete , refresh books
                                      //Done, next step is update books
                                      _refresh();
                                    });
                                  },
                                ),
                                onTap: () {
                                  //When we click on book
                                  setState(() {
                                    /*final int? bookId;
                                    canchaId.text = items[index].canchaId;
                                    userId.text = items[index].userId as String;
                                    fecha.text = items[index].fecha;
                                    horaInicio.text = items[index].horaInicio;
                                    horaFin.text = items[index].horaFin;*/
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          actions: [
                                            Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    //Now update method
                                                    db
                                                        .updateBook(
                                                            canchaId.value
                                                                as int,
                                                            userId.text as int,
                                                            fecha.text,
                                                            horaInicio.text,
                                                            horaFin.text,
                                                            items[index].bookId
                                                                as int)
                                                        .whenComplete(() {
                                                      //After update, book will refresh
                                                      _refresh();
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: const Text("Update"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                              ],
                                            ),
                                          ],
                                          title: const Text("Update book"),
                                          content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                //We need two textfield
                                                TextFormField(
                                                  controller: canchaId,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Cancha is required";
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
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
                                                  decoration:
                                                      const InputDecoration(
                                                    label: Text("User"),
                                                  ),
                                                ),
                                                TextFormField(
                                                  controller: fecha,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Fecha de inicio is required";
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    label: Text("Fecha"),
                                                  ),
                                                ),
                                                TextFormField(
                                                  controller: horaInicio,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Fecha is required";
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    label: Text("Hora inicio"),
                                                  ),
                                                ),
                                                TextFormField(
                                                  controller: horaFin,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Fecha final is required";
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    label: Text("Hora final"),
                                                  ),
                                                ),
                                              ]),
                                        );
                                      });
                                },
                              );
                            }),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }
}
