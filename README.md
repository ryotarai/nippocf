# Nippocf

Write nippo (daily report in Japanese) on Atlassian Confluence.

## Installation

    $ gem install nippocf

## Requirements

* Mac OS X
  * because this gem uses keychain to save your password

## Usage

```
$ export CONFL_URL="https://your-confluence-host"
$ export CONFL_USERNAME="your.user.name"

$ # For instance, it's 2013/12/31
$ # Edit nippo of 2013/12/31
$ nippocf
$ # Edit nippo of 2013/12/20
$ nippocf 20
$ # Edit nippo of 2013/11/20
$ nippocf 11/20
$ # Edit nippo of 2012/11/20
$ nippocf 2012/11/20
```

### SOCKS Proxy

If you set `ENV['SOCKS_PROXY']`, this connect to confluence server via SOCKS proxy.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/nippo_confl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Licence

MIT Licence

This includes source code of confluence4r which requires MIT licence.

