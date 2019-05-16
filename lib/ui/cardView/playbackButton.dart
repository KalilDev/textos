import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/widgets.dart';

enum PlayerState { stopped, playing, paused }

class PlaybackButton extends StatefulWidget {
  final String url;
  final bool isLocal;
  final PlayerMode mode;

  PlaybackButton(
      {@required this.url,
      this.isLocal = false,
      this.mode = PlayerMode.MEDIA_PLAYER});

  @override
  State<StatefulWidget> createState() {
    return new _PlaybackButtonState(url, isLocal, mode);
  }
}

class _PlaybackButtonState extends State<PlaybackButton> {
  String url;
  bool isLocal;
  PlayerMode mode;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;

  get _isPaused => _playerState == PlayerState.paused;

  get _durationText => _duration?.toString()?.split('.')?.first ?? '';

  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  _PlaybackButtonState(this.url, this.isLocal, this.mode);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playbackProportion = _position != null && _duration != null
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;
    return Container(
      child: Container(
        height: 48,
        width: 150,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            LayoutBuilder(builder: (context, constraints) {
              return BlurOverlay(
                intensity: 0.65,
                radius: 80,
                enabled: Provider.of<BlurProvider>(context).buttonsBlur,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Container(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.red.shade900.withAlpha(150),
                              Colors.indigo.withAlpha(120)
                            ], stops: [
                              -1 + playbackProportion,
                              2 * playbackProportion
                            ])),
                        child: Center(
                            child: AnimatedSwitcher(
                                duration: Constants.durationAnimationMedium,
                                child: Icon(_playerState == PlayerState.stopped
                                    ? playbackProportion == 0.0
                                    ? Icons.play_arrow
                                    : Icons.refresh
                                    : _isPlaying ? Icons.pause : Icons
                                    .play_arrow
                                )))),
                    onTap: _isPlaying ? _pause : _play,
                  ),
                ),
              );
            }),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 3,
                    child: SliderTheme(
                      data: Theme.of(context).sliderTheme.copyWith(
                          trackHeight: 3.0,
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent),
                      child: Slider(
                        max: _duration?.inMilliseconds?.toDouble() ?? 1.0,
                        value: (_position != null &&
                                _duration != null &&
                                _position.inMilliseconds > 0 &&
                                _position.inMilliseconds <
                                    _duration.inMilliseconds)
                            ? _position.inMilliseconds.toDouble()
                            : 0.0,
                        onChanged: (value) => _audioPlayer
                            .seek(Duration(milliseconds: value.round())),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    _audioPlayer.stop();
    super.deactivate();
  }

  void _initAudioPlayer() {
    _audioPlayer = new AudioPlayer(mode: mode);

    _durationSubscription =
        _audioPlayer.onDurationChanged.listen((duration) => setState(() {
              _duration = duration;
            }));

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = new Duration(seconds: 0);
        _position = new Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result =
        await _audioPlayer.play(url, isLocal: isLocal, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);
    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
}
