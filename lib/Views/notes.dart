import 'package:flutter/material.dart';
import 'package:flutter_nolatech2/JsonModels/node_model.dart';
import 'package:flutter_nolatech2/SQLite/sqlite.dart';
import 'package:flutter_nolatech2/Views/create_note.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late DatabaseHelper handler;
  late Future<List<NoteModel>> notes;
  final db = DatabaseHelper();

  final title = TextEditingController();
  final content = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    handler = DatabaseHelper();
    notes = handler.getNotes();

    handler.initDB().whenComplete(() {
      notes = getAllNotes();
    });

    super.initState();
  }

  Future<List<NoteModel>> getAllNotes() {
    return handler.getNotes();
  }

  Future<void> _refresh() async {
    setState(() {
      notes = getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CreateNote()))
                .then((value) {
              if (value) {
                _refresh();
              }
            });
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<List<NoteModel>>(
          future: notes,
          builder:
              (BuildContext context, AsyncSnapshot<List<NoteModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Text('No Data');
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              final items = snapshot.data ?? <NoteModel>[];
              return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index].noteTitle),
                      subtitle: Text(items[index].createdAt),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          db.deleteNote(items[index].noteId!).whenComplete(() {
                            _refresh();
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          title.text = items[index].noteTitle;
                          content.text = items[index].noteContent;
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
                                          db
                                              .updateNote(
                                                  title.text,
                                                  content.text,
                                                  items[index].noteId)
                                              .whenComplete(() {
                                            _refresh();
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text("Actualizar"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      )
                                    ],
                                  )
                                ],
                                title: const Text("Nota actualizada"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: title,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Se require el titulo";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        label: Text("Titulo"),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: content,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Se require el contenido";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        label: Text("Contenido"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    );
                  });
            }
          },
        ));
  }
}
