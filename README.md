# rules_system

Rules to simplify writing system-dependent Bazel rules.

## system_select()

Like select(), but automatically generates the correct OS targets and reduces code duplication.

## repository_rule_select()

Like system_select(), but for repository rules.

## local_cc_library

Work in progress, repository rule to find libraries on the system.
