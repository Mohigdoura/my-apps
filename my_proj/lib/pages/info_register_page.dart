import 'package:flutter/material.dart';
import 'package:my_proj/pages/customer/customer_home_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InfoRegisterPage extends StatelessWidget {
  const InfoRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final SupabaseClient supabaseClient = Supabase.instance.client;
    final formKey = GlobalKey<FormState>(); // Persistent key
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Form(
        key: formKey, // Use the persistent GlobalKey here
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 51),
            decoration: BoxDecoration(
              border: Border.all(width: 0.5),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name Input
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty) return "Name is required";
                    if (value.length < 3) {
                      return "Name should be at least 3 characters long";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Phone Number Input
                TextFormField(
                  controller: phoneController,
                  validator: (value) {
                    if (!RegExp(r'^\d+$').hasMatch(value!)) {
                      return "Phone number should be valid";
                    }
                    if (value.length != 8) {
                      return "Phone number should be valid";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Phone number",
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      try {
                        await supabaseClient
                            .from('users')
                            .update({
                              'name': nameController.text,
                              'phone': phoneController.text,
                            })
                            .eq('id', supabaseClient.auth.currentUser!.id);

                        // Clear entire navigation stack
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => CustomerHomeGate()),
                          (route) => false,
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $error")),
                        );
                      }
                    }
                  },
                  child: Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
