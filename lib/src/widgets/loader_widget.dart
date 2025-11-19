import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class LoaderWidget extends StatelessWidget {
  String text = '';

  LoaderWidget({Key? key, this.text = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset(
              'assets/img/spinner.gif',
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
