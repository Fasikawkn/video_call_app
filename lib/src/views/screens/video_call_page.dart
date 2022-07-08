import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call_app/src/utils/constants.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({Key? key}) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
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
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      debugPrint('userOffline $uid');
      setState(() {
        _remoteUid = 0;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.only(
                top: 80,
                right: 30,
              ),
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green,
                  borderRadius: BorderRadius.circular(
                5.0,
              )),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _switch = !_switch;
                  });
                },
                child: Center(
                  child: _switch ? _renderLocalPreview() : _renderRemoteVideo(),
                ),
              ),
            ),
          ),
          Positioned(
              top: 30,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: _joined ? Colors.white : Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
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
      return const Text(
        'Please wait remote user join',
        textAlign: TextAlign.center,
      );
    }
  }
}
