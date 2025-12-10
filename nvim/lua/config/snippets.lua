return {
  go = {
    json = {
      prefix = "json",
      body = {
        "`json:\"${1:field_name}\"`",
      },
      description = "JSON struct tag",
    },
    json_omitempty = {
      prefix = "jsonomit",
      body = {
        "`json:\"${1:field_name},omitempty\"`",
      },
      description = "JSON struct tag with omitempty",
    },
  },
}
