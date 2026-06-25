# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.2.0] - Unreleased

### Added

- Add characterize_each
- limit and offset query methods on RelationCollection

### Changed

- Characterized relations delegate the full Active Record query API

### Fixed

- Render with/without content correctly on Rails 8
- The #with feature control works now that Object#with is defined
- Collection.for no longer raises for plain enumerables
- Support Rails 8 and Ruby 4.0

## [0.0.1] - 2014-06-17

### Added

- Initial gem adding characterize method to rails controllers
