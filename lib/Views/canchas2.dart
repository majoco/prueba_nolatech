import 'package:flutter/material.dart';
import 'package:flutter_nolatech2/Authentication/login.dart';
import 'package:flutter_nolatech2/JsonModels/cancha_model.dart';
import 'package:flutter_nolatech2/JsonModels/users.dart';
import 'package:flutter_nolatech2/SQLite/sqlite.dart';
import 'package:flutter_nolatech2/Views/my_record.dart';
import 'package:flutter_nolatech2/Views/variables.dart';

class Canchas2 extends StatefulWidget {
  const Canchas2({super.key});

  @override
  State<Canchas2> createState() => _CanchasState();
}

class _CanchasState extends State<Canchas2> {
  late DatabaseHelper handler;
  late Future<List<CanchaModel>> canchas;
  late Future<List<Users>> users;
  final db = DatabaseHelper();

  final title = TextEditingController();
  final tipo = TextEditingController();
  final imagen = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    handler = DatabaseHelper();
    canchas = handler.getCanchas();
    users = handler.getUsers();

    handler.initDB().whenComplete(() {
      canchas = getAllCanchas();
    });
    handler.initDB().whenComplete(() {
      users = getAllUsers();
    });
    super.initState();
  }

  Future<List<CanchaModel>> getAllCanchas() {
    return handler.getCanchas();
  }

  Future<List<Users>> getAllUsers() {
    return handler.getUsers();
  }

  //Search method here
  //First we have to create a method in Database helper class
  Future<List<CanchaModel>> searchCancha() {
    return handler.searchCanchas(keyword.text);
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      canchas = getAllCanchas();
      users = getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List imageList = [
      'lib/assets/cancha1.png',
      'lib/assets/cancha2.png',
      'lib/assets/cancha3.png'
    ];

    /*canchas.then((value) {
      print(value);
    });*/

    //canchas = getAllCanchas();

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
        endDrawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<CanchaModel>>(
                future: canchas,
                builder: (BuildContext context,
                    AsyncSnapshot<List<CanchaModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data"));
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ?? <CanchaModel>[];

                    return ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                              ('Hola ${userNameGlobal[0].toUpperCase()}${userNameGlobal.substring(1).toLowerCase()}'),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          //Text('Hola '),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 0,
                          indent: 0,
                          endIndent: 0,
                          color: Color.fromARGB(255, 211, 211, 211),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text('Canchas',
                              style: TextStyle(
                                fontSize: 21,
                              )),
                        ),
                        SizedBox(
                          height: 360,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              /*return const CanchaDetalle(canchaId: 1);*/

                              var canchaId = items[index].canchaId;

                              return Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(15),
                                //color: Colors.orange.shade400,
                                width: 300,
                                child: SizedBox(
                                    //color: Colors.green.shade400,
                                    //color: Colors.amber,
                                    width: 300,
                                    child: Card(
                                        child: Container(
                                      //color: Colors.red,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Image.asset(
                                              items[index].canchaImagen,
                                              width: 300,
                                            ),
                                          ),
                                          const SizedBox(height: 0),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child:
                                                Text(items[index].canchaTitle),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child:
                                                Text(items[index].canchaType),
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 20.0),
                                            child: Text('10 de agosto de 2025'),
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 20.0),
                                            child: Text(
                                                'Disponible 7:00 am a 4:00 pm'),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 20.0,
                                                top: 10,
                                                bottom: 20),
                                            width: 200,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color(0xF082BC00)),
                                            child: TextButton(
                                              onPressed: () {
                                                //Navigate to sign up
                                                print(canchaId);

                                                if (canchaId == 1) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              /*RecordPage(
                                                          cancha: items[index],
                                                          key: null,
                                                        ),*/
                                                              MyRecord(
                                                                cancha: items[
                                                                    index],
                                                              )));
                                                } else if (canchaId == 2) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyRecord(
                                                                cancha: items[
                                                                    index],
                                                              )));
                                                } else if (canchaId == 3) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyRecord(
                                                                cancha: items[
                                                                    index],
                                                              )));
                                                }
                                              },
                                              child: const Text('Reservar',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))),
                                //child: const CanchaDetalle(canchaId: 1),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ));
    /*body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text('Hola Andrea',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const Divider(
              height: 1,
              thickness: 0,
              indent: 0,
              endIndent: 0,
              color: Color.fromARGB(255, 211, 211, 211),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text('Canchas',
                  style: TextStyle(
                    fontSize: 21,
                  )),
            ),
            SizedBox(
              height: 360,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageList.length,
                itemBuilder: (context, index) {
                  /*return const CanchaDetalle(canchaId: 1);*/
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(15),
                    //color: Colors.orange.shade400,
                    width: 300,
                    child: const CanchaDetalle(canchaId: 1),
                  );
                },
              ),
            ),
          ],
        ));*/

    // Create a ListView widget with the list of ImageData objects
    /*ListView.separated(
                itemCount:
                    imageList.length, // Set the number of items in the list
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(), // Add a divider between each item in the list
                itemBuilder: (BuildContext context, int index) {
                  final imageData = imageList[
                      index]; // Get the ImageData object at the current index
                  return ListTile(
                    leading: Image.asset(
                        imageData), // Display the image on the left side of the ListTile
                    title: Text(
                        imageData), // Display the name as the title of the ListTile
                    subtitle: Text(imageData
                        .toString()), // Display the description as the subtitle of the ListTile
                  );
                }));*/

    /*return Scaffold(
        appBar: AppBar(
          title: const Text("Canchas"),
        ),
        body: Column(children: [
          CarouselSlider(
            items: imageList
                .map((item) => Image.asset(item,
                    fit: BoxFit.cover, width: double.infinity))
                .toList(),
            options: CarouselOptions(
              aspectRatio: 16 / 9,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              pauseAutoPlayOnTouch: true,
            ),
          ),
          const Text('Texto')
        ]));*/

    /*return Scaffold(
        appBar: AppBar(
          title: const Text("Canchas"),
        ),
        body: Column(
          children: [
            //Search Field here
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(8)),
            ),

            CarouselSlider(
              options: CarouselOptions(height: 200.0),
              items: [canchas].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(color: Colors.amber),
                        child: const Text(
                          'text',
                          style: TextStyle(fontSize: 16.0),
                        ));
                  },
                  
                );
              }).toList(),
            ),

            Expanded(
              child: FutureBuilder<List<CanchaModel>>(
                future: canchas,
                builder: (BuildContext context,
                    AsyncSnapshot<List<CanchaModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data"));
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ?? <CanchaModel>[];

                    return CarouselSlider(
                      options: CarouselOptions(height: 500.0),
                      items: [canchas].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Column(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5),
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'lib/assets/cancha1.png'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    child: const Text(
                                      'text',
                                      style: TextStyle(fontSize: 16.0),
                                    )),
                                const Text('data')
                              ],
                            );
                          },
                        );
                      }).toList(),
                    );

                    
                  }
                },
              ),
            ),

            Expanded(
              child: FutureBuilder<List<CanchaModel>>(
                future: canchas,
                builder: (BuildContext context,
                    AsyncSnapshot<List<CanchaModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data"));
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ?? <CanchaModel>[];
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            subtitle: Text(DateFormat("yMd").format(
                                DateTime.parse(items[index].createdAt))),
                            title: Text(items[index].canchaTitle),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                //We call the delete method in database helper
                              },
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ));
        */
  }
}

/*class CardExample extends StatelessWidget {
  const CardExample({super.key, required this.canchaId});

  final int canchaId;

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print

    return SizedBox(
      //color: Colors.green.shade400,
      //color: Colors.amber,
      width: 300,
      child: Card(
        child: Container(
          //color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Image.asset(
                  "lib/assets/cancha1.png",
                  width: 300,
                ),
              ),
              const SizedBox(height: 0),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Epic Box '),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Cancha Tipo A'),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('10 de agosto de 2024'),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Disponible 7:00 am a 4:00 pm'),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0, top: 10, bottom: 20),
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xF082BC00)),
                child: TextButton(
                  onPressed: () {
                    //Navigate to sign up
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CanchaDetalle(
                                canchaId: 1, canchaTitle: 'titulo')));
                  },
                  child: const Text("Reservar",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
