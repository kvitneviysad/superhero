# Superhero Archive – Aplikacja Mobilna Flutter

Nowoczesna, responsywna aplikacja mobilna stworzona w środowisku **Flutter** przy użyciu **Android Studio**, zoptymalizowana pod kątem urządzeń z systemem Android (testowana i w pełni kompatybilna z serią Google Pixel 6 oraz Pixel 9). Aplikacja integruje się z zewnętrznym interfejsem **SuperHero API** i implementuje zaawansowane mechanizmy buforowania danych w celu zapewnienia pełnej funkcjonalności w trybie offline.

Projekt został zrealizowany jako zaliczenie z przedmiotu **TAM (Technologie Aplikacji Mobilnych)** i w pełni spełnia (oraz rozszerza) wymagania na **ocenę 4.0**.

---

## 🚀 Główne Funkcje i Spełnione Wymagania (Ocena 4.0+)

*   **Architektura wieloekranowa:** Aplikacja składa się z dwóch głównych ekranów:
    *   **Ekran Główny (Search Screen):** Wyposażony w dynamiczny pasek wyszukiwania, prezentujący wyniki w formie estetycznej siatki kart z wizerunkami i podstawowymi informacjami o superbohaterach.
    *   **Ekran Szczegółów (Detail Screen):** Wyświetlany po kliknięciu w kartę bohatera. Zawiera rozbudowany widok profilowy z zakładkami (TabBak) segregującymi zaawansowane statystyki (Powerstats), biografię, wygląd oraz pracę.
*   **Obsługa dwóch różnych zapytań REST:** Komunikacja sieciowa realizowana za pomocą wydajnego klienta `Dio`[cite: 7, 11]:
    *   Zapytanie o listę/wyszukiwanie (`GET /api/{token}/search/{name}`)[cite: 2, 11].
    *   Zapytanie o szczegóły konkretnego elementu na podstawie jego identyfikatora ID (`GET /api/{token}/{id}`)[cite: 2, 11].
*   **Pełna dostępność w trybie offline (Lokalna baza danych):** Integracja z szybką bazą danych **Hive**. Każde udane zapytanie online automatycznie zapisuje strukturę JSON obiektów w lokalnych boksach pamięci podręcznej[cite: 1, 21]. W przypadku braku internetu, aplikacja bezawaryjnie pobiera dane z lokalnego cache.
*   **Obsługa stanu ładowania danych:** Podczas asynchronicznego oczekiwania na odpowiedź z serwera, aplikacja wyświetla nowoczesny, animowany efekt szkieletu karty (**Shimmer effect**), co znacząco podnosi komfort użytkowania (UX).
*   **Zaawansowana obsługa błędów:** Wszystkie operacje sieciowe i bazodanowe są zabezpieczone blokami `try-catch`. W przypadku awarii (np. brak sieci, timeout, błędny token) użytkownik widzi czytelny komunikat na ekranie (`ErrorView`) wraz z działającym przyciskiem **"Retry" (Ponów próbę)**[cite: 8, 21].
*   **Historia zmian (Minimum 3 commity):** Przebieg prac nad aplikacją został w pełni odwzorowany w historii repozytorium Git, odzwierciedlając etapowe wdrażanie logiki oraz warstwy wizualnej.

---

## 🏗️ Architektura Projektu (Clean Architecture)

Kod aplikacji został ustrukturyzowany zgodnie z zasadami czystej architektury z wyraźnym podziałem odpowiedzialności (Separation of Concerns), co ułatwia testowanie oraz skalowalność:

```text
lib/
├── main.dart                  # Punkt wejścia aplikacji, inicjalizacja Hive i wstrzykiwanie bloc
├── core/                      # Wspólne komponenty systemowe i narzędzia
│   ├── constants/             # Tokeny API, adresy URL i centralny token designu (AppTheme)
│   ├── error/                 # Definicje wyjątków i obiektów Failure (Network, Server, Cache)
│   └── network/               # Konfiguracja klienta Dio oraz abstrakcja sprawdzania łączności
├── data/                      # Warstwa danych (Infrastruktura)
│   ├── local/                 # Serwis bazy Hive odpowiadający za offline cache
│   ├── remote/                # Źródło danych REST HTTP calls (SuperheroRemoteDataSource)
│   └── repositories/          # Implementacja repozytorium decydująca o wyborze źródła (Network vs Cache)
├── domain/                    # Warstwa logiki biznesowej (Core)
│   └── models/                # Czyste modele domenowe (SuperheroModel) reprezentujące struktury danych
└── presentation/              # Warstwa prezentacji (Interfejs Użytkownika)
    ├── blocs/                 # Zarządzanie stanem (SearchBloc oraz DetailBloc)
    ├── screens/               # Główne ekrany aplikacji (SearchScreen, DetailScreen)
    └── widgets/               # Komponenty wielokrotnego użytku (HeroCard, StatBar, InfoRow, ErrorView)