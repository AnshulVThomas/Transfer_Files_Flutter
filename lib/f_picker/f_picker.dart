import 'package:file_picker/file_picker.dart';
class f_picker{
  // final List<String?> _f_paths=[];

  Future<List<String?>> pick()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    return result!=null ? result.paths : [];
  }

}

