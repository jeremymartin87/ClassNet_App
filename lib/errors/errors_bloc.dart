import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'errors_event.dart';
part 'errors_state.dart';

class ErrorsBloc extends Bloc<ErrorsEvent, ErrorsState> {
  ErrorsBloc() : super(ErrorsInitial()) {
    on<ErrorsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
