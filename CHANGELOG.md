# Change Log

## v.1.3.0 - 2025-01-02

### New features

- Added the ability to link directly to each week's listing, and also directly to each entry. This
is to allow for me and others to share links to locations on the page.
  - I generate slugs from the titles of each entry, but since titles may not be unique, I needed to
    incorporate de-duplication logic when forming the slugs.

## v.1.2.3 - 2024-12-30

### Maintenance

- Refactored and cleaned up the CSS by combining all `@media` entries into one

## v.1.2.2 - 2024-12-30

### New features

- Responsive CSS for small screen sizes only

## v.1.2.1 - 2024-12-30

### Bug fixes

- Load font and nerd font from CDN so fonts and icons are consistent across platforms and devices.

## v1.2.0 - 2024-12-30

### New features

- Updated the installation and build steps to incorporate gems.
- Added `redcarpet` as a dependency to allow for the use of Markdown syntax in `data.json`.
- Refactored the Vercel build steps into `vercel.json`.

### Bug fixes

- Fix font color of the calendar icon in the metadata of a group of entries.

## v1.1.0 - 2024-12-30

- Separate links of each week into different sections styled by CSS.
- Temporary patch for the week-counting logic to handle the turn of the new year, 2024 to 2025.

## v1.0.3 - 2024-12-30

- Use JavaScript to always show the build time in the local timezone

## v1.0.2 - 2024-12-30

- Make the version number and build date prettier

## v1.0.1 - 2024-12-30

- Rename the output directory from `build` to `public`

## v1.0.0 - 2024-12-30

Initial release, with the following features:

- Given a `data.json` file which contains urls that I'd like to save along with a description, `nb` will generate a simple webpage that displays the information.
- Entries are grouped by week, and entries ordered in reverse chronological order, i.e., the farther down you go, the older the links are in terms of when I saved them.
