import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call_app/src/utils/constants.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class GroupVideoCall extends StatefulWidget {
  final String channelName;
  final ClientRole role;
  const GroupVideoCall(
      {required this.channelName, required this.role, Key? key})
      : super(key: key);

  @override
  State<GroupVideoCall> createState() => _GroupVideoCallState();
}

class _GroupVideoCallState extends State<GroupVideoCall> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  late RtcEngine _engine;
  bool _joned = false;
  int _remoteUid = 0;

  @override
  void dispose() {
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    _users.clear();
    super.dispose();
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future initialize() async {
    await [Permission.microphone, Permission.camera].request();

    RtcEngineContext context = RtcEngineContext(appId);
    _engine = await RtcEngine.createWithContext(context);

    _addAgoraEventHandlers();
    // Enable video
    await _engine.enableVideo();
    // Join channel with custome channel name
    await _engine.joinChannel(
      tempToken,
      channelName,
      null,
      0,
    );
    await _engine.setClientRole(widget.role);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
        _joned = true;
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
        _remoteUid = uid;
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _remoteUid = 0;
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (_joned) {
      // list.clear();
      // if (widget.role == ClientRole.Broadcaster) {
      // }

      list.add(const RtcLocalView.SurfaceView());

      for (var uid in _users) {
        list.add(
          RtcRemoteView.SurfaceView(
            uid: uid,
            channelId: channelName,
          ),
        );
      }
    }
    return list;
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[_videoView(views[0])],
        );
      case 2:
        return Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        );
      case 3:
        return Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  _expandedVideoRow([views[0]]),
                  _expandedVideoRow([views[1]])
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _expandedVideoRow([views[2]])
                ],
              ),
            )
            // _expandedVideoRow(views.sublist(0, 2)),
            // _expandedVideoRow(views.sublist(2, 3))
          ],
        );
      case 4:
        return Column(
          children: <Widget>[
            Row(
              children: [
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            ),
            Row(
              children: [
                _expandedVideoRow([views[2]]),
                _expandedVideoRow([views[3]])
              ],
            )
          ],
        );
      default:
    }
    return const Center(
        child: _MyStfulwidget(
            child: Align(
      alignment: Alignment.center,
      child: Text(
        'Connecting...',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        textAlign: TextAlign.center,
      ),
    )));
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(
            height: 40.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RawMaterialButton(
                onPressed: _onToggleMute,
                child: Icon(
                  muted ? Icons.mic_off : Icons.mic,
                  color: muted ? Colors.white : kPrimaryColor,
                  size: 20.0,
                ),
                shape: const CircleBorder(),
                elevation: 2.0,
                fillColor: muted ? kPrimaryColor : Colors.white,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            _viewRows(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}

class _MyStfulwidget extends StatefulWidget {
  const _MyStfulwidget({required this.child, Key? key}) : super(key: key);
  final Widget child;

  @override
  State<_MyStfulwidget> createState() => __MyStfulwidgetState();
}

class __MyStfulwidgetState extends State<_MyStfulwidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
