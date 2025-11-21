import 'package:flutter/material.dart';

class SearchBarYouTube extends StatefulWidget {
  final Function(String)? onChanged;
  final Function(String)? onSearch; // <-- opcional

  const SearchBarYouTube({super.key, this.onChanged, this.onSearch});

  @override
  State<SearchBarYouTube> createState() => _SearchBarYouTubeState();
}

class _SearchBarYouTubeState extends State<SearchBarYouTube> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool isFocused = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {});
    });

    focusNode.addListener(() {
      setState(() => isFocused = focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(focusNode);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[600], size: 26),

              const SizedBox(width: 10),

              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: widget.onChanged,

                  // 👇🔥 AQUÍ APARECE EL BOTÓN "BUSCAR"
                  textInputAction: TextInputAction.search,

                  // 👇 Acción cuando el usuario presiona "Buscar" en el teclado
                  onSubmitted: widget.onSearch,

                  decoration: InputDecoration(
                    hintText: "Buscar producto",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                ),
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: isFocused && controller.text.isNotEmpty
                    ? GestureDetector(
                        key: const ValueKey("clear"),
                        onTap: () {
                          controller.clear();
                          widget.onChanged?.call("");
                          setState(() {});
                        },
                        child: Icon(
                          Icons.close,
                          size: 26,
                          color: Colors.grey[600],
                        ),
                      )
                    : Icon(
                        Icons.mic_none,
                        key: const ValueKey("mic"),
                        size: 26,
                        color: Colors.grey[600],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
