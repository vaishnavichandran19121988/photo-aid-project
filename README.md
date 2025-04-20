# backend

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)

An example application built with dart_frog

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis





# 📸 Photo Aid App

**Photo Aid** is a full-stack Flutter + Dart backend application designed to connect users in need of help (Requesters) with those offering assistance (Helpers). It features live chat, map-based requests, user profiles, ratings, and more.

---

## 👨‍💻 Team Members

- **Vaishnavi Ravichandran**
- **Sharumathi**
- **Roozbeh**
- **Sui**
- **Benard**

---

## 🧩 Tech Stack

| Layer     | Tech                          |
|-----------|-------------------------------|
| Frontend  | Flutter                       |
| Backend   | Dart Frog (Dart)              |
| Database  | PostgreSQL                    |
| Auth      | JWT Authentication            |
| Deployment | GitHub                       |

---

## ⚙️ Features

- ✅ User Registration & Login
- ✅ Map Integration (Send / Accept Help Requests)
- ✅ Live Chat (Text + Media)
- ✅ User Ratings & Reviews
- ✅ Profile Management
- ✅ Secure JWT-based Auth

---

## 🗂️ Project Structure

```
photo-aid-project-main/
├── backend/
│   ├── lib/                  # DB connection
│   ├── routes/               # Dart Frog endpoints
│   ├── migrations/           # SQL scripts
│   ├── .env                  # Environment file
│   └── pubspec.yaml
│
├── frontend/                 # Flutter mobile/web app
│   ├── lib/
│   └── pubspec.yaml
│
├── .gitignore
├── README.md
├── pubspec.yaml
└── analysis_options.yaml
```

---

## 🔧 Setup Instructions

### 1. Backend

```bash
cd backend

# Create DB first (PostgreSQL)
# Then apply SQL migrations manually or via script

# Run backend server
dart_frog dev
```

> Make sure `.env` file includes:
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=photo_aid_db
DB_USER=postgres
DB_PASSWORD=1234
JWT_SECRET=12345678
```

---

### 2. Frontend

```bash
cd frontend
flutter pub get
flutter run
```

---

## ✅ Status

- [x] Backend APIs implemented
- [x] Frontend integrated with APIs
- [x] Login / Register working
- [x] Sessions and Ratings functioning
- [x] Project pushed to GitHub (Main branch)

---

## 📌 Notes

> This project is a **university assignment** and not intended for production use.


