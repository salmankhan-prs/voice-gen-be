# Voice Generation API

A Ruby on Rails API that converts text to speech using ElevenLabs, stores audio on S3, and provides real-time notifications.

## Features

- **Text-to-Speech Conversion** - Convert text (up to 1000 characters) to audio using ElevenLabs API
- **Background Processing** - Audio generation runs asynchronously using Solid Queue
- **Real-time Updates** - Pusher notifications when audio is ready
- **Email Notifications** - Optional email when processing completes
- **Rate Limiting** - 10 requests/hour per IP for voice generation
- **Audio History** - View all generated audio files

## Tech Stack

- Ruby on Rails 8.1 (API mode)
- PostgreSQL
- Solid Queue (background jobs)
- ElevenLabs API (text-to-speech)
- AWS S3 (audio storage)
- Pusher (real-time notifications)
- AWS SES (email)

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/voice_generations` | Create new voice generation |
| GET | `/api/v1/voice_generations` | List all voice generations |
| GET | `/api/v1/voice_generations/:id` | Get specific voice generation |

### Create Voice Generation

```bash
POST /api/v1/voice_generations
Content-Type: application/json

{
  "voice_generation": {
    "text": "Hello, this is a test",
    "voice_id": "21m00Tcm4TlvDq8ikWAM",
    "notify_email": "user@example.com"  // optional
  }
}
```

**Response:**
```json
{
  "id": 1,
  "text": "Hello, this is a test",
  "status": "pending",
  "voice_id": "21m00Tcm4TlvDq8ikWAM",
  "audio_url": null,
  "created_at": "2026-01-07T12:00:00Z"
}
```

### Pusher Events

Subscribe to channel from `PUSHER_CHANNEL` env variable:

| Event | Description |
|-------|-------------|
| `voice_processing` | Audio generation started |
| `voice_completed` | Audio ready with URL |
| `voice_failed` | Generation failed with error |

## Setup

### Prerequisites

- Ruby 4.0+
- PostgreSQL
- AWS Account (S3, SES)
- ElevenLabs API Key
- Pusher Account

### Installation

```bash
git clone <repo-url>
cd voice-gen
bundle install
```

### Environment Variables

Create `.env` file:

```env
DATABASE_URL=postgresql://user:pass@host:5432/dbname

ELEVENLABS_API_KEY=your_key

AWS_ACCESS_KEY_ID=xxx
AWS_SECRET_ACCESS_KEY=xxx
AWS_REGION=ap-south-1
AWS_BUCKET=your-bucket

PUSHER_APP_ID=xxx
PUSHER_KEY=xxx
PUSHER_SECRET=xxx
PUSHER_CLUSTER=ap2
PUSHER_CHANNEL=voice-gen-updates

SMTP_ADDRESS=email-smtp.ap-south-1.amazonaws.com
SMTP_PORT=587
SMTP_USERNAME=xxx
SMTP_PASSWORD=xxx
SMTP_FROM_EMAIL=noreply@yourdomain.com
```

### Database Setup

```bash
rails db:create db:migrate
```

### Run Server

```bash
rails server
```

## Testing

```bash
bundle exec rspec
```

## Live Demo

- **API:** [Railway URL]
- **Frontend:** [Frontend URL]
- **Video Walkthrough:** [Loom URL]

## Architecture

```
POST /voice_generations
        ↓
  Create record (status: pending)
        ↓
  Queue GenerateVoiceJob
        ↓
  Return response immediately
        ↓
  [Background]
        ↓
  Call ElevenLabs API → Upload to S3 → Update record
        ↓
  Send Pusher notification
        ↓
  Send email (if requested)
```

## Rate Limits

| Endpoint | Limit |
|----------|-------|
| POST /voice_generations | 10/hour per IP |
| All API endpoints | 100/minute per IP |
