# Browse History Recall

A day-by-day, color-coded timeline of your Chrome browsing history, with an interactive 3D view. Everything runs locally in your browser. Your History file is never uploaded anywhere.

![Preview](preview.jpg)

## Features

- Day-by-day timeline of your Chrome history
- Pages auto-sorted into categories (Email, AI, Video, Work, Finance, Shopping, Social, Search and more)
- 3D time-lane view: size dots by time on page, focus threshold, trails, auto-rotate
- Zoom like a map, but through time: scroll toward the cursor and the time axis refines (days, hours, minutes) while labels and full cards for the busiest pages appear (toggle: "Detail on zoom")
- Every panel can be collapsed or popped out into a draggable floating window
- Optional thumbnails on hover and pinned cards: YouTube video thumbnails, site icons for other pages
- Hover for a quick look, click to pin a card, double-click to open the site
- 100% client-side: reads the SQLite History file with sql.js in your browser

## Usage

1. Open `index.html` in your browser (or use the GitHub Pages demo if enabled for this repo).
2. Click **Open Chrome History file** and pick your History file. The in-app guide shows where it lives on Windows, macOS and Linux. On Windows it is under `%LOCALAPPDATA%\Google\Chrome\User Data\Default\History`.
3. If Chrome is open, copy the History file to your desktop first and open the copy.

## Privacy

By default no data leaves your machine. The only network requests are for the sql.js and three.js libraries from public CDNs.

The optional **Thumbnails** checkbox (off by default) shows a YouTube thumbnail for video pages and a site icon for everything else. Turning it on makes your browser fetch those images from YouTube's image server and Google's favicon service, so they can see which videos and sites you hover over. Leave it off if you don't want that.

Do not commit your own History file to this repo; the `.gitignore` blocks common names.

## License

MIT. See [LICENSE](LICENSE).
