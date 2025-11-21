import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum CustomModalType { INFORMATIVO, ERROR, ADVERTENCIA }

CustomModalType parseModalType(String? value) {
  if (value == null) return CustomModalType.INFORMATIVO;

  switch (value.toUpperCase()) {
    case "ERROR":
      return CustomModalType.ERROR;
    case "ADVERTENCIA":
      return CustomModalType.ADVERTENCIA;
    case "INFORMATIVO":
      return CustomModalType.INFORMATIVO;
    default:
      return CustomModalType.INFORMATIVO;
  }
}

class CustomCupertinoModal extends StatelessWidget {
  final String title;
  final String message;
  final CustomModalType type;

  const CustomCupertinoModal({
    super.key,
    required this.title,
    required this.message,
    this.type = CustomModalType.INFORMATIVO,
  });

  Color _getColor() {
    switch (type) {
      case CustomModalType.INFORMATIVO:
        return Colors.green;
      case CustomModalType.ERROR:
        return Colors.red;
      case CustomModalType.ADVERTENCIA:
        return Colors.amber;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case CustomModalType.INFORMATIVO:
        return CupertinoIcons.checkmark_circle_fill;
      case CustomModalType.ERROR:
        return CupertinoIcons.xmark_circle_fill;
      case CustomModalType.ADVERTENCIA:
        return CupertinoIcons.exclamationmark_triangle_fill;
      default:
        return CupertinoIcons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), color: _getColor(), size: 45),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _getColor(),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text("Aceptar"),
        ),
      ],
    );
  }
}
