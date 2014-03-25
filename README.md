#Setup

```bash
dokku config:set proxy-production redirect_for_no_url='https://factlink.com' \
  hostname='fct.li' \
  host='http://fct.li' \
  jslib_uri='https://static.factlink.com/lib/dist/factlink_loader.min.js?o=proxy' \
  raven_dsn='...'
```
