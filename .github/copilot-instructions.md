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

## Data and Database Design Constraints
1. Unauthenticated Public Views: Guest users can access the app without a login wall. They can search books, view book profiles, and read reviews.
2. Protected Actions: Writing reviews or adding books to shelves requires authentication. Trigger an elegant `AuthGuard` bottom sheet prompt to Continue with Facebook if a guest tries these actions.
3. Firestore Collections:
	- `/users/{userId}`: Profiles.
	- `/books/{bookId}`: Created only when a book is first shelved or reviewed. Uses Google Books API ID as the document ID.
	- `/reviews/{reviewId}`: Root collection containing `bookId` and `userId` for quick querying.
	- `/userBooks/{userId_bookId}`: Composite ID documents managing user reading statuses (`want_to_read`, `reading`, `completed`).
