___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Fetch JSON from API",
  "description": "Fetch JSON results from an API call.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "fullURL",
    "displayName": "Full URL",
    "categories": ["UTILITY"],
    "simpleValueType": true,
    "alwaysInSummary": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "method",
    "displayName": "Method",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "GET",
        "displayValue": "GET"
      },
      {
        "value": "POST",
        "displayValue": "POST"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "GET"
  },
  {
    "type": "PARAM_TABLE",
    "name": "headers",
    "displayName": "Headers",
    "paramTableColumns": [
      {
        "param": {
          "type": "TEXT",
          "name": "key",
          "displayName": "Key",
          "simpleValueType": true,
          "valueValidators": [
            {
              "type": "NON_EMPTY"
            }
          ]
        },
        "isUnique": true
      },
      {
        "param": {
          "type": "TEXT",
          "name": "value",
          "displayName": "Value",
          "simpleValueType": true,
          "valueValidators": [
            {
              "type": "NON_EMPTY"
            }
          ]
        },
        "isUnique": false
      }
    ],
    "newRowButtonText": "Add header",
    "editRowTitle": "Edit header",
    "newRowTitle": "Add header"
  },
  {
    "type": "TEXT",
    "name": "body",
    "displayName": "Body",
    "simpleValueType": true,
    "lineCount": 10,
    "enablingConditions": [
      {
        "paramName": "method",
        "paramValue": "POST",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "timeout",
    "displayName": "Timeout",
    "simpleValueType": true,
    "help": "The timeout, in milliseconds, before the request is aborted.",
    "defaultValue": 15000,
    "valueValidators": [
      {
        "type": "POSITIVE_NUMBER"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "responseKey",
    "displayName": "Return response key",
    "simpleValueType": true,
    "help": "Optional. Return the value of a specific key. Use dot notation (e.g. data.id)."
  }
]


___SANDBOXED_JS_FOR_SERVER___

const JSON = require('JSON');
const makeString = require('makeString');
const sendHttpRequest = require('sendHttpRequest');

const requestHeaders = {'Accept': 'application/json'};

if (data.headers) {
    for (let key in data.headers) {
        requestHeaders[data.headers[key].key] = data.headers[key].value;
    }
}

return sendHttpRequest(data.fullURL, {
  headers: requestHeaders,
  method: data.method,
  timeout: data.timeout,
}, data.body).then((result) => {
  if (result.statusCode !== 200){ return undefined; }
  let response = JSON.parse(result.body);
  if (data.responseKey) {
    const dataKeys = data.responseKey.split('.');
    for (let i = 0; i < dataKeys.length; i++) {
      response = response[dataKeys[i]];
    }
  }
  return response;
}).catch(() => { return undefined; });


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 30/06/2022, 14:39:59


