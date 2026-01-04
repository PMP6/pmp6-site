'use strict';

import plugins       from 'gulp-load-plugins';
import yargs         from 'yargs';
import gulp          from 'gulp';
import rimraf        from 'rimraf';
import yaml          from 'js-yaml';
import fs            from 'fs';
import webpackStream from 'webpack-stream';
import webpack2      from 'webpack';
import named         from 'vinyl-named';
import autoprefixer  from 'autoprefixer';
import imagemin      from 'gulp-imagemin';

const sass = require('gulp-sass')(require('sass-embedded'));
const postcss = require('gulp-postcss');
var sourcemaps = require('gulp-sourcemaps');

// Load all Gulp plugins into one variable
const $ = plugins();

// Check for --production flag
const PRODUCTION = !!(yargs.argv.production);

// Load settings from settings.yml
function loadConfig() {
    const ymlFile = fs.readFileSync('config.yml', 'utf8');
    return yaml.load(ymlFile);
}

const { PORT, PATHS } = loadConfig();

// Remove the generated files
gulp.task(
    'clean',
    clean
);

// Build the "dist" folder by running all of the below tasks
gulp.task(
    'build',
    gulp.series(
        clean,
        gulp.parallel(
            sassBuild,
            javascript,
            images,
            copy
        )
    )
);

// Build the site and watch for file changes
gulp.task(
    'watch',
    gulp.series(
        'build',
        watch
    )
);

// Delete the "dist" folder
// This happens every time a build starts
function clean(done) {
    rimraf(PATHS.dist, done);
}

// Copy files out of the assets folder
// This task skips over the "img", "js", and "scss" folders, which are parsed separately
function copy() {
    return gulp.src(PATHS.assets)
        .pipe(gulp.dest(PATHS.dist));
}

// Compile Sass into CSS
// In production, the CSS is compressed
function sassBuild() {
    const postCssPlugins = [
        // Autoprefixer
        autoprefixer(),
    ];

    return gulp.src(PATHS.sass_entries)
        .pipe(sourcemaps.init())
        .pipe(sass({includePaths: PATHS.sass}).on('error', sass.logError))
        .pipe(postcss(postCssPlugins))
        .pipe($.if(PRODUCTION, $.cleanCss({ compatibility: 'ie9' })))
        .pipe($.if(!PRODUCTION, sourcemaps.write()))
        .pipe(gulp.dest(PATHS.dist + '/css'));
}

let webpackConfig = {
    mode: (PRODUCTION ? 'production' : 'development'),
    module: {
        rules: [
            {
                test: /\.js$/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: [ "@babel/preset-env" ],
                        compact: false
                    }
                }
            }
        ]
    },
    devtool: !PRODUCTION && 'source-map'
}
// Combine JavaScript into one file
// In production, the file is minified
function javascript() {
    return gulp.src(PATHS.entries)
        .pipe(named())
        .pipe($.sourcemaps.init())
        .pipe(webpackStream(webpackConfig, webpack2))
        .pipe($.if(PRODUCTION,
                   $.uglify().on('error', e => { console.log(e); })))
        .pipe($.if(!PRODUCTION, $.sourcemaps.write()))
        .pipe(gulp.dest(PATHS.dist + '/js'));
}

// Copy images to the "dist" folder
// In production, the images are compressed
function images() {
    return gulp.src('assets/img/**/*')
        .pipe($.if(PRODUCTION, imagemin([
            imagemin.gifsicle({interlaced: true}),
            imagemin.mozjpeg({quality: 85, progressive: true}),
            imagemin.optipng({optimizationLevel: 5}),
            imagemin.svgo({
                plugins: [
                    {removeViewBox: true},
                    {cleanupIDs: false}
                ]
            })
        ])))
        .pipe(gulp.dest(PATHS.dist + '/img'));
}

// Watch for changes to static assets, pages, Sass, and JavaScript
function watch() {
    gulp.watch(PATHS.assets, copy);
    gulp.watch('assets/scss/**/*.scss').on('all', sassBuild);
    gulp.watch('assets/js/**/*.js').on('all', javascript);
    gulp.watch('assets/img/**/*').on('all', images);
}
