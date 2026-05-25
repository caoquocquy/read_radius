# BookRadius Copilot Instructions

Build a Flutter + Firebase book tracking app using Riverpod codegen and GoRouter.

## Rules
- Stack: Flutter Material 3, Riverpod with `@riverpod`, Firebase Auth + Firestore, Google Books API.
- Auth: Facebook login only (`flutter_facebook_auth`). No email/password and no anonymous auth.
- Architecture: feature-first with one-way dependencies only: presentation -> domain -> data.
- Folder layout: `lib/core` for shared code, `lib/features/<feature>` for feature code (`presentation`, `domain`, `data`, `providers`).
- Boundary: UI must not call Firebase/Firestore/HTTP clients directly.
- Data: map API/Firestore payloads to typed models before domain/presentation use.
- Access model: guests can browse books/reviews; write actions require auth with an `AuthGuard` prompt.
- Firestore intent: owner-only writes for `/users`, `/userBooks`, and `/reviews`; deny unauthenticated writes.
- Riverpod style: use generated providers for app state; `StateProvider` only for small ephemeral UI state.
- Async/error handling: use `async/await`, explicit loading/error/data states, and do not swallow exceptions.
- Quality gate: run `flutter analyze` and impacted `flutter test`; behavior changes must include tests.
