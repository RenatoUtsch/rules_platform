# rules_platform

Rules to simplify writing platform-dependent Bazel rules.

## platform_select()

Like select(), but automatically generates the correct OS targets and reduces code duplication.

## repository_rule_select()

Like platform_select(), but for repository rules.

## local_cc_library

Work in progress, repository rule to find libraries on the system.
