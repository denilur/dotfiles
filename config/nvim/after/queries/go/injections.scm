; extends

; SQL highlighting in raw strings marked with a `// sql` (or `/* sql */`) comment:
;
;   // sql
;   q := `SELECT id FROM users WHERE id = $1`
;
;   // sql
;   const q = `SELECT ...`
;
;   db.Query(ctx, /* sql */ `SELECT ...`)

; q := `...` / q = `...` right after the comment
((comment) @_comment
  .
  [
    (short_var_declaration
      right: (expression_list
        (raw_string_literal
          (raw_string_literal_content) @injection.content)))
    (assignment_statement
      right: (expression_list
        (raw_string_literal
          (raw_string_literal_content) @injection.content)))
  ]
  (#lua-match? @_comment "^/[/*]%s*[sS][qQ][lL]")
  (#set! injection.language "sql"))

; comment is the first line of a block: (block (comment) (statement_list ...))
((comment) @_comment
  .
  (statement_list
    .
    [
      (short_var_declaration
        right: (expression_list
          (raw_string_literal
            (raw_string_literal_content) @injection.content)))
      (assignment_statement
        right: (expression_list
          (raw_string_literal
            (raw_string_literal_content) @injection.content)))
    ])
  (#lua-match? @_comment "^/[/*]%s*[sS][qQ][lL]")
  (#set! injection.language "sql"))

; const / var declarations
((comment) @_comment
  .
  [
    (const_declaration
      (const_spec
        value: (expression_list
          (raw_string_literal
            (raw_string_literal_content) @injection.content))))
    (var_declaration
      (var_spec
        value: (expression_list
          (raw_string_literal
            (raw_string_literal_content) @injection.content))))
  ]
  (#lua-match? @_comment "^/[/*]%s*[sS][qQ][lL]")
  (#set! injection.language "sql"))

; inline argument: f(/* sql */ `...`)
((comment) @_comment
  .
  (raw_string_literal
    (raw_string_literal_content) @injection.content)
  (#lua-match? @_comment "^/[/*]%s*[sS][qQ][lL]")
  (#set! injection.language "sql"))
