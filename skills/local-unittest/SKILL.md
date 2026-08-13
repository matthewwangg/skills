---
name: local-unittest
description: Write unit tests matching the conventions used across these repos, in C++, Go, Python, or Java. Use whenever a test is being written or a testing approach is chosen for code in one of these languages.
allowed-tools: Read, Glob, Grep, Bash
---

# local-unittest

Write tests that match the existing style. Before writing, read a sibling test
file in the same package and copy its structure — these conventions are the
defaults, not a substitute for what a given repo already does.

Universal:

- One behavior per test. The test name states the behavior.
- Assert on observable results, not incidental internals.
- Cover the failure and boundary cases, not just the happy path.

If code cannot be tested without reaching into internals, faking a concrete type
it constructs itself, or otherwise fighting its structure, that is an
architecture problem, not a testing one. Say so and name the specific coupling —
a hard-wired dependency, a missing interface seam, hidden global state — rather
than writing a contorted test around it. Do not paper over an untestable design.

## C++ (GoogleTest / GoogleMock)

- `TEST(<Type>Test, <Method><Behavior>)` — the test name leads with the method
  under test, then the behavior, PascalCase, no underscores: `SampleSelectsHighestLogit`,
  `SampleRejectsEmptyLogits`, `UpdateGrowsCache`.
- Test file `foo_test.cc` sits beside `foo.h`/`foo.cc`, same namespace, wrapped
  in an anonymous namespace.
- `EXPECT_*` for assertions that should let the test continue; `EXPECT_THROW`
  for error paths.
- Mocks live in `mock_<name>.h` beside the interface, class `Mock<Name>` deriving
  the interface, each method via `MOCK_METHOD(...)` with the qualifiers
  (`(const, override)`) matching the signature exactly. Set expectations with
  `EXPECT_CALL` / `ON_CALL` and `.WillOnce(Return(...))`.
- Construct the object under test directly in each test; no shared fixture unless
  setup genuinely repeats.

## Go (standard `testing`)

- `TestType_Method` per method, with named subtests via `t.Run("success key
  exists", ...)` — the subtest name is the scenario.
- A `newTest<Type>(t *testing.T)` helper with `t.Helper()` for construction.
- `t.Fatalf` when the test cannot continue (setup or a prerequisite call failed),
  `t.Errorf` for an assertion that shouldn't halt the rest.
- Failure messages read `Call(args) = %v, want %v`.
- Compare with the right tool: `bytes.Equal` for bytes, `proto.Equal` for protos.
- Standard library only; no testify.

Mocks are hand-written fakes, not generated. A dependency is an interface; the
fake is a concrete type implementing it with real in-memory behavior, in
`mock.go` (or `<name>_mock.go`) in the same package, named `Mock<Type>` with a
`NewMock<Type>()` constructor. It behaves like the real thing (stores what you
put, returns it, tracks state) rather than recording calls — tests exercise it
through the interface. Reach for a recording/expectation mock only when a test
must assert on the interaction itself.

## Python (pytest)

- `test_<unit>_<behavior>` at module level: `test_make_key_order_independent`,
  `test_cache_get_miss`.
- Plain `assert`.
- Shared setup goes in `conftest.py` fixtures; prefer `tmp_path` and `monkeypatch`
  over touching real state. An `autouse` fixture resets per-test state.
- Async tests: `@pytest.mark.asyncio` (pytest-asyncio, strict mode).

Two mocking styles, by intent:

- A small local `def`/`async def` fake closing over a counter, when the test
  needs a stand-in it fully controls (e.g. counting how many times a fetch ran).
- `unittest.mock.patch` to replace a collaborator at its import site, with
  `AsyncMock(return_value=...)` for async collaborators and `side_effect=
  Exception(...)` to drive error paths. Patch where the name is used, not where
  it is defined.

## Java (JUnit 5 / Mockito)

- `method_success` / `method_failureScenario` — method under test, then outcome,
  lowerCamelCase after the underscore: `select_success`, `register_failureAlreadyExists`.
- Test class is `final`, named `<Type>Test`, mirroring the source package under
  `src/test/java`.
- Static-import assertions and Mockito: `assertEquals`, `assertTrue`,
  `assertFalse` from `org.junit.jupiter.api.Assertions`; `mock`, `when`, `verify`
  from `org.mockito.Mockito`.
- Shared setup in a `@BeforeEach setUp()`; each test is a `@Test` method.
- Mock collaborators with `mock(Collaborator.class)`, stub with
  `when(...).thenReturn(...)`, and assert the interaction with `verify(...)` when
  it is part of the behavior under test.
