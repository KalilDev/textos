import 'package:flutter/material.dart';
import 'package:textos/constants.dart';

class KalilAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KalilAppBar({this.leading, this.title = textAppName});

  final Widget leading;
  final String title;

  @override
  Size get preferredSize => const Size(double.infinity, 42.0);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: <Widget>[
            if (leading != null)
              SizedBox(height: 42.0, width: 42.0, child: leading),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .accentTextTheme
                      .title
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ));
  }
}
