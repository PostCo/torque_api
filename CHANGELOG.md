# Changelog

## [0.1.0] - 2025-03-04

### Added
- Initial release
- `TorqueAPI::Client` with Faraday, Basic auth, sandbox toggle, and client-specific headers
- `TorqueAPI::PreAdviceResource` — POST `/preAdvice` (passthrough payload)
- `TorqueAPI::ReturnRmaResource` — GET `/returnRma` with typed response objects
- `TorqueAPI::Object` — OpenStruct-based response wrapper with auto snake_case keys and `original_response`
- Comprehensive error hierarchy: `APIError`, `AuthenticationError`, `ValidationError`, `NotFoundError`, `RateLimitError`, `ServerError`
