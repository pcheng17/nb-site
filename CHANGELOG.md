# Change Log

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
