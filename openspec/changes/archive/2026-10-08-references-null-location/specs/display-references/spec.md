## ADDED Requirements

### Requirement: Every element of the answer is a location
Code that a macro builds may carry no position. A usage inside such code is no place in a file: the answer of a reference lookup SHALL NOT hold it, neither as `null` nor in any other form. Every element of the answer SHALL be a location with a file and a range.

#### Scenario: Type path built by a macro
- **WHEN** a build macro adds a field whose type is a type path built without a position, and the references of the type it names are looked up
- **THEN** the answer holds the usages written in the sources and no `null`
