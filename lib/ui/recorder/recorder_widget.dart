import 'dart:async';
import 'dart:io' as io;

import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:lualepapp/blocs/word_check_bloc.dart';
import 'package:lualepapp/model/word_model.dart';
import 'package:lualepapp/utils/cryptoString.dart';
import 'package:path_provider/path_provider.dart';

import '../../blocs/user_data_bloc.dart';

class RecorderWidget extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  final Word wordData;
  RecorderWidget({localFileSystem, this.wordData})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new RecorderWidgetState();
}

class RecorderWidgetState extends State<RecorderWidget> {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool serverProcessing = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: (_currentStatus == RecordingStatus.Recording)
          ? Colors.redAccent
          : Colors.blueAccent,
      onPressed: () {
        switch (_currentStatus) {
          case RecordingStatus.Unset:
            {
              _init().then((_) {
                _start();
              });
              break;
            }
          case RecordingStatus.Recording:
            {
              _stop();
              break;
            }
          default:
            break;
        }
      },
      child: _buildText(_currentStatus),
      pressedOpacity: 0.4,
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath =
            "/audio_record_${cryptoString.CreateCryptoRandomString()}";
        io.Directory appDocDirectory;
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }
        customPath = appDocDirectory.path + customPath;
        _recorder = FlutterAudioRecorder(customPath,
            audioFormat: AudioFormat.WAV, sampleRate: 44100);
        await _recorder.initialized;
        setState(() {
          _currentStatus = RecordingStatus.Initialized;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("Vui lòng cho phép quyền truy cập microphone")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      setState(() {
        _currentStatus = RecordingStatus.Recording;
      });
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    setState(() {
      serverProcessing = true;
    });
    await uploadFile(file);
    setState(() {
      _currentStatus = RecordingStatus.Unset;
      serverProcessing = false;
    });
  }

  Widget _buildText(RecordingStatus status) {
    if (serverProcessing) {
      return CircularProgressIndicator();
    } else {
      var text = "";
      switch (_currentStatus) {
        case RecordingStatus.Unset:
          {
            text = 'Bấm và bắt đầu nói';
            break;
          }
        case RecordingStatus.Recording:
          {
            text = 'Dừng';
            break;
          }
        default:
          break;
      }
      return Text(text, style: TextStyle(color: Colors.white));
    }
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }

  Future uploadFile(File file) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('recordings/${file.basename}');
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    if (this.widget.wordData != null) {
      await wordCheckBloc.checkWord(this.widget.wordData.word, file.basename);
      userDataBloc.refreshData();
    }
    print('File Uploaded');
  }
}
