import 'dart:convert';
import 'dart:io';
import 'package:testsylo/model/record_file_item.dart';
import 'package:testsylo/page/qcast/qcat_tab/discover_page/record_qcast_list/record_qcast_list_page.dart';
import 'package:video_compress/video_compress.dart';


class RecordQcastListPageViewModel {
  RecordQcastListPageState state;
  List<RecordFileItem> listRecordWithThumb = List();
  bool isLoad = true;
  RecordQcastListPageViewModel(RecordQcastListPageState state) {
    this.state = state;
    if(Platform.isAndroid){
      compressVideo();
    }
    else{
      print("IOOOOOOOSSSS");
      compressVideo();
    }
  }

  compressVideo() async {
    print("compressVideo");
    for (int i = 0; i < state.widget.listRecording.length; i++) {
      File file = state.widget.listRecording[i].file;
      MediaInfo mediaInfo = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: true, // It's false by default
      );
      state.widget.listRecording[i].file = mediaInfo.file;

      //listFrames = await recordFileItem.getAllThumb;
    }
    await getAllThumb();
  }


  getAllThumb() async {

    listRecordWithThumb = List();
    for(int i = 0 ; i < state.widget.listRecording.length ; i++){
      File file = state.widget.listRecording[i].file;

      int fileSizeInBytes = file.lengthSync();
      double fileSizeInKB = fileSizeInBytes / 1024; // KB
      double fileSizeInMB = fileSizeInKB / 1024; // MB
      print( i.toString()  + " -> compress size - "+fileSizeInMB.toString());

      RecordFileItem recordFileItem = RecordFileItem(file, state.widget.listRecording[i].aspectRatio);
      recordFileItem.thumbPath = await recordFileItem.videoThumb;
      listRecordWithThumb.add(recordFileItem);
    }
    Future.delayed(Duration(milliseconds: 300)).then((onValue) {
      state.setState(() {
        state.editIndex = 0;
        isLoad = false;
      });
    });
  }

}
