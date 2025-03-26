// Generated on 2015-07-28 using
// generator-webapp 1.0.1
'use strict';

// # Globbing
// for performance reasons we're only matching one level down:
// 'test/spec/{,*/}*.js'
// If you want to recursively match all subfolders, use:
// 'test/spec/**/*.js'

module.exports = function (grunt) {

  // Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt);

  // Automatically load required grunt tasks
  require('jit-grunt')(grunt);

  // Configurable paths
  var config = {
    app: 'goonstation',
    dist: 'build'
  };

  var cdn = 'http://ss13.hardcats.net';

  // Define the configuration for all the tasks
  grunt.initConfig({

    // Project settings
    config: config,

    // Empties folders to start fresh
    clean: {
      dist: {
        files: [{
          dot: true,
          src: [
            '.tmp',
            '<%= config.dist %>/*',
            '!<%= config.dist %>/.git*'
          ]
        }]
      }
    },

    // Make sure code styles are up to par and there are no obvious mistakes
    eslint: {
      target: [
        'Gruntfile.js',
        '<%= config.app %>/browserassets/js/{,*/}*.js',
      ]
    },

    // Compiles Sass to CSS and generates necessary files if requested
    sass: {
      options: {
        sourceMap: false,
        includePaths: ['.']
      },
      dist: {
        files: [{
          expand: true,
          cwd: '<%= config.dist %>/browserassets/css',
          src: '**/*.{scss,sass}',
          dest: '<%= config.dist %>/browserassets/css',
          ext: '.css'
        }]
      }
    },

    postcss: {
      options: {
        map: false,
        processors: [
          require('autoprefixer-core')({browsers: 'ie >= 7'}),
          require('cssnano')()
        ]
      },
      dist: {
        files: [{
          expand: true,
          cwd: '<%= config.dist %>/browserassets/css',
          src: '**/*.css',
          dest: '<%= config.dist %>/browserassets/css'
        }]
      }
    },

    // The following *-min tasks produce minified files in the dist folder
    imagemin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= config.app %>/browserassets/images',
          src: '**/*.{gif,jpeg,jpg,png}',
          dest: '<%= config.dist %>/browserassets/images'
        }]
      }
    },

    svgmin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= config.app %>/browserassets/images',
          src: '**/*.svg',
          dest: '<%= config.dist %>/browserassets/images'
        }]
      }
    },

    'string-replace': {
      html: {
        files: [{
          expand: true,
          cwd: '<%= config.app %>/browserassets/html',
          src: '**/*.{html,htm}',
          dest: '<%= config.dist %>/browserassets/html'
        }],
        options: {
          replacements: [{
            pattern: /\{\{resource\(\"(.*?)\"\)\}\}/ig,
            replacement: cdn + '/$1'
          }]
        }
      },
      css: {
        files: [{
          expand: true,
          cwd: '<%= config.app %>/browserassets/css',
          src: '**/*.{scss,sass,css}',
          dest: '<%= config.dist %>/browserassets/css'
        }],
        options: {
          replacements: [{
            pattern: /\{\{resource\(\"(.*?)\"\)\}\}/ig,
            replacement: cdn + '/$1'
          }]
        }
      },
      js: {
        files: [{
          expand: true,
          cwd: '<%= config.app %>/browserassets/js',
          src: '**/*.js',
          dest: '<%= config.dist %>/browserassets/js'
        }],
        options: {
          replacements: [{
            pattern: /\{\{resource\(\"(.*?)\"\)\}\}/ig,
            replacement: cdn + '/$1'
          }]
        }
      }
    },

    htmlmin: {
      dist: {
        options: {
          collapseBooleanAttributes: true,
          collapseWhitespace: true,
          conservativeCollapse: true,
          removeComments: false,
          removeAttributeQuotes: true,
          removeCommentsFromCDATA: true,
          removeEmptyAttributes: true,
          removeOptionalTags: false,
          // true would impact styles with attribute selectors
          removeRedundantAttributes: false,
          useShortDoctype: true
        },
        files: [{
          expand: true,
          cwd: '<%= config.dist %>/browserassets/html',
          src: '**/*.html',
          dest: '<%= config.dist %>/browserassets/html'
        }]
      }
    },

    uglify: {
      options: {
        mangle: true,
        compress: true,
        preserveComments: 'all'
      },
      dist: {
        files: [{
          expand: true,
          cwd: '<%= config.dist %>/browserassets/js',
          src: '**/*.js',
          dest: '<%= config.dist %>/browserassets/js'
        }]
      }
    },

    // Copies remaining files to places other tasks can use
    copy: {
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= config.app %>',
          dest: '<%= config.dist %>',
          src: [
            'browserassets/images/{,*/}*.webp',
            'browserassets/css/fonts/{,*/}*.*'
          ]
        },
        ]
      },
      temp: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= config.app %>',
          dest: '<%= config.dist %>',
          src: [
            'browserassets/css/**/*',
            'browserassets/html/**/*'
          ]
        },
        ]

      }
    },

    // Run some tasks in parallel to speed up build process
    concurrent: {
      dist: [
        'sass',
        'imagemin',
        'svgmin'
      ]
    }
  });

  grunt.registerTask('build', [
    'clean',
    'copy:temp',
    //'string-replace:css',
    'concurrent:dist',
    'postcss',
    'uglify',
    'copy:dist',
    //'string-replace:html',
    'htmlmin'
  ]);

  grunt.registerTask('build-cdn', [
    'clean',
    'string-replace:css',
    //'sass',
    'imagemin',
    'svgmin',
    'postcss',
    'string-replace:js',
    'uglify',
    'string-replace:html',
    'htmlmin',
    'copy:dist'
  ]);

  grunt.registerTask('build-byond', [
    'clean',
    'string-replace:html',
    'htmlmin'
  ]);

  grunt.registerTask('default', [
    'build'
  ]);
};
