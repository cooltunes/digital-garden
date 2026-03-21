-- wikilinks.lua — Secondary Pandoc wikilink handler
--
-- Primary conversion ([[target]] and [[target|label]]) is done by sed
-- preprocessing in deploy.yml before Pandoc runs.
--
-- This filter handles edge cases where Pandoc's own reference-link parser
-- converts [[target]] into a Link element with an empty href before sed
-- can process it (e.g. when using --from=markdown+autolink_bare_uris).
--
-- Supported syntax:
--   [[page-name]]        → link to page-name.html, label "page-name"
--   [[page-name|Label]]  → link to page-name.html, label "Label"

function Link(el)
  -- An unresolved [[target]] may arrive as a Link with href ""
  if el.target == "" then
    local text = pandoc.utils.stringify(el)
    if text ~= "" then
      local target, label = text:match("^(.-)%|(.+)$")
      if not target then
        target = text
        label  = text
      end
      -- Slugify: lowercase, spaces → hyphens
      local href = target:lower():gsub("%s+", "-") .. ".html"
      return pandoc.Link(pandoc.Str(label), href, el.title)
    end
  end
end
