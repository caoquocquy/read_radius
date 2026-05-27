# ReadRadius Copilot Instructions

## Stack
- **Framework**: Flutter (latest stable, Material 3).
- **State Management**: Riverpod (latest stable, `@riverpod` + `build_runner`). Never use legacy syntax or `ChangeNotifierProvider`. `StateProvider` is allowed for simple ephemeral UI state.
- **Backend**: Firebase (Auth, Cloud Firestore).
- **Auth**: Facebook Login ONLY via `flutter_facebook_auth`. No email/password or anonymous.
- **Book Data**: Fetched from Google Books API. Do not pre-populate Firestore.

## Architecture
Feature-first under `lib/features/`. Shared code (themes, network clients, constants, utilities) under `lib/core/`.

Every feature must have all 4 layers: `data/`, `domain/`, `providers/`, `presentation/` (add `.gitkeep` for empty layers). Dependency direction: `presentation -> domain -> data`. Presentation must not call SDKs, Firestore, or HTTP clients directly. Do not leak DTOs or raw maps into widgets.

Providers belong to their own feature's `providers/` directory. Avoid cross-feature provider dependencies for feature-specific logic; move consumed providers into the consuming feature instead. Shared cross-cutting providers (e.g. `auth`, `firestore`) are fine as common deps.

## Data & Database
- Guests can browse/search books and read reviews without login.
- Writing reviews or adding books to shelves requires auth. Prompt guests with `AuthGuardSheet`.
- **Firestore Collections**:
  - `/users/{userId}` — profiles, owner-only write.
  - `/books/{bookId}` — created when first shelved/reviewed; Google Books API ID as doc ID.
  - `/reviews/{reviewId}` — root collection, public read, owner-only write.
  - `/userBooks/{userId_bookId}` — composite ID, owner-only write. Allowed keys: `userId`, `bookId`, `status` (`want_to_read`, `reading`, `completed`), `currentPercent` (int 0-100), `progressUpdatedAt`, `createdAt`, `updatedAt`. No `currentPage`/`totalPages`.
  - `/userFollows/{followerId_followeeId}` — directed follow edges. Create/delete follower-only, updates disallowed, self-follow denied.
- Reading progress UX is percent-driven (progress bar + quick-select 10/20/.../100), not page numbers.
- Deny all writes when unauthenticated.

## Firebase CLI
Config files in repo root: `firebase.json`, `.firebaserc` (project `readradius-c499b`). Deploy via:
- `firebase deploy --only firestore:rules`
- `firebase deploy --only firestore:indexes`

## Style
- Use `@riverpod` on classes/functions. Use `.when(data:, error:, loading:)`. Prefer `async/await`. Keep state immutable (copyWith). Wrap Firebase/network calls in try-catch with user-friendly feedback.
- Files should be focused (single responsibility). Target: widgets 100-250 lines, screens ≤400, domain/data 150-300. Generated files exempt. Extract reusable widgets early.

## Quality Gate
- `flutter analyze` — no new errors.
- `flutter test` — impacted areas covered.
- If `firestore.rules` or `firestore.indexes.json` changes, deploy before closing.