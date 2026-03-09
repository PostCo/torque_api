# Changelog

## [0.1.1] - 2026-03-09

### Fixed
- JSON response parsing now works regardless of Torque's Content-Type header (fallback parser)
- Return RMA list returns the full response object instead of extracting only nested items

### Changed
- Both `pre_advice.create` and `return_rma.list` now return typed response objects (`Objects::PreAdviceResponse`, `Objects::ReturnRmaResponse`) instead of generic `Base`
- Response objects provide snake_case accessors and `.raw` for the original response

## [0.1.0] - 2025-03-04

### Added
- Initial release
- `TorqueAPI::Client` with Faraday, Basic auth, sandbox toggle, and client-specific headers
- `TorqueAPI::PreAdviceResource` — POST `/preAdvice` (passthrough payload)
- `TorqueAPI::ReturnRmaResource` — GET `/returnRma` with typed response objects
- `TorqueAPI::Object` — OpenStruct-based response wrapper with auto snake_case keys and `original_response`
- Comprehensive error hierarchy: `APIError`, `AuthenticationError`, `ValidationError`, `NotFoundError`, `RateLimitError`, `ServerError`
