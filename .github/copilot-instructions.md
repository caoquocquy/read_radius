# BookRadius Copilot Instructions

## Technology Stack & Constraints
- **Framework**: Flutter (latest stable, Material 3 design system).
- **State Management**: Riverpod (latest stable, using `@riverpod` annotations and `build_runner` code generation). Never use old legacy Riverpod syntax.
- **Backend & Database**: Firebase (Firebase Auth, Cloud Firestore).
- **Authentication**: Facebook Login ONLY via `flutter_facebook_auth`. No email/password or anonymous login.
- **Book Data**: External data is fetched directly from the Google Books API. Do not pre-populate Firestore with millions of books.

## Architecture & Folder Structure
Follow a feature-first approach. Code should be clean, modular, and split into the following directories under `lib/`:
- `lib/core/`: Common themes, network clients, constants, utilities.
- `lib/features/auth/`: Facebook authentication widgets, services, and Riverpod providers.
- `lib/features/wall/`: Public search UI, Google Books API client, book grids.
- `lib/features/shelves/`: Managing user book statuses (Want to Read, Reading, Completed).
- `lib/features/reviews/`: Review grids, writing reviews, star ratings.
- `lib/features/friends/`: Social features and friend activity streams.

Layer boundaries must be enforced:
- Dependency direction is one-way only: `presentation -> domain -> data`.
- Presentation layer must not call Firebase SDKs, Firestore directly, or HTTP clients.
- Domain layer defines entities, repository contracts, and use-case logic.
- Data layer implements repository contracts, DTO mapping, and remote/local data sources.
- Do not leak DTOs, raw maps, or Firestore document data into presentation widgets.

## Data & Database Design Constraints
1. **Unauthenticated Public Views**: Guest users can access the app without a login wall. They can search books, view book profiles, and read reviews.
2. **Protected Actions**: Writing reviews or adding books to shelves requires authentication. Trigger an elegant `AuthGuard` bottom sheet prompt to "Continue with Facebook" if a guest tries these actions.
3. **Firestore Collections**:
   - `/users/{userId}`: Profiles.
   - `/books/{bookId}`: Created ONLY when a book is first shelved or reviewed. Uses Google Books API ID as the Document ID.
   - `/reviews/{reviewId}`: Root collection containing `bookId` and `userId` for quick querying.
   - `/userBooks/{userId_bookId}`: Composite ID documents managing user reading statuses (`want_to_read`, `reading`, `completed`).
4. **Firestore Security Rule Intent**:
   - Guests can read public browse content (`/books` and public review content) but cannot write user-owned records.
   - `/users/{userId}` writes are owner-only (`request.auth.uid == userId`).
   - `/userBooks/{userId_bookId}` writes are owner-only and must match the authenticated user.
   - `/reviews/{reviewId}` create, update, and delete are owner-only; public reads are allowed.
   - Deny all writes when unauthenticated.

## Code Generation & Style Guidelines
- **Riverpod**: Always use `@riverpod` on classes extending `_$ClassName` or functions for app/business state. Avoid `ChangeNotifierProvider`. `StateProvider` is allowed only for simple ephemeral UI-only state.
- **Async Data**: Always handle UI states safely using Riverpod's `.when(data: ..., error: ..., loading: ...)` pattern.
- **Asynchronous Code**: Prefer `async/await` syntax over `.then()` callbacks.
- **State Mutation**: Keep state immutable. Use copyWith patterns for data models.
- **Error Handling**: Wrap all Firebase, authentication, and network API calls in clean `try-catch` blocks with user-friendly logs or UI snackbars.

## Quality Gate for Every Change
- Run `flutter analyze` and keep touched code free of analyzer errors.
- Run `flutter test` for impacted areas before finishing.
- Any behavior change must include matching tests (unit/widget; integration when relevant).
