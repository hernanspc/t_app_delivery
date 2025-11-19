import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class NoDataWidget extends StatelessWidget {
  String text = '';

  NoDataWidget({Key? key, this.text = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/img/no_items.png',
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
