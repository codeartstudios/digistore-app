/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
            const snapshot = [
                {
                    "createRule": null,
                    "deleteRule": null,
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text455797646",
                            "max": 0,
                            "min": 0,
                            "name": "collectionRef",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text127846527",
                            "max": 0,
                            "min": 0,
                            "name": "recordRef",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text1582905952",
                            "max": 0,
                            "min": 0,
                            "name": "method",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": true,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": true,
                            "type": "autodate"
                        }
                    ],
                    "id": "pbc_2279338944",
                    "indexes": [
                        "CREATE INDEX `idx_mfas_collectionRef_recordRef` ON `_mfas` (collectionRef,recordRef)"
                    ],
                    "listRule": "@request.auth.id != '' && recordRef = @request.auth.id && collectionRef = @request.auth.collectionId",
                    "name": "_mfas",
                    "system": true,
                    "type": "base",
                    "updateRule": null,
                    "viewRule": "@request.auth.id != '' && recordRef = @request.auth.id && collectionRef = @request.auth.collectionId"
                },
                {
                    "createRule": null,
                    "deleteRule": null,
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text455797646",
                            "max": 0,
                            "min": 0,
                            "name": "collectionRef",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text127846527",
                            "max": 0,
                            "min": 0,
                            "name": "recordRef",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "cost": 8,
                            "hidden": true,
                            "id": "password901924565",
                            "max": 0,
                            "min": 0,
                            "name": "password",
                            "pattern": "",
                            "presentable": false,
                            "required": true,
                            "system": true,
                            "type": "password"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": true,
                            "id": "text3866985172",
                            "max": 0,
                            "min": 0,
                            "name": "sentTo",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": false,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": true,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": true,
                            "type": "autodate"
                        }
                    ],
                    "id": "pbc_1638494021",
                    "indexes": [
                        "CREATE INDEX `idx_otps_collectionRef_recordRef` ON `_otps` (collectionRef, recordRef)"
                    ],
                    "listRule": "@request.auth.id != '' && recordRef = @request.auth.id && collectionRef = @request.auth.collectionId",
                    "name": "_otps",
                    "system": true,
                    "type": "base",
                    "updateRule": null,
                    "viewRule": "@request.auth.id != '' && recordRef = @request.auth.id && collectionRef = @request.auth.collectionId"
                },
                {
                    "createRule": null,
                    "deleteRule": "@request.auth.id != '' && recordRef = @request.auth.id && collectionRef = @request.auth.collectionId",
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text455797646",
                            "max": 0,
                            "min": 0,
                            "name": "collectionRef",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text127846527",
                            "max": 0,
                            "min": 0,
                            "name": "recordRef",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text2462348188",
                            "max": 0,
                            "min": 0,
                            "name": "provider",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text1044722854",
                            "max": 0,
                            "min": 0,
                            "name": "providerId",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": true,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": true,
                            "type": "autodate"
                        }
                    ],
                    "id": "pbc_2281828961",
                    "indexes": [
                        "CREATE UNIQUE INDEX `idx_externalAuths_record_provider` ON `_externalAuths` (collectionRef, recordRef, provider)",
                        "CREATE UNIQUE INDEX `idx_externalAuths_collection_provider` ON `_externalAuths` (collectionRef, provider, providerId)"
                    ],
                    "listRule": "@request.auth.id != '' && recordRef = @request.auth.id && collectionRef = @request.auth.collectionId",
                    "name": "_externalAuths",
                    "system": true,
                    "type": "base",
                    "updateRule": null,
                    "viewRule": "@request.auth.id != '' && recordRef = @request.auth.id && collectionRef = @request.auth.collectionId"
                },
                {
                    "createRule": null,
                    "deleteRule": "@request.auth.id != '' && recordRef = @request.auth.id && collectionRef = @request.auth.collectionId",
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text455797646",
                            "max": 0,
                            "min": 0,
                            "name": "collectionRef",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text127846527",
                            "max": 0,
                            "min": 0,
                            "name": "recordRef",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text4228609354",
                            "max": 0,
                            "min": 0,
                            "name": "fingerprint",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": true,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": true,
                            "type": "autodate"
                        }
                    ],
                    "id": "pbc_4275539003",
                    "indexes": [
                        "CREATE UNIQUE INDEX `idx_authOrigins_unique_pairs` ON `_authOrigins` (collectionRef, recordRef, fingerprint)"
                    ],
                    "listRule": "@request.auth.id != '' && recordRef = @request.auth.id && collectionRef = @request.auth.collectionId",
                    "name": "_authOrigins",
                    "system": true,
                    "type": "base",
                    "updateRule": null,
                    "viewRule": "@request.auth.id != '' && recordRef = @request.auth.id && collectionRef = @request.auth.collectionId"
                },
                {
                    "authAlert": {
                        "emailTemplate": {
                            "body": "<p>Hello,</p>\n<p>We noticed a login to your {APP_NAME} account from a new location.</p>\n<p>If this was you, you may disregard this email.</p>\n<p><strong>If this wasn't you, you should immediately change your {APP_NAME} account password to revoke access from all other locations.</strong></p>\n<p>\n  Thanks,<br/>\n  {APP_NAME} team\n</p>",
                            "subject": "Login from a new location"
                        },
                        "enabled": true
                    },
                    "authRule": "",
                    "authToken": {
                        "duration": 86400
                    },
                    "confirmEmailChangeTemplate": {
                        "body": "<p>Hello,</p>\n<p>Click on the button below to confirm your new email address.</p>\n<p>\n  <a class=\"btn\" href=\"{APP_URL}/_/#/auth/confirm-email-change/{TOKEN}\" target=\"_blank\" rel=\"noopener\">Confirm new email</a>\n</p>\n<p><i>If you didn't ask to change your email address, you can ignore this email.</i></p>\n<p>\n  Thanks,<br/>\n  {APP_NAME} team\n</p>",
                        "subject": "Confirm your {APP_NAME} new email address"
                    },
                    "createRule": null,
                    "deleteRule": null,
                    "emailChangeToken": {
                        "duration": 1800
                    },
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "cost": 0,
                            "hidden": true,
                            "id": "password901924565",
                            "max": 0,
                            "min": 8,
                            "name": "password",
                            "pattern": "",
                            "presentable": false,
                            "required": true,
                            "system": true,
                            "type": "password"
                        },
                        {
                            "autogeneratePattern": "[a-zA-Z0-9]{50}",
                            "hidden": true,
                            "id": "text2504183744",
                            "max": 60,
                            "min": 30,
                            "name": "tokenKey",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "exceptDomains": null,
                            "hidden": false,
                            "id": "email3885137012",
                            "name": "email",
                            "onlyDomains": null,
                            "presentable": false,
                            "required": true,
                            "system": true,
                            "type": "email"
                        },
                        {
                            "hidden": false,
                            "id": "bool1547992806",
                            "name": "emailVisibility",
                            "presentable": false,
                            "required": false,
                            "system": true,
                            "type": "bool"
                        },
                        {
                            "hidden": false,
                            "id": "bool256245529",
                            "name": "verified",
                            "presentable": false,
                            "required": false,
                            "system": true,
                            "type": "bool"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": true,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": true,
                            "type": "autodate"
                        }
                    ],
                    "fileToken": {
                        "duration": 180
                    },
                    "id": "pbc_3142635823",
                    "indexes": [
                        "CREATE UNIQUE INDEX `idx_tokenKey_pbc_3142635823` ON `_superusers` (`tokenKey`)",
                        "CREATE UNIQUE INDEX `idx_email_pbc_3142635823` ON `_superusers` (`email`) WHERE `email` != ''"
                    ],
                    "listRule": null,
                    "manageRule": null,
                    "mfa": {
                        "duration": 1800,
                        "enabled": false,
                        "rule": ""
                    },
                    "name": "_superusers",
                    "oauth2": {
                        "enabled": false,
                        "mappedFields": {
                            "avatarURL": "",
                            "id": "",
                            "name": "",
                            "username": ""
                        }
                    },
                    "otp": {
                        "duration": 180,
                        "emailTemplate": {
                            "body": "<p>Hello,</p>\n<p>Your one-time password is: <strong>{OTP}</strong></p>\n<p><i>If you didn't ask for the one-time password, you can ignore this email.</i></p>\n<p>\n  Thanks,<br/>\n  {APP_NAME} team\n</p>",
                            "subject": "OTP for {APP_NAME}"
                        },
                        "enabled": false,
                        "length": 8
                    },
                    "passwordAuth": {
                        "enabled": true,
                        "identityFields": [
                            "email"
                        ]
                    },
                    "passwordResetToken": {
                        "duration": 1800
                    },
                    "resetPasswordTemplate": {
                        "body": "<p>Hello,</p>\n<p>Click on the button below to reset your password.</p>\n<p>\n  <a class=\"btn\" href=\"{APP_URL}/_/#/auth/confirm-password-reset/{TOKEN}\" target=\"_blank\" rel=\"noopener\">Reset password</a>\n</p>\n<p><i>If you didn't ask to reset your password, you can ignore this email.</i></p>\n<p>\n  Thanks,<br/>\n  {APP_NAME} team\n</p>",
                        "subject": "Reset your {APP_NAME} password"
                    },
                    "system": true,
                    "type": "auth",
                    "updateRule": null,
                    "verificationTemplate": {
                        "body": "<p>Hello,</p>\n<p>Thank you for joining us at {APP_NAME}.</p>\n<p>Click on the button below to verify your email address.</p>\n<p>\n  <a class=\"btn\" href=\"{APP_URL}/_/#/auth/confirm-verification/{TOKEN}\" target=\"_blank\" rel=\"noopener\">Verify</a>\n</p>\n<p>\n  Thanks,<br/>\n  {APP_NAME} team\n</p>",
                        "subject": "Verify your {APP_NAME} email"
                    },
                    "verificationToken": {
                        "duration": 259200
                    },
                    "viewRule": null
                },
                {
                    "createRule": null,
                    "deleteRule": "id = @request.auth.organization && (\n  @request.auth.role = 'admin'\n)",
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text1579384326",
                            "max": 0,
                            "min": 3,
                            "name": "name",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": false,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text1843675174",
                            "max": 0,
                            "min": 0,
                            "name": "description",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": false,
                            "system": false,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text223244161",
                            "max": 0,
                            "min": 0,
                            "name": "address",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": false,
                            "system": false,
                            "type": "text"
                        },
                        {
                            "exceptDomains": null,
                            "hidden": false,
                            "id": "email3885137012",
                            "name": "email",
                            "onlyDomains": null,
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "email"
                        },
                        {
                            "hidden": false,
                            "id": "json1014178784",
                            "maxSize": 0,
                            "name": "mobile",
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "json"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text2375286809",
                            "max": 0,
                            "min": 3,
                            "name": "workspace",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": false,
                            "type": "text"
                        },
                        {
                            "exceptDomains": null,
                            "hidden": false,
                            "id": "url304673986",
                            "name": "workspace_url",
                            "onlyDomains": null,
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "url"
                        },
                        {
                            "hidden": false,
                            "id": "bool2086131741",
                            "name": "approved",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "bool"
                        },
                        {
                            "exceptDomains": null,
                            "hidden": false,
                            "id": "url2812878347",
                            "name": "domain",
                            "onlyDomains": null,
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "url"
                        },
                        {
                            "hidden": false,
                            "id": "json3846545605",
                            "maxSize": 0,
                            "name": "settings",
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "json"
                        },
                        {
                            "hidden": false,
                            "id": "file3834550803",
                            "maxSelect": 1,
                            "maxSize": 0,
                            "mimeTypes": [
                                "image/jpeg",
                                "image/png",
                                "image/svg+xml",
                                "image/gif",
                                "image/webp"
                            ],
                            "name": "logo",
                            "presentable": false,
                            "protected": false,
                            "required": false,
                            "system": false,
                            "thumbs": [],
                            "type": "file"
                        },
                        {
                            "hidden": false,
                            "id": "file1872607463",
                            "maxSelect": 1,
                            "maxSize": 0,
                            "mimeTypes": [
                                "image/jpeg",
                                "image/png",
                                "image/svg+xml",
                                "image/gif",
                                "image/webp"
                            ],
                            "name": "banner",
                            "presentable": false,
                            "protected": false,
                            "required": false,
                            "system": false,
                            "thumbs": [],
                            "type": "file"
                        },
                        {
                            "hidden": false,
                            "id": "bool411206709",
                            "name": "account_completed",
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "bool"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        }
                    ],
                    "id": "pbc_2524325754",
                    "indexes": [
                        "CREATE UNIQUE INDEX `idx_cQOniJuOd9` ON `organization` (`workspace`)"
                    ],
                    "listRule": "id = @request.auth.organization && (\n  @request.auth.role = 'admin' ||\n  @request.auth.role = 'manager' ||\n  @request.auth.role = 'cashier' ||\n  @request.auth.role = 'stock_manager'\n)",
                    "name": "organization",
                    "system": false,
                    "type": "base",
                    "updateRule": "id = @request.auth.organization && (\n  @request.auth.role = 'admin' ||\n  @request.auth.role = 'manager'\n)",
                    "viewRule": "id = @request.auth.organization && (\n  @request.auth.id != ''\n)"
                },
                {
                    "authAlert": {
                        "emailTemplate": {
                            "body": "<p>Hello,</p>\n<p>We noticed a login to your {APP_NAME} account from a new location.</p>\n<p>If this was you, you may disregard this email.</p>\n<p><strong>If this wasn't you, you should immediately change your {APP_NAME} account password to revoke access from all other locations.</strong></p>\n<p>\n  Thanks,<br/>\n  {APP_NAME} team\n</p>",
                            "subject": "Login from a new location"
                        },
                        "enabled": true
                    },
                    "authRule": "",
                    "authToken": {
                        "duration": 86400
                    },
                    "confirmEmailChangeTemplate": {
                        "body": "<p>Hello,</p>\n<p>Click on the button below to confirm your new email address.</p>\n<p>\n  <a class=\"btn\" href=\"{APP_URL}/_/#/auth/confirm-email-change/{TOKEN}\" target=\"_blank\" rel=\"noopener\">Confirm new email</a>\n</p>\n<p><i>If you didn't ask to change your email address, you can ignore this email.</i></p>\n<p>\n  Thanks,<br/>\n  {APP_NAME} team\n</p>",
                        "subject": "Confirm your {APP_NAME} new email address"
                    },
                    "createRule": "",
                    "deleteRule": "@request.auth.organization = organization && (\n  id = @request.auth.id ||\n  @request.auth.role = 'admin'\n)",
                    "emailChangeToken": {
                        "duration": 1800
                    },
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "cost": 0,
                            "hidden": true,
                            "id": "password901924565",
                            "max": 0,
                            "min": 8,
                            "name": "password",
                            "pattern": "",
                            "presentable": false,
                            "required": true,
                            "system": true,
                            "type": "password"
                        },
                        {
                            "autogeneratePattern": "[a-zA-Z0-9]{50}",
                            "hidden": true,
                            "id": "text2504183744",
                            "max": 60,
                            "min": 30,
                            "name": "tokenKey",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "exceptDomains": null,
                            "hidden": false,
                            "id": "email3885137012",
                            "name": "email",
                            "onlyDomains": null,
                            "presentable": false,
                            "required": true,
                            "system": true,
                            "type": "email"
                        },
                        {
                            "hidden": false,
                            "id": "bool1547992806",
                            "name": "emailVisibility",
                            "presentable": false,
                            "required": false,
                            "system": true,
                            "type": "bool"
                        },
                        {
                            "hidden": false,
                            "id": "bool256245529",
                            "name": "verified",
                            "presentable": false,
                            "required": false,
                            "system": true,
                            "type": "bool"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text1579384326",
                            "max": 0,
                            "min": 3,
                            "name": "name",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": false,
                            "type": "text"
                        },
                        {
                            "hidden": false,
                            "id": "json1014178784",
                            "maxSize": 0,
                            "name": "mobile",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "json"
                        },
                        {
                            "hidden": false,
                            "id": "select1466534506",
                            "maxSelect": 1,
                            "name": "role",
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "select",
                            "values": [
                                "admin",
                                "manager",
                                "cashier",
                                "stock_manager"
                            ]
                        },
                        {
                            "hidden": false,
                            "id": "file376926767",
                            "maxSelect": 1,
                            "maxSize": 0,
                            "mimeTypes": [
                                "image/jpeg",
                                "image/png",
                                "image/svg+xml",
                                "image/gif",
                                "image/webp"
                            ],
                            "name": "avatar",
                            "presentable": false,
                            "protected": false,
                            "required": false,
                            "system": false,
                            "thumbs": [],
                            "type": "file"
                        },
                        {
                            "hidden": false,
                            "id": "bool1265852921",
                            "name": "reset_password_on_login",
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "bool"
                        },
                        {
                            "hidden": false,
                            "id": "json3421297402",
                            "maxSize": 0,
                            "name": "overrides",
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "json"
                        },
                        {
                            "cascadeDelete": true,
                            "collectionId": "pbc_2524325754",
                            "hidden": false,
                            "id": "relation3253625724",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "organization",
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        }
                    ],
                    "fileToken": {
                        "duration": 180
                    },
                    "id": "pbc_3016299776",
                    "indexes": [
                        "CREATE UNIQUE INDEX `idx_tokenKey_pbc_3016299776` ON `tellers` (`tokenKey`)",
                        "CREATE UNIQUE INDEX `idx_email_pbc_3016299776` ON `tellers` (`email`) WHERE `email` != ''"
                    ],
                    "listRule": "@request.auth.organization = organization && (\n  id = @request.auth.id || \n  @request.auth.role = 'admin' ||\n  @request.auth.role = 'manager'\n)",
                    "manageRule": null,
                    "mfa": {
                        "duration": 1800,
                        "enabled": false,
                        "rule": ""
                    },
                    "name": "tellers",
                    "oauth2": {
                        "enabled": false,
                        "mappedFields": {
                            "avatarURL": "",
                            "id": "",
                            "name": "",
                            "username": ""
                        }
                    },
                    "otp": {
                        "duration": 180,
                        "emailTemplate": {
                            "body": "<p>Hello,</p>\n<p>Your one-time password is: <strong>{OTP}</strong></p>\n<p><i>If you didn't ask for the one-time password, you can ignore this email.</i></p>\n<p>\n  Thanks,<br/>\n  {APP_NAME} team\n</p>",
                            "subject": "OTP for {APP_NAME}"
                        },
                        "enabled": true,
                        "length": 8
                    },
                    "passwordAuth": {
                        "enabled": true,
                        "identityFields": [
                            "email"
                        ]
                    },
                    "passwordResetToken": {
                        "duration": 1800
                    },
                    "resetPasswordTemplate": {
                        "body": "<p>Hello,</p>\n<p>Click on the button below to reset your password.</p>\n<p>\n  <a class=\"btn\" href=\"{APP_URL}/_/#/auth/confirm-password-reset/{TOKEN}\" target=\"_blank\" rel=\"noopener\">Reset password</a>\n</p>\n<p><i>If you didn't ask to reset your password, you can ignore this email.</i></p>\n<p>\n  Thanks,<br/>\n  {APP_NAME} team\n</p>",
                        "subject": "Reset your {APP_NAME} password"
                    },
                    "system": false,
                    "type": "auth",
                    "updateRule": "@request.auth.organization = organization && (\n  id = @request.auth.id ||\n  @request.auth.role = 'admin'\n)",
                    "verificationTemplate": {
                        "body": "<p>Hello,</p>\n<p>Thank you for joining us at {APP_NAME}.</p>\n<p>Click on the button below to verify your email address.</p>\n<p>\n  <a class=\"btn\" href=\"{APP_URL}/_/#/auth/confirm-verification/{TOKEN}\" target=\"_blank\" rel=\"noopener\">Verify</a>\n</p>\n<p>\n  Thanks,<br/>\n  {APP_NAME} team\n</p>",
                        "subject": "Verify your {APP_NAME} email"
                    },
                    "verificationToken": {
                        "duration": 259200
                    },
                    "viewRule": "@request.auth.organization = organization && (\n  id = @request.auth.id || \n  @request.auth.role = 'admin' ||\n  @request.auth.role = 'manager'\n)"
                },
                {
                    "createRule": "@request.auth.organization != \"\" &&\n@request.auth.organization = organization && (\n  @request.auth.role = 'admin' || \n  @request.auth.role = 'manager' ||\n  @request.auth.role = 'stock_manager'\n)",
                    "deleteRule": "@request.auth.organization != \"\" &&\n@request.auth.organization.id = organization && (\n  @request.auth.role = 'admin'\n)",
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text1579384326",
                            "max": 0,
                            "min": 2,
                            "name": "name",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": false,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text3703245907",
                            "max": 0,
                            "min": 0,
                            "name": "unit",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": false,
                            "system": false,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "DS-[0-9]{15}",
                            "hidden": false,
                            "id": "text2544763494",
                            "max": 0,
                            "min": 3,
                            "name": "barcode",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": false,
                            "system": false,
                            "type": "text"
                        },
                        {
                            "hidden": false,
                            "id": "number2954362080",
                            "max": null,
                            "min": 0,
                            "name": "buying_price",
                            "onlyInt": false,
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "number"
                        },
                        {
                            "hidden": false,
                            "id": "number2737583402",
                            "max": null,
                            "min": 1,
                            "name": "selling_price",
                            "onlyInt": false,
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "number"
                        },
                        {
                            "hidden": false,
                            "id": "number1261852256",
                            "max": null,
                            "min": 0,
                            "name": "stock",
                            "onlyInt": true,
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "number"
                        },
                        {
                            "hidden": false,
                            "id": "file3277268710",
                            "maxSelect": 1,
                            "maxSize": 0,
                            "mimeTypes": [
                                "image/jpeg",
                                "image/png",
                                "image/svg+xml",
                                "image/gif",
                                "image/webp"
                            ],
                            "name": "thumbnail",
                            "presentable": false,
                            "protected": false,
                            "required": false,
                            "system": false,
                            "thumbs": [],
                            "type": "file"
                        },
                        {
                            "cascadeDelete": true,
                            "collectionId": "pbc_2524325754",
                            "hidden": false,
                            "id": "relation3253625724",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "organization",
                            "presentable": true,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "hidden": false,
                            "id": "json1874629670",
                            "maxSize": 0,
                            "name": "tags",
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "json"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        }
                    ],
                    "id": "pbc_1108966215",
                    "indexes": [],
                    "listRule": "@request.auth.organization != \"\" &&\n@request.auth.organization = organization && (\n  @request.auth.role = 'admin' || \n  @request.auth.role = 'manager' ||\n  @request.auth.role = 'cashier' ||\n  @request.auth.role = 'stock_manager'\n)",
                    "name": "product",
                    "system": false,
                    "type": "base",
                    "updateRule": "@request.auth.organization != \"\" &&\n@request.auth.organization = organization && (\n  @request.auth.role = 'admin' || \n  @request.auth.role = 'manager' ||\n  @request.auth.role = 'stock_manager'\n)",
                    "viewRule": "@request.auth.organization != \"\" &&\n@request.auth.organization = organization && (\n  @request.auth.role = 'admin' || \n  @request.auth.role = 'manager' ||\n  @request.auth.role = 'cashier' ||\n  @request.auth.role = 'stock_manager'\n)"
                },
                {
                    "createRule": null,
                    "deleteRule": null,
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "hidden": false,
                            "id": "number2535431193",
                            "max": null,
                            "min": 0,
                            "name": "totals",
                            "onlyInt": false,
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "number"
                        },
                        {
                            "hidden": false,
                            "id": "number3789599758",
                            "max": null,
                            "min": 0,
                            "name": "discount",
                            "onlyInt": false,
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "number"
                        },
                        {
                            "hidden": false,
                            "id": "number4122618561",
                            "max": null,
                            "min": 0,
                            "name": "profit",
                            "onlyInt": false,
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "number"
                        },
                        {
                            "hidden": false,
                            "id": "json1708301106",
                            "maxSize": 0,
                            "name": "payments",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "json"
                        },
                        {
                            "cascadeDelete": false,
                            "collectionId": "pbc_3016299776",
                            "hidden": false,
                            "id": "relation3860849476",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "teller",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "cascadeDelete": true,
                            "collectionId": "pbc_2524325754",
                            "hidden": false,
                            "id": "relation3253625724",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "organization",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        }
                    ],
                    "id": "pbc_2697449135",
                    "indexes": [],
                    "listRule": "@request.auth.organization != \"\" &&\n@request.auth.organization = organization && (\n  @request.auth.role = 'admin' || \n  @request.auth.role = 'manager' ||\n  @request.auth.role = 'cashier'\n)",
                    "name": "sales",
                    "system": false,
                    "type": "base",
                    "updateRule": null,
                    "viewRule": null
                },
                {
                    "createRule": null,
                    "deleteRule": null,
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "hidden": false,
                            "id": "json3015334490",
                            "maxSize": 10000,
                            "name": "products",
                            "presentable": true,
                            "required": true,
                            "system": false,
                            "type": "json"
                        },
                        {
                            "cascadeDelete": true,
                            "collectionId": "pbc_2697449135",
                            "hidden": false,
                            "id": "relation2756848135",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "sales_id",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "cascadeDelete": true,
                            "collectionId": "pbc_2524325754",
                            "hidden": false,
                            "id": "relation3253625724",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "organization",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        }
                    ],
                    "id": "pbc_3480387934",
                    "indexes": [],
                    "listRule": null,
                    "name": "sale_items",
                    "system": false,
                    "type": "base",
                    "updateRule": null,
                    "viewRule": null
                },
                {
                    "createRule": null,
                    "deleteRule": null,
                    "fields": [
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 0,
                            "min": 0,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "hidden": false,
                            "id": "_clone_iBol",
                            "max": null,
                            "min": 0,
                            "name": "totals",
                            "onlyInt": false,
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "number"
                        },
                        {
                            "hidden": false,
                            "id": "_clone_74Lw",
                            "max": null,
                            "min": 0,
                            "name": "discount",
                            "onlyInt": false,
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "number"
                        },
                        {
                            "hidden": false,
                            "id": "_clone_TNH8",
                            "max": null,
                            "min": 0,
                            "name": "profit",
                            "onlyInt": false,
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "number"
                        },
                        {
                            "hidden": false,
                            "id": "_clone_bABx",
                            "maxSize": 0,
                            "name": "payments",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "json"
                        },
                        {
                            "hidden": false,
                            "id": "_clone_Cv8X",
                            "maxSize": 10000,
                            "name": "products",
                            "presentable": true,
                            "required": true,
                            "system": false,
                            "type": "json"
                        },
                        {
                            "cascadeDelete": true,
                            "collectionId": "pbc_2524325754",
                            "hidden": false,
                            "id": "_clone_rioe",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "organization",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "cascadeDelete": false,
                            "collectionId": "pbc_3016299776",
                            "hidden": false,
                            "id": "_clone_5xjV",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "teller",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "hidden": false,
                            "id": "_clone_N6B5",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        }
                    ],
                    "id": "pbc_3447202759",
                    "indexes": [],
                    "listRule": "@request.auth.organization != \"\" &&\n@request.auth.organization = organization && (\n  @request.auth.role = 'admin' || \n  @request.auth.role = 'manager' ||\n  @request.auth.role = 'cashier'\n)",
                    "name": "sales_view",
                    "system": false,
                    "type": "view",
                    "updateRule": null,
                    "viewQuery": "SELECT s.id, s.totals, s.discount, s.profit, s.payments, si.products, s.organization, s.teller, s.created\nFROM sales s INNER JOIN sale_items si\nON s.id = si.sales_id\nWHERE s.organization = si.organization and \ns.created != \"NULL\"",
                    "viewRule": null
                },
                {
                    "createRule": "@request.auth.organization != \"\" &&\n@request.auth.organization = organization && (\n  @request.auth.role = 'admin' || \n  @request.auth.role = 'manager' ||\n  @request.auth.role = 'cashier'\n)",
                    "deleteRule": null,
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "autogeneratePattern": "",
                            "hidden": false,
                            "id": "text1579384326",
                            "max": 40,
                            "min": 3,
                            "name": "name",
                            "pattern": "",
                            "presentable": false,
                            "primaryKey": false,
                            "required": true,
                            "system": false,
                            "type": "text"
                        },
                        {
                            "exceptDomains": [],
                            "hidden": false,
                            "id": "email3885137012",
                            "name": "email",
                            "onlyDomains": [],
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "email"
                        },
                        {
                            "hidden": false,
                            "id": "json1014178784",
                            "maxSize": 0,
                            "name": "mobile",
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "json"
                        },
                        {
                            "cascadeDelete": true,
                            "collectionId": "pbc_2524325754",
                            "hidden": false,
                            "id": "relation3253625724",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "organization",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        }
                    ],
                    "id": "pbc_3355664324",
                    "indexes": [],
                    "listRule": "@request.auth.organization != \"\" &&\n@request.auth.organization = organization && (\n  @request.auth.role = 'admin' || \n  @request.auth.role = 'manager' ||\n  @request.auth.role = 'stock_manager'\n)",
                    "name": "suppliers",
                    "system": false,
                    "type": "base",
                    "updateRule": null,
                    "viewRule": "@request.auth.organization != \"\" &&\n@request.auth.organization = organization && (\n  @request.auth.role = 'admin' || \n  @request.auth.role = 'manager' ||\n  @request.auth.role = 'stock_manager'\n)"
                },
                {
                    "createRule": null,
                    "deleteRule": null,
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "hidden": false,
                            "id": "number2392944706",
                            "max": null,
                            "min": 0,
                            "name": "amount",
                            "onlyInt": false,
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "number"
                        },
                        {
                            "hidden": false,
                            "id": "json3015334490",
                            "maxSize": 30000000,
                            "name": "products",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "json"
                        },
                        {
                            "hidden": false,
                            "id": "file104153177",
                            "maxSelect": 99,
                            "maxSize": 0,
                            "mimeTypes": [
                                "image/jpeg",
                                "image/png",
                                "image/svg+xml",
                                "image/webp",
                                "application/pdf"
                            ],
                            "name": "files",
                            "presentable": true,
                            "protected": true,
                            "required": false,
                            "system": false,
                            "thumbs": [],
                            "type": "file"
                        },
                        {
                            "cascadeDelete": false,
                            "collectionId": "pbc_3355664324",
                            "hidden": false,
                            "id": "relation2603248766",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "supplier",
                            "presentable": true,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "cascadeDelete": false,
                            "collectionId": "pbc_3016299776",
                            "hidden": false,
                            "id": "relation3860849476",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "teller",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "cascadeDelete": true,
                            "collectionId": "pbc_2524325754",
                            "hidden": false,
                            "id": "relation3253625724",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "organization",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        }
                    ],
                    "id": "pbc_3842697666",
                    "indexes": [],
                    "listRule": "@request.auth.organization != \"\" &&\n@request.auth.organization = organization && (\n  @request.auth.role = 'admin' || \n  @request.auth.role = 'manager' ||\n  @request.auth.role = 'stock_manager'\n)",
                    "name": "supply",
                    "system": false,
                    "type": "base",
                    "updateRule": null,
                    "viewRule": "@request.auth.organization != \"\" &&\n@request.auth.organization = organization && (\n  @request.auth.role = 'admin' || \n  @request.auth.role = 'manager' ||\n  @request.auth.role = 'stock_manager'\n)"
                },
                {
                    "createRule": null,
                    "deleteRule": null,
                    "fields": [
                        {
                            "autogeneratePattern": "[a-z0-9]{15}",
                            "hidden": false,
                            "id": "text3208210256",
                            "max": 15,
                            "min": 15,
                            "name": "id",
                            "pattern": "^[a-z0-9]+$",
                            "presentable": false,
                            "primaryKey": true,
                            "required": true,
                            "system": true,
                            "type": "text"
                        },
                        {
                            "hidden": false,
                            "id": "number2683508278",
                            "max": null,
                            "min": 0,
                            "name": "quantity",
                            "onlyInt": false,
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "number"
                        },
                        {
                            "hidden": false,
                            "id": "select1204587666",
                            "maxSelect": 1,
                            "name": "action",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "select",
                            "values": [
                                "add",
                                "purge"
                            ]
                        },
                        {
                            "cascadeDelete": false,
                            "collectionId": "pbc_1108966215",
                            "hidden": false,
                            "id": "relation3544843437",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "product",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "cascadeDelete": true,
                            "collectionId": "pbc_2524325754",
                            "hidden": false,
                            "id": "relation3253625724",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "organization",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "cascadeDelete": false,
                            "collectionId": "pbc_3016299776",
                            "hidden": false,
                            "id": "relation3860849476",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "teller",
                            "presentable": false,
                            "required": true,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "cascadeDelete": false,
                            "collectionId": "pbc_3355664324",
                            "hidden": false,
                            "id": "relation2603248766",
                            "maxSelect": 1,
                            "minSelect": 0,
                            "name": "supplier",
                            "presentable": false,
                            "required": false,
                            "system": false,
                            "type": "relation"
                        },
                        {
                            "hidden": false,
                            "id": "autodate2990389176",
                            "name": "created",
                            "onCreate": true,
                            "onUpdate": false,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        },
                        {
                            "hidden": false,
                            "id": "autodate3332085495",
                            "name": "updated",
                            "onCreate": true,
                            "onUpdate": true,
                            "presentable": false,
                            "system": false,
                            "type": "autodate"
                        }
                    ],
                    "id": "pbc_3609746841",
                    "indexes": [],
                    "listRule": null,
                    "name": "stock_history",
                    "system": false,
                    "type": "base",
                    "updateRule": null,
                    "viewRule": null
                }
            ];

            return app.importCollections(snapshot, true);
        }, (app) => {
            return null;
        })
