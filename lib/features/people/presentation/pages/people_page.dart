import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:muvo/features/people/domain/entities/person.dart';
import 'package:muvo/features/people/presentation/bloc/people/people_bloc.dart';
import 'package:muvo/features/people/presentation/widgets/person_card.dart';
import 'package:muvo/core/config/app_config.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<PeopleBloc>()..add(LoadPeople()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Personas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: Implementar búsqueda
              },
            ),
          ],
        ),
        body: BlocBuilder<PeopleBloc, PeopleState>(
          builder: (context, state) {
            if (state is PeopleLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is PeopleError) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is PeopleLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.people.length,
                itemBuilder: (context, index) {
                  final person = state.people[index];
                  return PersonCard(
                    person: person,
                    onTap: () {
                      // TODO: Navegar a detalles de la persona
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
} 