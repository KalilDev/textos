import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/src/model/content.dart';
import 'package:textos/src/providers.dart';

import 'textCard.dart';

class CardView extends StatelessWidget {
  const CardView({
    Key key,
    @required this.heroTag,
    @required this.content,
  }) : super(key: key);

  final Content content;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            ContentCard(content: content, heroTag: heroTag),
            Align(
              alignment: Alignment.bottomCenter,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) =>
                      AbsorbPointer(
                        child: Container(
                          width: constraints.maxWidth,
                          height: 100.0,
                        ),
                      )),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      content.hasText
                          ? Container(
                              margin: const EdgeInsets.only(left: 4.0),
                              child: IncDecButton(
                                  isBlurred: Provider.of<BlurProvider>(context)
                                      .buttonsBlur,
                                  onDecrease: () =>
                                      Provider.of<TextStyleProvider>(context)
                                          .decrease(),
                                  onIncrease: () =>
                                      Provider.of<TextStyleProvider>(context)
                                          .increase(),
                                  value: Provider.of<TextStyleProvider>(context)
                                      .textSize))
                          : const SizedBox(),
                      content.hasMusic
                          ? Expanded(
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: RepaintBoundary(
                                    child: PlaybackButton(
                                      url: content.music,
                                      isBlurred:
                                          Provider.of<BlurProvider>(context)
                                              .buttonsBlur,
                                    ),
                                  )))
                          : Spacer(),
                      Container(
                        margin: const EdgeInsets.only(right: 4.0),
                        child: RepaintBoundary(
                          child: BiStateFAB(
                            onPressed: () =>
                                Provider.of<FavoritesProvider>(context)
                                    .toggle(content.favorite),
                            enabledColor: Theme.of(context).accentColor,
                            isBlurred:
                                Provider.of<BlurProvider>(context).buttonsBlur,
                            isEnabled: Provider.of<FavoritesProvider>(context)
                                .isFavorite(content.favorite),
                            disabledColor: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
              child: MenuButton(),
              top: MediaQuery.of(context).padding.top - 2.5,
              left: -2.5,
            ),
          ],
        ),
      ),
    );
  }
}
