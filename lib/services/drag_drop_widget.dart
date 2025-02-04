import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class DragDropWidget extends StatefulWidget {
  final Function(Uint8List) onFileDropped;

  const DragDropWidget({super.key, required this.onFileDropped});

  @override
  _DragDropWidgetState createState() => _DragDropWidgetState();
}

class _DragDropWidgetState extends State<DragDropWidget> {
  late DropzoneViewController controller;
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DropzoneView(
          onCreated: (ctrl) => controller = ctrl,
          onDrop: (file) async {
            final bytes = await controller.getFileData(file);
            widget.onFileDropped(bytes);
            setState(() => highlighted = false);
          },
          onHover: () => setState(() => highlighted = true),
          onLeave: () => setState(() => highlighted = false),
          operation: DragOperation.copy,
        ),
        Center(
          child: Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              color: highlighted ? Colors.blue.shade100 : Colors.grey.shade200,
              border: Border.all(
                width: 2,
                color: highlighted ? Colors.blue : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "Drag & Drop Image Here",
                style: TextStyle(
                  fontSize: 16,
                  color: highlighted ? Colors.blue : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
