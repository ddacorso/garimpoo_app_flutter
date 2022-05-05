import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:garimpoo/model/Keyword.dart';
import 'package:garimpoo/model/Filter.dart' as model;
import 'package:garimpoo/repository/client_repository.dart';
import 'package:meta/meta.dart';

import '../local_storage/local_storage_repository.dart';
import '../model/Filter.dart';
import '../repository/auth_repository.dart';
import '../shared/Credentials.dart';

part 'filter_event.dart';

part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final ClientRepository clientRepository;
  final Credentials credentials = Credentials();
  final AuthRepository authRepository;

  FilterBloc({required this.clientRepository, required this.authRepository}) : super(FilterLoading()) {


    on<FilterLoadTab>((event, emit) async {

      emit(FilterLoading());

      emit(FilterShowReady(event.index, event.filterScreen));

    });


    on<FilterRequestLoad>((event, emit) async {

      emit(FilterLoading());
      await authRepository.refreshToken();
      Filter filter =  await clientRepository.getFilter(
          LocalStorageShared.instance.getString("X-Firebase-Auth")!);

      credentials.filter = filter;

      model.FilterScreen filterScreen = model.FilterScreen(
          keywords: filter.keywords == null ? [] : List.from(filter.keywords!),
          maxKeywords: filter.maxKeywords,
          maxNotifications: filter.maxNotifications,
          isPublishedToday: filter.isPublishedToday,
          isFinishingToday: filter.isFinishingToday,
          id: filter.id,
          keywordFocus: filter.keywords == null ? [] : filter.keywords!
              .where((element) => element.type == 'key')
              .map((e) => FocusNode())
              .toList(),
          notificationFocus: filter.keywords == null ? [] : filter.keywords!
              .where((element) => element.type == 'not')
              .map((e) => FocusNode())
              .toList(),
          keywordController: filter.keywords == null ? [] : filter.keywords!
              .where((element) => element.type == 'key')
              .map((Keyword e) => TextEditingController(text: e.value))
              .toList(),
          notificationController: filter.keywords == null ? [] : filter.keywords!
              .where((element) => element.type == 'not')
              .map((e) => TextEditingController(text: e.value))
              .toList());

      emit(FilterShowReady(0, filterScreen));

    });


    on<FilterRequestSave>((event, emit) async {
      emit(FilterLoading());
      List<Keyword> keys = event.filterScreen.keywords
          .where((element) => element.type == 'key')
          .toList();
      List<Keyword> not = event.filterScreen.keywords
          .where((element) => element.type == 'not')
          .toList();

      List<Keyword> keywords = [];

      for (var i = 0; i < keys.length; i++) {
        keywords.add(Keyword(
            id: keys[i].id,
            value: event.filterScreen.keywordController![i].text,
            isActive: keys[i].isActive,
            type: keys[i].type));
      }

      for (var i = 0; i < not.length; i++) {
        keywords.add(Keyword(
            id: not[i].id,
            value: event.filterScreen.notificationController![i].text,
            isActive: not[i].isActive,
            type: not[i].type));
      }

      Filter filter = Filter(
          isPublishedToday: event.filterScreen.isPublishedToday,
          maxKeywords: event.filterScreen.maxKeywords,
          isFinishingToday: event.filterScreen.isFinishingToday,
          maxNotifications: event.filterScreen.maxKeywords,
          keywords: keywords,
          id: event.filterScreen.id);

      try {
        await authRepository.refreshToken();
         filter = await clientRepository.updateFilter(
            LocalStorageShared.instance.getString("X-Firebase-Auth")!, filter);


         credentials.filter = filter;

         model.FilterScreen filterScreen = model.FilterScreen(
             keywords:  filter.keywords == null ? [] : List.from(filter.keywords!),
             maxKeywords: filter.maxKeywords,
             maxNotifications: filter.maxNotifications,
             isPublishedToday: filter.isPublishedToday,
             isFinishingToday: filter.isFinishingToday,
             id: filter.id,
             keywordFocus: filter.keywords == null ? [] : filter.keywords!
                 .where((element) => element.type == 'key')
                 .map((e) => FocusNode())
                 .toList(),
             notificationFocus: filter.keywords == null ? [] : filter.keywords!
                 .where((element) => element.type == 'not')
                 .map((e) => FocusNode())
                 .toList(),
             keywordController:filter.keywords == null ? [] : filter.keywords!
                 .where((element) => element.type == 'key')
                 .map((Keyword e) => TextEditingController(text: e.value))
                 .toList(),
             notificationController: filter.keywords == null ? [] : filter.keywords!
                 .where((element) => element.type == 'not')
                 .map((e) => TextEditingController(text: e.value))
                 .toList());

         emit(FilterShowReady(event.pageIndex, filterScreen));
      } catch (e) {
        emit(FilterError(e.toString()));
        emit(FilterShowReady(event.pageIndex, event.filterScreen));
      }
    });




    on<FilterAddKeyword>((event, emit) async {
      List<Keyword> newKeywords = List.from(event.filterScreen.keywords);

      List<FocusNode> notificationFocus =
          List.from(event.filterScreen.notificationFocus!);
      List<TextEditingController> notificationController =
          List.from(event.filterScreen.notificationController!);

      List<FocusNode> keywordFocus =
          List.from(event.filterScreen.keywordFocus!);
      List<TextEditingController> keywordController =
          List.from(event.filterScreen.keywordController!);

      newKeywords
          .add(Keyword(id: null, value: '', isActive: true, type: event.type));

      if (event.type == 'key') {
        keywordFocus.add(FocusNode());
        keywordController.add(TextEditingController());
      } else {
        notificationFocus.add(FocusNode());
        notificationController.add(TextEditingController());
      }

      FilterScreen filter = FilterScreen(
        keywords: newKeywords,
        id: event.filterScreen.id,
        isFinishingToday: event.filterScreen.isFinishingToday,
        isPublishedToday: event.filterScreen.isPublishedToday,
        maxNotifications: event.filterScreen.maxNotifications,
        maxKeywords: event.filterScreen.maxKeywords,
        keywordController: keywordController,
        keywordFocus: keywordFocus,
        notificationFocus: notificationFocus,
        notificationController: notificationController,
      );

      emit(FilterShowReady(event.type == 'key' ? 0 : 2, filter));
    });

    on<FilterSwitchValue>((event, emit) async {
      List<Keyword> newKeywords = List.from(event.filterScreen.keywords);
      bool isPublishedToday = event.filterScreen.isPublishedToday;
      bool isFinishingToday = event.filterScreen.isFinishingToday;

      if (event.pageIndex == 0) {
        newKeywords[event.itemIndex] = Keyword(
            id: newKeywords[event.itemIndex].id,
            value: newKeywords[event.itemIndex].value,
            isActive: event.value,
            type: 'key');
      }

      if (event.pageIndex == 1) {
        if (event.itemIndex == 0) {
          isPublishedToday = event.value;
        }

        if (event.itemIndex == 1) {
          isFinishingToday = event.value;
        }
      }

      if (event.pageIndex == 2) {
        newKeywords[event.itemIndex] = Keyword(
            id: newKeywords[event.itemIndex].id,
            value: newKeywords[event.itemIndex].value,
            isActive: event.value,
            type: 'not');
      }

      FilterScreen filter = FilterScreen(
        keywords: newKeywords,
        id: event.filterScreen.id,
        isFinishingToday: isFinishingToday,
        isPublishedToday: isPublishedToday,
        maxNotifications: event.filterScreen.maxNotifications,
        maxKeywords: event.filterScreen.maxKeywords,
        keywordController: event.filterScreen.keywordController,
        keywordFocus: event.filterScreen.keywordFocus,
        notificationFocus: event.filterScreen.notificationFocus,
        notificationController: event.filterScreen.notificationController,
      );

      emit(FilterShowReady(event.pageIndex, filter));
    });
  }
}
