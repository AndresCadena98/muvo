import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muvo/features/people/domain/entities/person.dart';
import 'package:muvo/features/people/domain/repositories/person_repository.dart';

// Events
abstract class PeopleEvent extends Equatable {
  const PeopleEvent();

  @override
  List<Object> get props => [];
}

class LoadPeople extends PeopleEvent {}

class SearchPeople extends PeopleEvent {
  final String query;

  const SearchPeople(this.query);

  @override
  List<Object> get props => [query];
}

class LoadPersonDetails extends PeopleEvent {
  final int personId;

  const LoadPersonDetails(this.personId);

  @override
  List<Object> get props => [personId];
}

// States
abstract class PeopleState extends Equatable {
  const PeopleState();

  @override
  List<Object> get props => [];
}

class PeopleInitial extends PeopleState {}

class PeopleLoading extends PeopleState {}

class PeopleLoaded extends PeopleState {
  final List<Person> people;

  const PeopleLoaded(this.people);

  @override
  List<Object> get props => [people];
}

class PersonDetailsLoaded extends PeopleState {
  final Person person;

  const PersonDetailsLoaded(this.person);

  @override
  List<Object> get props => [person];
}

class PeopleError extends PeopleState {
  final String message;

  const PeopleError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class PeopleBloc extends Bloc<PeopleEvent, PeopleState> {
  final PersonRepository _personRepository;

  PeopleBloc({
    required PersonRepository personRepository,
  })  : _personRepository = personRepository,
        super(PeopleInitial()) {
    on<LoadPeople>(_onLoadPeople);
    on<SearchPeople>(_onSearchPeople);
    on<LoadPersonDetails>(_onLoadPersonDetails);
  }

  Future<void> _onLoadPeople(
    LoadPeople event,
    Emitter<PeopleState> emit,
  ) async {
    try {
      emit(PeopleLoading());
      final people = await _personRepository.getPopularPeople();
      emit(PeopleLoaded(people));
    } catch (e) {
      emit(PeopleError(e.toString()));
    }
  }

  Future<void> _onSearchPeople(
    SearchPeople event,
    Emitter<PeopleState> emit,
  ) async {
    try {
      emit(PeopleLoading());
      final people = await _personRepository.searchPeople(event.query);
      emit(PeopleLoaded(people));
    } catch (e) {
      emit(PeopleError(e.toString()));
    }
  }

  Future<void> _onLoadPersonDetails(
    LoadPersonDetails event,
    Emitter<PeopleState> emit,
  ) async {
    emit(PeopleLoading());
    try {
      final person = await _personRepository.getPersonDetails(event.personId);
      emit(PersonDetailsLoaded(person));
    } catch (e) {
      emit(PeopleError(e.toString()));
    }
  }
} 