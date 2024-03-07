import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'newsletter_event.dart';
part 'newsletter_state.dart';

class NewsletterBloc extends Bloc<NewsletterEvent, NewsletterState> {
  NewsletterBloc() : super(NewsletterInitial()) {
    on<NewsletterEvent>((event, emit) {});
  }
}
