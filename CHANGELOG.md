# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-07-16

### Changed

- Minimum supported Ruby is now 3.3 (was 2.5).
- `SitePrism::TimeoutError` is resolved at runtime, so both site_prism 5 and 6 are supported.
- `site_prism` dependency narrowed to `>= 5.0, < 7`.
- Development dependencies moved from the gemspec to the `Gemfile`.
- Gemspec now publishes `metadata` links (source, changelog, bug tracker) and requires MFA for releases.

### Removed

- The `webdrivers` development dependency. Selenium Manager, bundled with
  `selenium-webdriver >= 4.6`, resolves browser drivers instead.

## [1.0.1] - 2024-12-14

- Sequential loading of page objects.

## [1.0.0] - 2024-02-13

- First public release.

[1.1.0]: https://github.com/prism-checker/prism_checker/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/prism-checker/prism_checker/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/prism-checker/prism_checker/releases/tag/v1.0.0
