# Evolve – Adaptive Goals & Habits Coach

> An AI-powered mobile coach that doesn't just track your habits — it actively guides you.

[![Flutter](https://img.shields.io/badge/Flutter-3.41-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11-blue?logo=dart)](https://dart.dev)
[![Claude](https://img.shields.io/badge/AI-Claude%20Sonnet-blueviolet?logo=anthropic)](https://anthropic.com)
[![Supabase](https://img.shields.io/badge/Backend-Supabase-green?logo=supabase)](https://supabase.com)

---

## What is Evolve?

Most habit trackers are static — you log data, see a graph, done. **Evolve** acts as a co-pilot:

- **AI Coach Chat** — context-aware conversation that knows your goals, recent logs, and streaks. Powered by Claude.
- **SMART Goal Management** — create goals with AI-assisted milestones and timelines.
- **Habit Tracking** — daily, weekday, or custom frequency. Streak tracking, activity heatmaps.
- **Predictive Insights** — see your probability of hitting a goal based on current pace.
- **Quick Logging** — tap to complete, or type naturally ("ran 5km this morning").
- **Chat Onboarding** — the coach learns about you before you see the dashboard.
- **Weekly AI Review** — generated summary of achievements and recommendations.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter 3.41 (iOS + Android) |
| State | Riverpod 2.x |
| Local Storage | Hive (offline-first) |
| Auth & DB | Supabase |
| AI Coach | Anthropic Claude API (streaming) |
| Navigation | GoRouter |
| Networking | Dio |
| Charts | fl_chart |

---

## Project Structure

```
lib/
├── core/               # Shared infrastructure (theme, routing, DI, network)
├── features/
│   ├── auth/           # Login, signup, Supabase auth
│   ├── onboarding/     # Chat-based AI onboarding flow
│   ├── dashboard/      # Home screen, today's focus, progress rings
│   ├── goals/          # SMART goal CRUD, progress tracking
│   ├── habits/         # Habit management, streaks, heatmap
│   ├── logging/        # Quick log bottom sheet
│   ├── coach/          # Streaming AI chat with Claude
│   ├── insights/       # Completion probability, off-track alerts
│   └── settings/       # Theme, notifications, account
└── shared/             # Reusable widgets
```

Each feature follows a layered structure: `data/` → `domain/` → `presentation/`.

---

## Getting Started

### Prerequisites

- Flutter 3.41+
- Dart 3.11+
- A [Supabase](https://supabase.com) project
- An [Anthropic API key](https://console.anthropic.com)

### Setup

1. **Clone the repo**

```bash
git clone https://github.com/ejkennedy/evolve-app.git
cd evolve-app
```

2. **Create your `.env` file** (never commit this)

```bash
cp .env.example .env
# Edit .env with your Supabase URL, anon key, and Anthropic API key
```

3. **Install dependencies**

```bash
flutter pub get
```

4. **Run code generation** (Hive adapters, Freezed models, env obfuscation)

```bash
dart run build_runner build --delete-conflicting-outputs
```

5. **Create asset directories** (fonts need to be downloaded separately)

```bash
mkdir -p assets/fonts assets/images assets/animations
```

6. **Run the app**

```bash
flutter run
```

### Supabase Setup

Create the following tables in your Supabase project:

- `users` — extends auth.users with display_name, onboarding_data
- `goals` — goal records synced from local Hive storage
- `habits` — habit definitions
- `habit_logs` — individual completion events

Row-level security (RLS) should be enabled on all tables, with policies that restrict each user to their own data.

---

## Roadmap

### Phase 1 – MVP (current)
- [x] Flutter project scaffold with Riverpod, GoRouter, Hive
- [x] Dark/light Material 3 theme with Inter font
- [x] Supabase authentication (email/password)
- [x] Chat-based AI onboarding
- [x] Dashboard with goal progress and today's habits
- [x] Goal CRUD with progress logging
- [x] Habit tracking with streaks and activity heatmap
- [x] Quick log bottom sheet
- [x] Streaming AI coach chat (Claude API)
- [x] Predictive insights (completion probability)
- [x] Settings screen

### Phase 2 – Backend & Predictions
- [ ] FastAPI Python backend (Cloudflare Workers or VPS)
- [ ] PostgreSQL schema + Supabase sync
- [ ] Time-series forecasting model (XGBoost per-goal)
- [ ] Nightly background jobs (Celery)
- [ ] AI weekly review generation
- [ ] FCM push notifications

### Phase 3 – Advanced AI & Polish
- [ ] Voice logging (Whisper transcription + NLP parsing)
- [ ] Fine-tuned coaching model
- [ ] Rich visualisations (fl_chart)
- [ ] Wearables integration (HealthKit / Health Connect)
- [ ] App icon + splash screen
- [ ] App Store / Play Store release

---

## Architecture Notes

**Offline-first**: All data is written to Hive immediately. Supabase sync happens in the background when online. The UI never waits for a network response to show the user their data.

**AI Coach**: In Phase 1, the Flutter app calls the Anthropic API directly via Dio. The API key is embedded at compile time using `envied` (obfuscated, not shipped as a file). In Phase 2, this moves to the FastAPI backend — a single URL change in `CoachRepository`.

**Streaming chat**: Claude's streaming API (`text/event-stream`) is consumed token-by-token. The `CoachNotifier` accumulates tokens into a placeholder `ChatMessage` with `isStreaming: true`, giving a live typewriter effect. On stream close, the final message is persisted to Hive.

**Riverpod**: Uses the `StateNotifier` pattern for Phase 1. All providers live close to their feature. Infrastructure providers are declared in `core/di/providers.dart`.

---

## License

MIT
