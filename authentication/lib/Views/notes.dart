import 'package:authentication/JsonModels/note_model.dart';
import 'package:authentication/SQLite/sqlite.dart';
import 'package:authentication/Views/create_note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NOtesState();
}

class _NOtesState extends State<Notes> {
  late DatabaseHelper handler;
  late Future<List<NoteModel>> notes;
  final db = DatabaseHelper();

  final title = TextEditingController();
  final content = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    handler = DatabaseHelper();
    notes = handler.getNotes();
    handler.initDB().whenComplete(() {});
    notes = getAllNotes();

    super.initState();
  }

  Future<List<NoteModel>> getAllNotes() {
    return handler.getNotes();
  }

  //search method
  Future<List<NoteModel>> searchNote() {
    return handler.searchNotes(keyword.text);
  }

  //refresh nethod
  Future<void> _refresh() async {
    setState(() {
      notes = getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNote()),
          ).then((value) {
            if (value) {
              _refresh();
            }
          });
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: keyword,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    notes = searchNote();
                  });
                } else {
                  setState(() {
                    notes = getAllNotes();
                  });
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search),
                hintText: "Search",
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<NoteModel>>(
              future: notes,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<NoteModel>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text('No Data'));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  final items = snapshot.data ?? <NoteModel>[];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        subtitle: Text(
                          DateFormat(
                            "yMd",
                          ).format(DateTime.parse(items[index].createdAt)),
                        ),
                        title: Text(items[index].noteTitle),
                        trailing: IconButton(
                          onPressed: () {
                            db.deleteNote(items[index].noteId!).whenComplete(
                              () {
                                _refresh();
                              },
                            );
                          },
                          icon: Icon(Icons.delete),
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
                                                items[index].noteId,
                                              )
                                              .whenComplete(() {
                                                _refresh();
                                                Navigator.pop(context);
                                              });
                                        },
                                        child: Text('Update'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                ],
                                title: Text('Update note'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: title,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Title is required";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        label: Text('Title'),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: content,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Content is required";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        label: Text('Content'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
