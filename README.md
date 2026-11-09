# Browse History Recall

A day-by-day, color-coded timeline of your Chrome browsing history, with an interactive 3D view. Everything runs locally in your browser. Your History file is never uploaded anywhere.

**Live:** https://whizy76.github.io/whizy76-git/ · also at https://chisheu.com/browse-history/

![Preview](preview.jpg)

## Features

- Day-by-day timeline of your Chrome history (light and dark themes)
- Pages auto-sorted into categories (Email, AI, Video, Work, Finance, Shopping, Social, Search and more), with editable rules
- 3D time-lane view: size dots by time on page, focus threshold, trails, auto-rotate
- Zoom like a map, but through time: scroll toward the cursor and the time axis refines (days, hours, minutes) while labels and full cards for the busiest pages appear (toggle: "Detail on zoom")
- Every panel can be collapsed or popped out into a draggable, resizable floating window
- Optional thumbnails on hover, pinned and zoom cards: YouTube video thumbnails, site icons for other pages
- Hover for a quick look, click to pin a card, double-click to open the site
- Works offline after the first load: sql.js and three.js are included in this repo
- 100% client-side: reads the SQLite History file with sql.js in your browser

## Usage

1. Open `index.html` in your browser, or use the live demo above.
2. Click **Open Chrome History file** and pick your History file. The in-app guide shows where it lives on Windows, macOS and Linux. On Windows it is under `%LOCALAPPDATA%\Google\Chrome\User Data\Default\History`.
3. If Chrome is open, copy the History file to your desktop first and open the copy.

Edge, Brave, Opera and Vivaldi use the same History file format as Chrome and should work too (different folder). Firefox and Safari use other formats and are not supported yet.

## Privacy

By default no data leaves your machine. This copy makes no network requests at all, because the libraries are bundled.

The optional **Thumbnails** checkbox (off by default) shows a YouTube thumbnail for video pages and a site icon for everything else. Turning it on makes your browser fetch those images from YouTube's image server and Google's favicon service, so they can see which videos and sites you hover over. Leave it off if you don't want that.

Do not commit your own History file to this repo; the `.gitignore` blocks common names. Use fake data for screenshots.

## For contributors (human or AI)

This repo is a **public mirror** of the app as it lives on chisheu.com. Read [CLAUDE.md](CLAUDE.md) before changing anything: it explains who edits what, which way changes flow, and how to avoid colliding with the other people and tools working on the same file. `sync-from-site.sh` copies the site version in.

## Third-party code

Bundled, unmodified, under the MIT license:
- [sql.js](https://github.com/sql-js/sql.js) 1.8.0 (`sql-wasm.js`, `sql-wasm.wasm`)
- [three.js](https://github.com/mrdoob/three.js) r128 (`three.min.js`) and its `OrbitControls.js`

## License

MIT. See [LICENSE](LICENSE).
