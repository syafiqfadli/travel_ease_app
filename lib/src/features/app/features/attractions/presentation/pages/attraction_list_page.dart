import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/app/app_injector.dart';
import 'package:travel_ease_app/src/features/app/core/presentation/widgets/loading_status.dart';
import 'package:travel_ease_app/src/features/app/features/attractions/presentation/bloc/attraction_cubit.dart';
import 'package:travel_ease_app/src/features/app/features/attractions/presentation/widgets/attraction_list_card.dart';

class AttractionListPage extends StatefulWidget {
  final String placeName;

  const AttractionListPage({
    super.key,
    required this.placeName,
  });

  @override
  State<AttractionListPage> createState() => _AttractionListPageState();
}

class _AttractionListPageState extends State<AttractionListPage> {
  final AttractionCubit attractionCubit = appInjector<AttractionCubit>();

  @override
  void initState() {
    super.initState();
    attractionCubit.getAttractions(widget.placeName);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: attractionCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor.navyBlack,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Text('Attractions in ${widget.placeName}'),
          centerTitle: true,
        ),
        body: BlocBuilder<AttractionCubit, AttractionState>(
          builder: (context, state) {
            if (state is AttractionLoaded) {
              final places = state.places;

              if (places.isEmpty) {
                return const Center(
                  child: Text('No attractions available currently.'),
                );
              }

              return GridView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: places.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 280,
                ),
                itemBuilder: (context, index) => AttractionListCard(
                  attractionName: widget.placeName,
                  place: places[index],
                ),
              );
            }

            if (state is AttractionLoading) {
              return LoadingStatus(status: state.message);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
