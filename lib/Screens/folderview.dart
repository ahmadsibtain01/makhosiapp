import 'package:flutter/material.dart';
import 'package:makhosi_app/Screens/local_widgets/mygridview.dart';
import 'package:makhosi_app/utils/app_colors.dart';

class FolderViewPage extends StatefulWidget {
  final folderFilesUrls;
  final title;
  FolderViewPage({
    @required this.folderFilesUrls,
    @required this.title,
    Key key,
  }) : super(key: key);

  @override
  _FolderViewPageState createState() => _FolderViewPageState();
}

class _FolderViewPageState extends State<FolderViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: widget.folderFilesUrls.length != 0
          ? MyGridView(
              contentList: widget.folderFilesUrls,
              onPressed: (url) {
                print('url: ' + url);
              },
            )
          : Center(
              child: Text('Empty'),
            ),
    );
  }

  floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.COLOR_PRIMARY,
      child: Icon(Icons.add),
      onPressed: () {},
    );
  }
}
