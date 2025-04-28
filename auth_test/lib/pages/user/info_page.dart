import 'package:auth_test/components/my_text_field.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  final String appBarTitle;
  final String headLine;
  final String hintText;
  final TextEditingController controller;

  const InfoPage({
    super.key,
    required this.appBarTitle,
    required this.headLine,
    required this.controller,
    required this.hintText,
  });

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late TextEditingController infoController;
  bool isModified = false;

  @override
  void initState() {
    super.initState();
    infoController = TextEditingController(text: widget.controller.text);

    infoController.addListener(() {
      final modified = infoController.text != widget.controller.text;
      if (modified != isModified) {
        setState(() {
          isModified = modified;
        });
      }
    });
  }

  @override
  void dispose() {
    infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(widget.appBarTitle),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.headLine,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      MyTextField(
                        controller: infoController,
                        hintText: widget.hintText,
                        keyboardType: TextInputType.multiline,
                        maxLines: 20,
                        maxLength: 260,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      isModified
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap:
                        isModified
                            ? () {
                              widget.controller.text = infoController.text;
                              Navigator.pop(context);
                            }
                            : null,
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
