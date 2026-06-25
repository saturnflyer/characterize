# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.2.0] - 2026-06-25

### Added

- Add characterize_each
- limit and offset query methods on RelationCollection
- limit and offset query methods on RelationCollection (4a8380f)

### Changed

- Characterized relations delegate the full Active Record query API
- characterized relations delegate the full Active Record query API (bebae4a)

### Fixed

- Render with/without content correctly on Rails 8
- The #with feature control works now that Object#with is defined
- Collection.for no longer raises for plain enumerables
- Support Rails 8 and Ruby 4.0
- Render with/without content correctly on Rails 8 (35c25cf)
- #with feature control works now that Object#with is defined (1020ccd)
- Collection.for no longer raises for plain enumerables (4a8380f)
- Load Active Record query delegators under Ruby 4.0 (4a8380f)

## [0.0.3] - 2015-01-27

### Added

- Allow setting a list of standard features
- Support configuring the module suffix

### Changed

- Rename character methods to use "features"
