
Overview
========

This Rails mountable engine allows you to manage your Avatax integration in Kill Bill.

* See [killbill-avatax-plugin](https://github.com/killbill/killbill-avatax-plugin) to get started with the Avatax plugin.
* See [killbill-admin-ui-standalone](https://github.com/killbill/killbill-admin-ui-standalone) to get started with the Kill Bill Admin UI.

Kill Bill compatibility
-----------------------

| Avatax UI version | Kill Bill version |
| ----------------: | ----------------: |
| 0.0.y             | 0.16.z            |
| 0.1.y             | 0.18.z (Rails 4)  |
| 0.2.y             | 0.18.z (Rails 5)  |
| 1.x.y             | 0.20.z            |
| 2.x.y             | 0.22.z            |

Functionality
-------------

This app lets you:

* configure tax codes associated with products in your catalog
* set tax exemption codes on Kill Bill accounts
* configure your Avatax credentials

Getting Started
---------------

You can run this locally by using the test/dummy app provided.

To do so, specify your Kill Bill server url, api key and secret in ```test/dummy/config/initializers/killbill_client.rb```:

```
KillBillClient.url = 'http://127.0.0.1:8080/'
KillBillClient.api_key = 'bob'
KillBillClient.api_secret = 'lazar'
```

Then, simply run:

```
rails s
```


To run tests:

```
rails t
```
