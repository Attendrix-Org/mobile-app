import '/components/note_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'quick_notes_widget.dart' show QuickNotesWidget;
import 'package:flutter/material.dart';

class QuickNotesModel extends FlutterFlowModel<QuickNotesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for NoteCard.
  late NoteCardModel noteCardModel;

  @override
  void initState(BuildContext context) {
    noteCardModel = createModel(context, () => NoteCardModel());
  }

  @override
  void dispose() {
    noteCardModel.dispose();
  }
}
