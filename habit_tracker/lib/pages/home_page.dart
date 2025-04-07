import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/components/my_heat_map.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/utils/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  // text controller
  final TextEditingController controller = TextEditingController();
  // create new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Create a new habit!"),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    // get the new habit
                    String newHabitName = controller.text;
                    // save to db
                    context.read<HabitDatabase>().addHabit(newHabitName);
                  }
                  // pop the box
                  Navigator.pop(context);
                  // clear controller
                  controller.clear();
                },
                child: Text('Save'),
              ),
              MaterialButton(
                onPressed: () {
                  // pop the box
                  Navigator.pop(context);
                  // clear controller
                  controller.clear();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  // check habit on off
  void checkHabitOnOff(bool? value, Habit habit) {
    // update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // edit habit
  void editHabitBox(Habit habit) {
    // set the controller's text to the habit's current name
    controller.text = habit.name;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(controller: controller),
            actions: [
              MaterialButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    // get the new habit
                    String newHabitName = controller.text;
                    // save to db
                    context.read<HabitDatabase>().updateHabitName(
                      habit.id,
                      newHabitName,
                    );
                  }
                  // pop the box
                  Navigator.pop(context);
                  // clear controller
                  controller.clear();
                },
                child: Text('Save'),
              ),
              MaterialButton(
                onPressed: () {
                  // pop the box
                  Navigator.pop(context);
                  // clear controller
                  controller.clear();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  // delete habit
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('are you sure you want to delete?'),
            actions: [
              MaterialButton(
                onPressed: () {
                  context.read<HabitDatabase>().deleteHabit(habit.id);

                  // pop the box
                  Navigator.pop(context);
                },
                child: Text('Delete'),
              ),
              MaterialButton(
                onPressed: () {
                  // pop the box
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: ListView(
        children: [
          // heatmap
          _buildHeatMap(),

          // habit list
          _buildHabitList(),
        ],
      ),
    );
  }

  // build heatmap
  Widget _buildHeatMap() {
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;
    // return heat map UI
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        // once the data is available -> build heatmap
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(currentHabits),
          );
        }
        // handle case where no data is returned
        else {
          return Container();
        }
      },
    );
  }

  // habit list
  Widget _buildHabitList() {
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // return list of habits UI
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currentHabits[index];

        // check if the is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // return habit tile UI
        return HabitTile(
          isCompleted: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
