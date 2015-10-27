Package.describe({
  name: 'sveinburne:enumerationjs',
  version: '1.3.11',
  // Brief, one-line summary of the package.
  summary: 'Java-like super flexible enums ! Move the logic and refactor.',
  // URL to the Git repository containing the source code for this package.
  git: 'https://github.com/sveinburne/enumerationjs/',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.MD'
});

Package.onUse(function(api) {
  api.use('underscore@1.0.0', ['client', 'server']);
  api.addFiles('Enumeration.js', ['client', 'server']);
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('sveinburne:enumerationjs');
  api.addFiles('Enumeration-integration.js');
  api.export("Enumeration");
});
