import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:video_call_app/src/utils/constants.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({Key? key}) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool _joined = false;
  int _remoteUid = 0;
  bool _remoteUserLeft = false;
  bool _switch = false;
  late RtcEngine _engine;
  bool _muted = false;

  late StopWatchTimer _stopWatchTimer;
  int _time = 0;
  int _minute = 0;
  int _second = 0;

  @override
  void initState() {
    super.initState();
    _setStopWatch();
    initPlatformState();
  }

  // Init the app
  Future<void> initPlatformState() async {
    await [Permission.microphone, Permission.camera].request();

    // Create RTC client instance
    RtcEngineContext context = RtcEngineContext(appId);
    _engine = await RtcEngine.createWithContext(context);
    // Define event handling logic
    _engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      debugPrint('joinChannelSuccess $channel $uid');
      setState(() {
        _joined = true;
      });
    }, userJoined: (int uid, int elapsed) {
      debugPrint('userJoined $uid');
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
      setState(() {
        _switch = !_switch;
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      debugPrint('userOffline $uid');
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      setState(() {
        _remoteUid = 0;
        _remoteUserLeft = true;
      });
    }));
    // Enable video
    await _engine.enableVideo();
    // Join channel with custome channel name
    await _engine.joinChannel(tempToken, channelName, null, 0);
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.destroy();
    _stopWatchTimer.dispose();
    super.dispose();
  }

  _setStopWatch() {
    _stopWatchTimer = StopWatchTimer(
        mode: StopWatchMode.countUp,
        onChange: (value) {
          setState(() {
            _time = value;
          });
        },
        onChangeRawMinute: (value) {
          setState(() {
            _minute = value;
          });
        },
        onChangeRawSecond: (value) {
          setState(() {
            _second = value;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    // if(_joined && _remoteUid != 0){

    // }
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
          ),
          if (_joined && _remoteUid != 0)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 80,
                  right: 30,
                ),
                width: size.width * 0.3,
                height: size.height * 0.25,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _switch = !_switch;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                    child: Center(
                      child: _switch
                          ? _renderLocalPreview()
                          : _renderRemoteVideo(),
                    ),
                  ),
                ),
              ),
            ),
          _buildToolBar(
            _joined && _remoteUid != 0
                ? Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${_getTimeNum(_minute)}:${_getTimeNum(_second)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : _joined && _remoteUid == 0 && !_remoteUserLeft
                    ? const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Calling...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : _joined
                        ? Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Call ended in ${_getTimeNum(_minute)}:${_getTimeNum(_second)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
          )
        ],
      ),
    );
  }

  // Local video rendering
  Widget _renderLocalPreview() {
    if (_joined) {
      return const RtcLocalView.SurfaceView();
    } else {
      return const Text(
        'Connecting...',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  // Remote video rendering
  Widget _renderRemoteVideo() {
    if (_remoteUid != 0) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid,
        channelId: channelName,
      );
    } else {
      return Container();
    }
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  String _getTimeNum(int time) {
    if (time < 10) {
      return '0$time';
    } else {
      return '$time';
    }
  }

  Widget _buildToolBar(Widget timeWidget) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          timeWidget,
          const SizedBox(
            height: 40.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RawMaterialButton(
                onPressed: _onToggleMute,
                child: Icon(
                  _muted ? Icons.mic_off : Icons.mic,
                  color: _muted ? Colors.white : kPrimaryColor,
                  size: 20.0,
                ),
                shape: const CircleBorder(),
                elevation: 2.0,
                fillColor: _muted ? kPrimaryColor : Colors.white,
                padding: const EdgeInsets.all(12.0),
              ),
              RawMaterialButton(
                onPressed: () => _onCallEnd(context),
                child: const Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 35.0,
                ),
                shape: const CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.redAccent,
                padding: const EdgeInsets.all(15.0),
              ),
              RawMaterialButton(
                onPressed: _onSwitchCamera,
                child: const Icon(
                  Icons.switch_camera,
                  color: kPrimaryColor,
                  size: 20.0,
                ),
                shape: const CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(12.0),
              )
            ],
          ),
        ],
      ),
    );
  }
}
