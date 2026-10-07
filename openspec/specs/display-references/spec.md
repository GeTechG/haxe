# display-references Specification

## Purpose
Say what a reference lookup answers when the files it has to type on the way do not compile: library code in the class paths must not turn a lookup into an error.

## Requirements

### Requirement: A candidate file that does not type does not fail the lookup
To answer a reference lookup (`display/references`, and the lookups that share its search: rename, `display/implementation`) the compiler types the files of the class paths that mention the name and are not part of the compilation. An error in such a file — while its module is loaded or while anything it queued is typed — SHALL NOT fail the request and SHALL NOT be reported in its answer. The answer SHALL hold every usage in the compilation and every usage in the parts of the candidate files that do type.

#### Scenario: Candidate with classes that fail to load
- **WHEN** a file outside the compilation uses the looked-up member in two methods and also declares classes that implement a type that does not exist
- **THEN** the lookup answers with the usages of the compilation and the two usages of that file, not with an error

#### Scenario: Library code that only types in another context
- **WHEN** the class paths hold modules that fail outside a full build (macro-only modules, classes built by a macro that fails in display mode) and they mention the looked-up name
- **THEN** the lookup answers with a list of usages

### Requirement: Every element of the answer is a location
Code that a macro builds may carry no position. A usage inside such code is no place in a file: the answer of a reference lookup SHALL NOT hold it, neither as `null` nor in any other form. Every element of the answer SHALL be a location with a file and a range.

#### Scenario: Type path built by a macro
- **WHEN** a build macro adds a field whose type is a type path built without a position, and the references of the type it names are looked up
- **THEN** the answer holds the usages written in the sources and no `null`
