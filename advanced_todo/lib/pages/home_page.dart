import 'package:advanced_todo/components/my_drawer.dart';
import 'package:advanced_todo/services/todo/todo_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TodoService todoService = TodoService();
  final TextEditingController controller = TextEditingController();
  final List<String> todoTypes = ["Work", "Personal", "Shopping", "Other"];

  // This function will be called when the user presses "Save"
  void addTodo(String? nothing, String todo, String type) {
    // Call your TodoService to save the Todo
    todoService.addTodo(todo, type);
  }

  void updateTodo(String? docId, String newTodo, String type) {
    todoService.updateTodo(docId!, newTodo, type);
    setState(() {
      controller.clear();
    });
  }

  void delete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: Center(
              heightFactor: 1,
              widthFactor: 1,
              child: Text(
                "Are you sure?",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      todoService.deleteTodo(docId);
                      Navigator.pop(context);
                    },
                    child: Text("Delete"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  void showAddTodoDialog({
    required BuildContext context,
    String? text,
    String? type,
    String? docId,
    required Function(String?, String, String) function,
  }) {
    String? selectedType;
    if (text != '' && text != null) {
      setState(() {
        controller.text = text;
        selectedType = type;
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create new Todo!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter task',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(labelText: "Select Type"),
                items:
                    todoTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  selectedType = newValue!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty && selectedType != null) {
                  function(docId, controller.text, selectedType!);
                  Navigator.pop(context);
                  controller.clear();
                }
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.clear();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String? selectedType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        onPressed: () => showAddTodoDialog(context: context, function: addTodo),
      ),
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Home"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Wrap(
            spacing: 1,
            children:
                List<Widget>.generate(todoTypes.length, (int index) {
                  return ChoiceChip(
                    label: Text(todoTypes[index]),
                    selected: selectedType == todoTypes[index],
                    onSelected: (bool selected) {
                      setState(() {
                        selectedType = selected ? todoTypes[index] : null;
                      });
                    },
                  );
                }).toList(),
          ),
          SizedBox(height: 20),
          Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot>(
              stream: todoService.getTodosStream(type: selectedType),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  ); // Loading state
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  ); // Error handling
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No ${selectedType ?? 'Todos'} found "),
                  ); // No data case
                }

                List<QueryDocumentSnapshot<Object?>> todosList =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount: todosList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = todosList[index];
                    String docId = document.id;
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String todoText = data['todo'].toString();
                    String todoType = data['type'].toString();

                    return ListTile(
                      title: Text(todoText),
                      subtitle: Text("Category:$todoType"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed:
                                () => showAddTodoDialog(
                                  context: context,
                                  text: todoText,
                                  type: todoType,
                                  docId: docId,
                                  function: updateTodo,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              delete(context, docId);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
