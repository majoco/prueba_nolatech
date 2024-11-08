import 'package:flutter/material.dart';
import 'package:flutter_nolatech2/JsonModels/node_model.dart';
import 'package:flutter_nolatech2/SQLite/sqlite.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final title = TextEditingController();
  final content = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear nota"),
        actions: [
          IconButton(
              onPressed: () {
                db
                    .createNote(NoteModel(
                        noteTitle: title.text,
                        noteContent: content.text,
                        createdAt: DateTime.now().toIso8601String()))
                    .whenComplete(() {
                  Navigator.of(context).pop(true);
                });
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Form(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
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
        ]),
      )),
    );
  }
}
