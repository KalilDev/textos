import 'package:flutter/material.dart';

class BottomTextsBar extends StatelessWidget {
  const BottomTextsBar({@required this.currentIdx, @required this.onTap});

  final int currentIdx;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius:
          const BorderRadius.vertical(top: Radius.circular(20.0))),
      child: BottomNavigationBar(
        showUnselectedLabels: false,
        currentIndex: currentIdx,
        onTap: onTap,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Color.alphaBlend(
            Theme.of(context).accentColor.withAlpha(150),
            Theme.of(context).backgroundColor),
        unselectedItemColor: Theme.of(context).backgroundColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), title: Text('Favoritos')),
          BottomNavigationBarItem(
              icon: Icon(Icons.group), title: Text('Autores')),
          BottomNavigationBarItem(
              icon: Icon(Icons.style), title: Text('Textos')),
        ],
      ),
    );
  }
}
