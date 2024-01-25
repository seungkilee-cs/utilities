const ytdl = require('youtube-dl');
const argparse = require('argparse');
const path = require('path');

function downloadVideo(url, resolution, container, videoCodec, destination) {
  const options = [
    '--format', `bestvideo[height<=${resolution}]+bestaudio/best[height<=${resolution}]`,
    '--output', path.join(destination, '%(title)s.%(ext)s'),
    '--merge-output-format', container,
    '--video-codec', videoCodec
  ];
  const videoUrl = [url];

  ytdl.exec(videoUrl, options, {}, (err, output) => {
    if (err) throw err;
    console.log('Video downloaded successfully!');
  });
}

function extractAudio(url, destination) {
  const options = [
    '--format', 'bestaudio/best',
    '--output', path.join(destination, '%(title)s.%(ext)s'),
    '--extract-audio',
    '--audio-format', 'mp3',
    '--audio-quality', '192K'
  ];
  const audioUrl = [url];

  ytdl.exec(audioUrl, options, {}, (err, output) => {
    if (err) throw err;
    console.log('Audio extracted successfully!');
  });
}

function downloadPlaylist(playlistUrl, resolution, container, videoCodec, destination) {
  const options = [
    '--format', `bestvideo[height<=${resolution}]+bestaudio/best[height<=${resolution}]`,
    '--output', path.join(destination, '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'),
    '--merge-output-format', container,
    '--video-codec', videoCodec
  ];
  const playlistUrlArray = [playlistUrl];

  ytdl.exec(playlistUrlArray, options, {}, (err, output) => {
    if (err) throw err;
    console.log('Playlist downloaded successfully!');
  });
}

function printHelp() {
  console.log("YouTube Downloader Script");
  console.log("Usage:");
  console.log("  node ytdl.js <URL> [--function FUNCTION] [--resolution RESOLUTION] [--container CONTAINER] [--video_codec VIDEO_CODEC] [--destination DESTINATION]");
  console.log("");
  console.log("Arguments:");
  console.log("  URL                      The URL of the YouTube video or playlist");
  console.log("  --function FUNCTION      The function to perform: video, audio, playlist (default: video)");
  console.log("  --resolution RESOLUTION  Maximum resolution (default: 720)");
  console.log("  --container CONTAINER    Container format (default: mp4)");
  console.log("  --video_codec VIDEO_CODEC Video codec (default: avc1)");
  console.log("  --destination DESTINATION Destination folder for the downloaded files (default: current directory)");
  console.log("");
}

const parser = new argparse.ArgumentParser({ description: 'YouTube Downloader' });
parser.add_argument('url', { type: 'str', help: 'URL of the YouTube video or playlist' });
parser.add_argument('--function', { type: 'str', default: 'video', choices: ['video', 'audio', 'playlist'], help: 'Function to perform: video, audio, playlist (default: video)' });
parser.add_argument('--resolution', { type: 'int', default: 720, help: 'Maximum resolution (default: 720)' });
parser.add_argument('--container', { type: 'str', default: 'mp4', help: 'Container format (default: mp4)' });
parser.add_argument('--video_codec', { type: 'str', default: 'avc1', help: 'Video codec (default: avc1)' });
parser.add_argument('--destination', { type: 'str', default: process.cwd(), help: 'Destination folder for the downloaded files (default: current directory)' });
parser.add_argument('-H', '--help-message', { action: 'store_true', help: 'Print help message' });  // Modified option string
const args = parser.parse_args();

if (args.help_message) {
  printHelp();
} else if (args.function === 'playlist' && args.url.includes('playlist?list=')) {
  downloadPlaylist(args.url, args.resolution, args.container, args.video_codec, args.destination);
} else if (args.function === 'audio') {
  extractAudio(args.url, args.destination);
} else {
  downloadVideo(args.url, args.resolution, args.container, args.video_codec, args.destination);
}
