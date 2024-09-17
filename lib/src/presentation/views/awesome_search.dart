import 'dart:async';

import 'package:awesome_place_search/src/core/services/debouncer.dart';
import 'package:awesome_place_search/src/data/models/places_types.dart';
import 'package:awesome_place_search/src/data/models/prediction_model.dart';
import 'package:awesome_place_search/src/presentation/controller/awesome_place_search_controller.dart';
import 'package:awesome_place_search/src/presentation/controller/search_state.dart';
import 'package:flutter/material.dart';

///[AwesomePlaceSearch]
/// This is the Main Class
class AwesomePlacesSearch extends StatefulWidget {
  const AwesomePlacesSearch({
    super.key,
    required this.controller,
    required this.onSelected,
    required this.itemBuilder,
    required this.searchBuilder,
    required this.noneBuilder,
    required this.emptyBuilder,
    required this.loadingBuilder,
    required this.invalidKeyBuilder,
    required this.errorBuilder,
    this.debounce = const Duration(milliseconds: 500),
    this.hint,
    this.errorText,
  });

  final String? hint;
  final String? errorText;
  final Duration debounce;

  final WidgetBuilder loadingBuilder;
  final WidgetBuilder noneBuilder;
  final WidgetBuilder emptyBuilder;
  final WidgetBuilder invalidKeyBuilder;
  final WidgetBuilder errorBuilder;
  final ValueSetter<PredictionModel> onSelected;
  final AwesomePlaceSearchController controller;
  final Widget Function(
    BuildContext context,
    String title,
    String address,
    VoidCallback onTap,
  ) itemBuilder;

  final Widget Function(
    BuildContext context,
    ValueSetter<String> onChanged,
  ) searchBuilder;

  @override
  State<AwesomePlacesSearch> createState() => _AwesomePlacesSearchState();
}

class _AwesomePlacesSearchState extends State<AwesomePlacesSearch> {
  late final Debounce _debounce;
  SearchState _searchState = SearchState.none;
  List<PredictionModel> _places = [];
  get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _debounce = Debounce(duration: widget.debounce);
  }

  void _searchData(String searchString) async {
    setState(() {
      _searchState = SearchState.loading;
    });

    final result = await _controller.getPlaces(searchString: searchString);
    if(result.$1 != null){
      setState(() {
        _searchState = _controller.mapError(result.$1!);
      });
      return;
    }

    setState(() {
      _places = result.$2!.predictions ?? [];
      _searchState = SearchState.success;
    });
  }

  ///[_buildItem]
  ///Item of place result list
  Widget _buildItem({required PredictionModel place}) {
    return widget.itemBuilder(context, place.description ?? "", place.structuredFormatting!.secondaryText ?? "",
        () async {
      final result = await _controller.getDetails(value: place.placeId ?? "");
      if(result.$1 != null) {
        setState(() {
          _searchState = SearchState.serverError;
        });
        return;
      }

      final right = result.$2!;
      place.details = right;
      widget.onSelected(place);
    });
  }

  ///[_buildPlacesList]
  ///Show all places result
  Widget _buildPlacesList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      itemCount: _places.length,
      itemBuilder: (context, index) {
        return _buildItem(place: _places[index]);
      },
    );
  }

  ///[_buildContent]
  Widget _buildContent() {
    if (_searchState == SearchState.none) {
      return widget.noneBuilder(context);
    }
    if (_searchState == SearchState.empty) {
      return widget.emptyBuilder(context);
    }
    if (_searchState == SearchState.loading) {
      return widget.loadingBuilder(context);
    }

    if (_searchState == SearchState.invalidKey) {
      return widget.invalidKeyBuilder(context);
    }

    if (_searchState == SearchState.serverError) {
      return widget.errorBuilder(context);
    }

    return _buildPlacesList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.searchBuilder(context, (value) {
          _debounce(callback: () {
            if (value.isEmpty) {
              setState(() => _searchState = SearchState.none);
              return;
            }

            _searchData(value);
          });
        }),
        Expanded(child: _buildContent()),
      ],
    );
  }
}
