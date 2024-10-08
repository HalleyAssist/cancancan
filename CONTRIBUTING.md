## Contributing to CanCanCan

### Reporting an Issue

1. If you have any questions about CanCanCan, search the [Developer guide](./docs/README.md) or
use [Stack Overflow](http://stackoverflow.com/questions/tagged/cancancan).
Do not post questions here.

1. If you find a security bug, **DO NOT** submit an issue here. Please send an e-mail to the [current maintainer](https://github.com/coorasse) instead.

1. Do a small search on the issues tracker before submitting your issue to see if it was already reported / fixed.

1. Create your report including Rails and CanCanCan versions. If you are getting exceptions, please include the full backtrace. Use the [following gist](https://gist.github.com/coorasse/3f00f536563249125a37e15a1652648c) as a base to reproduce your bug.

That's it! The more information you give, the more easy it becomes for us to track it down and fix it. Ideal scenario would be adding the issue to CanCanCan test suite or to a sample application.

### Adding new Features or Bugfixes

CanCanCan uses a [git-flow](http://nvie.com/posts/a-successful-git-branching-model/) development model.
The latest "released" version of CanCanCan, the latest gem version, can always be found on `main`,
while the next version or nightly is on `develop`.

Please make sure you have test coverage for anything you add or fix!

Please add a CHANGELOG entry with any relevant tags for issues, pull-requests, and authors.

Thanks for you contribution!

### Modify the Documentation

The documentation is written in Markdown and is located in the `docs` directory. The documentation is built using [VitePress](https://vitepress.dev).
VitePress supports all markdown features but also adds a few enhancements, which are documented in the [Markdown Extensions](https://vitepress.dev/guide/markdown).

```bash
npm install
npm run dev

# build for production, resulting in a static site in docs/.vitepress/dist
npm run build
```

Before submitting a pull request, please make sure the documentation builds correctly using `npm run build`.
Most likely the build will fail if there are any syntax errors in the markdown files or dead links.
