import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_sm/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

final nameController = TextEditingController();
final typeController = TextEditingController();
final descripController = TextEditingController();

class _MyHomePageState extends ConsumerState<MyHomePage> {
  void _changeName() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Name"),
            content: TextField(controller: nameController),
            actions: [
              MaterialButton(
                child: Center(child: Text("save")),
                onPressed: () {
                  Navigator.pop(context);
                  ref
                      .read(userProvider.notifier)
                      .changeName(nameController.text);
                  nameController.clear();
                },
              ),
              MaterialButton(
                child: Center(child: Text("cancel")),
                onPressed: () {
                  Navigator.pop(context);
                  nameController.clear();
                },
              ),
            ],
          ),
    );
  }

  void _changeType() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Type"),
            content: TextField(controller: typeController),
            actions: [
              MaterialButton(
                child: Center(child: Text("save")),
                onPressed: () {
                  Navigator.pop(context);
                  ref
                      .read(userProvider.notifier)
                      .changeType(typeController.text);
                  typeController.clear();
                },
              ),
              MaterialButton(
                child: Center(child: Text("cancel")),
                onPressed: () {
                  Navigator.pop(context);
                  typeController.clear();
                },
              ),
            ],
          ),
    );
  }

  void _changeDescrip() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Description"),
            content: TextField(controller: descripController),
            actions: [
              MaterialButton(
                child: Center(child: Text("save")),
                onPressed: () {
                  Navigator.pop(context);
                  ref
                      .read(userProvider.notifier)
                      .changeDescrip(descripController.text);
                  descripController.clear();
                },
              ),
              MaterialButton(
                child: Center(child: Text("cancel")),
                onPressed: () {
                  Navigator.pop(context);
                  descripController.clear();
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You are:'),
            Text(
              "name: ${ref.watch(userProvider).name.toString()}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              "type: ${ref.watch(userProvider).type.toString()}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              "descrip: ${ref.watch(userProvider).descrip.toString()}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min, // Set the main axis size to min
        children: [
          FloatingActionButton(
            onPressed: _changeName,
            child: const Text("Name"),
          ),
          FloatingActionButton(
            onPressed: _changeType,
            child: const Text("Type"),
          ),
          FloatingActionButton(
            onPressed: _changeDescrip,
            child: const Text("Descrip"),
          ),
        ],
      ),
    );
  }
}
