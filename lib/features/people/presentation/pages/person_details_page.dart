import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muvo/features/people/presentation/bloc/people/people_bloc.dart';
import 'package:muvo/core/utils/image_utils.dart';

class PersonDetailsPage extends StatelessWidget {
  final int personId;

  const PersonDetailsPage({
    super.key,
    required this.personId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<PeopleBloc>()..add(LoadPersonDetails(personId)),
      child: Scaffold(
        body: BlocBuilder<PeopleBloc, PeopleState>(
          builder: (context, state) {
            if (state is PeopleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PersonDetailsLoaded) {
              final person = state.person;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        ImageUtils.getProfileImageUrl(person.profilePath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.person, size: 100),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            person.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          if (person.birthday != null) ...[
                            Text(
                              'Fecha de nacimiento: ${person.birthday}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 4),
                          ],
                          if (person.placeOfBirth != null) ...[
                            Text(
                              'Lugar de nacimiento: ${person.placeOfBirth}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 4),
                          ],
                          if (person.biography != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Biografía',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              person.biography!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is PeopleError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No se encontró información'));
          },
        ),
      ),
    );
  }
} 