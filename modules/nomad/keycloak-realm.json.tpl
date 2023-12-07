{
  "id" : "337d06d2-cea1-423b-810e-d87ed8650319",
  "realm" : "nomad",
  "notBefore" : 0,
  "defaultSignatureAlgorithm" : "RS256",
  "revokeRefreshToken" : false,
  "refreshTokenMaxReuse" : 0,
  "accessTokenLifespan" : 300,
  "accessTokenLifespanForImplicitFlow" : 900,
  "ssoSessionIdleTimeout" : 1800,
  "ssoSessionMaxLifespan" : 36000,
  "ssoSessionIdleTimeoutRememberMe" : 0,
  "ssoSessionMaxLifespanRememberMe" : 0,
  "offlineSessionIdleTimeout" : 2592000,
  "offlineSessionMaxLifespanEnabled" : false,
  "offlineSessionMaxLifespan" : 5184000,
  "clientSessionIdleTimeout" : 0,
  "clientSessionMaxLifespan" : 0,
  "clientOfflineSessionIdleTimeout" : 0,
  "clientOfflineSessionMaxLifespan" : 0,
  "accessCodeLifespan" : 60,
  "accessCodeLifespanUserAction" : 300,
  "accessCodeLifespanLogin" : 1800,
  "actionTokenGeneratedByAdminLifespan" : 43200,
  "actionTokenGeneratedByUserLifespan" : 300,
  "oauth2DeviceCodeLifespan" : 600,
  "oauth2DevicePollingInterval" : 5,
  "enabled" : true,
  "sslRequired" : "external",
  "registrationAllowed" : false,
  "registrationEmailAsUsername" : false,
  "rememberMe" : false,
  "verifyEmail" : false,
  "loginWithEmailAllowed" : true,
  "duplicateEmailsAllowed" : false,
  "resetPasswordAllowed" : false,
  "editUsernameAllowed" : false,
  "bruteForceProtected" : false,
  "permanentLockout" : false,
  "maxFailureWaitSeconds" : 900,
  "minimumQuickLoginWaitSeconds" : 60,
  "waitIncrementSeconds" : 60,
  "quickLoginCheckMilliSeconds" : 1000,
  "maxDeltaTimeSeconds" : 43200,
  "failureFactor" : 30,
  "roles" : {
    "realm" : [ {
      "id" : "34ab9f5e-88e8-41ab-b306-dd439ad7c1f0",
      "name" : "default-roles-nomad",
      "description" : "$${role_default-roles}",
      "composite" : true,
      "composites" : {
        "realm" : [ "offline_access", "uma_authorization" ],
        "client" : {
          "account" : [ "manage-account", "view-profile" ]
        }
      },
      "clientRole" : false,
      "containerId" : "337d06d2-cea1-423b-810e-d87ed8650319",
      "attributes" : { }
    }, {
      "id" : "960a62a2-7a5c-4695-aefe-da78f6d51eb5",
      "name" : "offline_access",
      "description" : "$${role_offline-access}",
      "composite" : false,
      "clientRole" : false,
      "containerId" : "337d06d2-cea1-423b-810e-d87ed8650319",
      "attributes" : { }
    }, {
      "id" : "94c9757a-3b71-4eac-8f1f-c731311080ba",
      "name" : "uma_authorization",
      "description" : "$${role_uma_authorization}",
      "composite" : false,
      "clientRole" : false,
      "containerId" : "337d06d2-cea1-423b-810e-d87ed8650319",
      "attributes" : { }
    } ],
    "client" : {
      "realm-management" : [ {
        "id" : "13a1d271-0f8b-403f-b82f-ffce15d2b9ac",
        "name" : "manage-authorization",
        "description" : "$${role_manage-authorization}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "0b02f3bd-d56f-4110-b8e4-de8e2d7386ad",
        "name" : "manage-users",
        "description" : "$${role_manage-users}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "235d6708-3233-4b42-95b2-3ed6e1c55f1e",
        "name" : "realm-admin",
        "description" : "$${role_realm-admin}",
        "composite" : true,
        "composites" : {
          "client" : {
            "realm-management" : [ "manage-users", "manage-authorization", "manage-realm", "create-client", "view-authorization", "impersonation", "view-identity-providers", "view-events", "query-clients", "query-groups", "query-realms", "manage-clients", "manage-identity-providers", "query-users", "view-users", "view-realm", "view-clients", "manage-events" ]
          }
        },
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "c716a538-6a54-474c-8378-7332a596fd41",
        "name" : "manage-realm",
        "description" : "$${role_manage-realm}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "13da6cc4-e207-4366-b40b-0acd927af55e",
        "name" : "create-client",
        "description" : "$${role_create-client}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "832dd05c-6d79-42bf-96c9-7965f9cd8307",
        "name" : "view-authorization",
        "description" : "$${role_view-authorization}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "5f79eadc-d682-4fe3-b255-9cb65ff75982",
        "name" : "impersonation",
        "description" : "$${role_impersonation}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "602d0d1a-1741-476a-9380-bd7c3efc0ed5",
        "name" : "view-identity-providers",
        "description" : "$${role_view-identity-providers}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "a20fe129-0d46-414a-aa33-0feea6029372",
        "name" : "view-events",
        "description" : "$${role_view-events}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "b811ee28-46e5-4351-84d6-042f457e4529",
        "name" : "query-clients",
        "description" : "$${role_query-clients}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "fdc91a91-a45b-4890-8aac-ba7adeddfd99",
        "name" : "manage-clients",
        "description" : "$${role_manage-clients}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "0a51e26a-bb21-45fd-bd0d-685a5b8c7808",
        "name" : "query-groups",
        "description" : "$${role_query-groups}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "7ff2ba60-80f2-42c6-87fb-ea1a5e5ac94d",
        "name" : "query-realms",
        "description" : "$${role_query-realms}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "64d8cf53-ee67-4c18-aa23-53c53eb8be26",
        "name" : "manage-identity-providers",
        "description" : "$${role_manage-identity-providers}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "a7aeaeb4-8090-4970-82d7-fbde1701e147",
        "name" : "query-users",
        "description" : "$${role_query-users}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "b99a5769-d5bd-4fe5-93c0-4c7cbe78f815",
        "name" : "view-realm",
        "description" : "$${role_view-realm}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "7b6b0ec4-b47e-4f39-8180-b04110152ae9",
        "name" : "view-users",
        "description" : "$${role_view-users}",
        "composite" : true,
        "composites" : {
          "client" : {
            "realm-management" : [ "query-groups", "query-users" ]
          }
        },
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "ef73dadb-aa53-44c1-b18d-2479a00e0088",
        "name" : "view-clients",
        "description" : "$${role_view-clients}",
        "composite" : true,
        "composites" : {
          "client" : {
            "realm-management" : [ "query-clients" ]
          }
        },
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      }, {
        "id" : "dc322179-5490-4dde-8cf3-8f76139f7866",
        "name" : "manage-events",
        "description" : "$${role_manage-events}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
        "attributes" : { }
      } ],
      "security-admin-console" : [ ],
      "admin-cli" : [ ],
      "account-console" : [ ],
      "broker" : [ {
        "id" : "dc2a2070-b78c-42a2-8b7b-a7b8ea38cdb4",
        "name" : "read-token",
        "description" : "$${role_read-token}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "bd3343c2-64c4-44f4-a2eb-785fd893dc66",
        "attributes" : { }
      } ],
      "nomad" : [ ],
      "account" : [ {
        "id" : "e2f824e2-c828-4fc0-84f3-0d226eb51984",
        "name" : "manage-consent",
        "description" : "$${role_manage-consent}",
        "composite" : true,
        "composites" : {
          "client" : {
            "account" : [ "view-consent" ]
          }
        },
        "clientRole" : true,
        "containerId" : "86afd68d-a4f8-4829-a65a-8c2e29b81c0f",
        "attributes" : { }
      }, {
        "id" : "2b166b1b-38b3-4e17-a422-071b326d59ee",
        "name" : "view-groups",
        "description" : "$${role_view-groups}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "86afd68d-a4f8-4829-a65a-8c2e29b81c0f",
        "attributes" : { }
      }, {
        "id" : "0ea86830-9be7-4dab-825f-5dcd83281026",
        "name" : "view-consent",
        "description" : "$${role_view-consent}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "86afd68d-a4f8-4829-a65a-8c2e29b81c0f",
        "attributes" : { }
      }, {
        "id" : "3bbf78e1-f208-4d4e-8642-818d57360b68",
        "name" : "manage-account",
        "description" : "$${role_manage-account}",
        "composite" : true,
        "composites" : {
          "client" : {
            "account" : [ "manage-account-links" ]
          }
        },
        "clientRole" : true,
        "containerId" : "86afd68d-a4f8-4829-a65a-8c2e29b81c0f",
        "attributes" : { }
      }, {
        "id" : "5d246169-9b1e-46d9-835e-2a3721b29e23",
        "name" : "delete-account",
        "description" : "$${role_delete-account}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "86afd68d-a4f8-4829-a65a-8c2e29b81c0f",
        "attributes" : { }
      }, {
        "id" : "ff362d1f-be35-4377-98ef-4078e99d35da",
        "name" : "view-profile",
        "description" : "$${role_view-profile}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "86afd68d-a4f8-4829-a65a-8c2e29b81c0f",
        "attributes" : { }
      }, {
        "id" : "639fe3e8-360b-4aec-93d3-3ecff333fa9d",
        "name" : "view-applications",
        "description" : "$${role_view-applications}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "86afd68d-a4f8-4829-a65a-8c2e29b81c0f",
        "attributes" : { }
      }, {
        "id" : "b6498560-7a3e-4899-ab55-d098d50cef2a",
        "name" : "manage-account-links",
        "description" : "$${role_manage-account-links}",
        "composite" : false,
        "clientRole" : true,
        "containerId" : "86afd68d-a4f8-4829-a65a-8c2e29b81c0f",
        "attributes" : { }
      } ]
    }
  },
  "groups" : [ {
    "id" : "64b90a37-2ed7-4f3e-b06c-0679cb042e0d",
    "name" : "admin",
    "path" : "/admin",
    "attributes" : { },
    "realmRoles" : [ ],
    "clientRoles" : { },
    "subGroups" : [ ]
  }, {
    "id" : "f5c624db-216a-4835-9762-0afbd17691fd",
    "name" : "operator",
    "path" : "/operator",
    "attributes" : { },
    "realmRoles" : [ ],
    "clientRoles" : { },
    "subGroups" : [ ]
  } ],
  "defaultRole" : {
    "id" : "34ab9f5e-88e8-41ab-b306-dd439ad7c1f0",
    "name" : "default-roles-nomad",
    "description" : "$${role_default-roles}",
    "composite" : true,
    "clientRole" : false,
    "containerId" : "337d06d2-cea1-423b-810e-d87ed8650319"
  },
  "requiredCredentials" : [ "password" ],
  "otpPolicyType" : "totp",
  "otpPolicyAlgorithm" : "HmacSHA1",
  "otpPolicyInitialCounter" : 0,
  "otpPolicyDigits" : 6,
  "otpPolicyLookAheadWindow" : 1,
  "otpPolicyPeriod" : 30,
  "otpPolicyCodeReusable" : false,
  "otpSupportedApplications" : [ "totpAppFreeOTPName", "totpAppMicrosoftAuthenticatorName", "totpAppGoogleName" ],
  "webAuthnPolicyRpEntityName" : "keycloak",
  "webAuthnPolicySignatureAlgorithms" : [ "ES256" ],
  "webAuthnPolicyRpId" : "",
  "webAuthnPolicyAttestationConveyancePreference" : "not specified",
  "webAuthnPolicyAuthenticatorAttachment" : "not specified",
  "webAuthnPolicyRequireResidentKey" : "not specified",
  "webAuthnPolicyUserVerificationRequirement" : "not specified",
  "webAuthnPolicyCreateTimeout" : 0,
  "webAuthnPolicyAvoidSameAuthenticatorRegister" : false,
  "webAuthnPolicyAcceptableAaguids" : [ ],
  "webAuthnPolicyPasswordlessRpEntityName" : "keycloak",
  "webAuthnPolicyPasswordlessSignatureAlgorithms" : [ "ES256" ],
  "webAuthnPolicyPasswordlessRpId" : "",
  "webAuthnPolicyPasswordlessAttestationConveyancePreference" : "not specified",
  "webAuthnPolicyPasswordlessAuthenticatorAttachment" : "not specified",
  "webAuthnPolicyPasswordlessRequireResidentKey" : "not specified",
  "webAuthnPolicyPasswordlessUserVerificationRequirement" : "not specified",
  "webAuthnPolicyPasswordlessCreateTimeout" : 0,
  "webAuthnPolicyPasswordlessAvoidSameAuthenticatorRegister" : false,
  "webAuthnPolicyPasswordlessAcceptableAaguids" : [ ],
  "users" : [ {
    "id" : "c067344f-047d-49b7-ac7e-f2829c952912",
    "createdTimestamp" : 1687951248337,
    "username" : "admin",
    "enabled" : true,
    "totp" : false,
    "emailVerified" : true,
    "firstName" : "Admin",
    "lastName" : "Admin",
    "email" : "admin@example.com",
    "credentials" : [ {
      "id" : "cce98108-7106-443e-993a-e6f40fdd3cb6",
      "type" : "password",
      "userLabel" : "My password",
      "createdDate" : 1687951257010,
      "secretData" : "{\"value\":\"1lIDlDbAhwMy65jbTckMJtsqFquBb/FIHDCLbL+5uLw=\",\"salt\":\"QgTLNVCS8lumN+r0M5kBPQ==\",\"additionalParameters\":{}}",
      "credentialData" : "{\"hashIterations\":27500,\"algorithm\":\"pbkdf2-sha256\",\"additionalParameters\":{}}"
    } ],
    "disableableCredentialTypes" : [ ],
    "requiredActions" : [ ],
    "realmRoles" : [ "default-roles-nomad" ],
    "notBefore" : 0,
    "groups" : [ "/admin" ]
  }, {
    "id" : "3aa0e584-fd91-48d4-91dc-7bd2bbf91131",
    "createdTimestamp" : 1687951336302,
    "username" : "operator",
    "enabled" : true,
    "totp" : false,
    "emailVerified" : true,
    "firstName" : "Operator",
    "lastName" : "Operator",
    "email" : "operator@example.com",
    "credentials" : [ {
      "id" : "10f849c4-05ef-4a87-93ef-79208832b45e",
      "type" : "password",
      "userLabel" : "My password",
      "createdDate" : 1687951345256,
      "secretData" : "{\"value\":\"jOjoCCWY8HXKqKdBGHmIIFAQ6aXThZKySiM/x9nfIYk=\",\"salt\":\"JnB0Lb/OdNMmU5H88sn1gQ==\",\"additionalParameters\":{}}",
      "credentialData" : "{\"hashIterations\":27500,\"algorithm\":\"pbkdf2-sha256\",\"additionalParameters\":{}}"
    } ],
    "disableableCredentialTypes" : [ ],
    "requiredActions" : [ ],
    "realmRoles" : [ "default-roles-nomad" ],
    "notBefore" : 0,
    "groups" : [ "/operator" ]
  } ],
  "scopeMappings" : [ {
    "clientScope" : "offline_access",
    "roles" : [ "offline_access" ]
  } ],
  "clientScopeMappings" : {
    "account" : [ {
      "client" : "account-console",
      "roles" : [ "manage-account", "view-groups" ]
    } ]
  },
  "clients" : [ {
    "id" : "86afd68d-a4f8-4829-a65a-8c2e29b81c0f",
    "clientId" : "account",
    "name" : "$${client_account}",
    "rootUrl" : "$${authBaseUrl}",
    "baseUrl" : "/realms/nomad/account/",
    "surrogateAuthRequired" : false,
    "enabled" : true,
    "alwaysDisplayInConsole" : false,
    "clientAuthenticatorType" : "client-secret",
    "redirectUris" : [ "/realms/nomad/account/*" ],
    "webOrigins" : [ ],
    "notBefore" : 0,
    "bearerOnly" : false,
    "consentRequired" : false,
    "standardFlowEnabled" : true,
    "implicitFlowEnabled" : false,
    "directAccessGrantsEnabled" : false,
    "serviceAccountsEnabled" : false,
    "publicClient" : true,
    "frontchannelLogout" : false,
    "protocol" : "openid-connect",
    "attributes" : {
      "post.logout.redirect.uris" : "+"
    },
    "authenticationFlowBindingOverrides" : { },
    "fullScopeAllowed" : false,
    "nodeReRegistrationTimeout" : 0,
    "defaultClientScopes" : [ "web-origins", "acr", "profile", "roles", "email" ],
    "optionalClientScopes" : [ "address", "phone", "offline_access", "microprofile-jwt" ]
  }, {
    "id" : "d939b86b-4161-4dcd-8fc3-b1d34c2f1f59",
    "clientId" : "account-console",
    "name" : "$${client_account-console}",
    "rootUrl" : "$${authBaseUrl}",
    "baseUrl" : "/realms/nomad/account/",
    "surrogateAuthRequired" : false,
    "enabled" : true,
    "alwaysDisplayInConsole" : false,
    "clientAuthenticatorType" : "client-secret",
    "redirectUris" : [ "/realms/nomad/account/*" ],
    "webOrigins" : [ ],
    "notBefore" : 0,
    "bearerOnly" : false,
    "consentRequired" : false,
    "standardFlowEnabled" : true,
    "implicitFlowEnabled" : false,
    "directAccessGrantsEnabled" : false,
    "serviceAccountsEnabled" : false,
    "publicClient" : true,
    "frontchannelLogout" : false,
    "protocol" : "openid-connect",
    "attributes" : {
      "post.logout.redirect.uris" : "+",
      "pkce.code.challenge.method" : "S256"
    },
    "authenticationFlowBindingOverrides" : { },
    "fullScopeAllowed" : false,
    "nodeReRegistrationTimeout" : 0,
    "protocolMappers" : [ {
      "id" : "ac7e3b45-ba4f-468e-bfc8-af8a9535c220",
      "name" : "audience resolve",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-audience-resolve-mapper",
      "consentRequired" : false,
      "config" : { }
    } ],
    "defaultClientScopes" : [ "web-origins", "acr", "profile", "roles", "email" ],
    "optionalClientScopes" : [ "address", "phone", "offline_access", "microprofile-jwt" ]
  }, {
    "id" : "01cd2e65-6e96-44af-9fb5-0c984e6c353a",
    "clientId" : "admin-cli",
    "name" : "$${client_admin-cli}",
    "surrogateAuthRequired" : false,
    "enabled" : true,
    "alwaysDisplayInConsole" : false,
    "clientAuthenticatorType" : "client-secret",
    "redirectUris" : [ ],
    "webOrigins" : [ ],
    "notBefore" : 0,
    "bearerOnly" : false,
    "consentRequired" : false,
    "standardFlowEnabled" : false,
    "implicitFlowEnabled" : false,
    "directAccessGrantsEnabled" : true,
    "serviceAccountsEnabled" : false,
    "publicClient" : true,
    "frontchannelLogout" : false,
    "protocol" : "openid-connect",
    "attributes" : { },
    "authenticationFlowBindingOverrides" : { },
    "fullScopeAllowed" : false,
    "nodeReRegistrationTimeout" : 0,
    "defaultClientScopes" : [ "web-origins", "acr", "profile", "roles", "email" ],
    "optionalClientScopes" : [ "address", "phone", "offline_access", "microprofile-jwt" ]
  }, {
    "id" : "bd3343c2-64c4-44f4-a2eb-785fd893dc66",
    "clientId" : "broker",
    "name" : "$${client_broker}",
    "surrogateAuthRequired" : false,
    "enabled" : true,
    "alwaysDisplayInConsole" : false,
    "clientAuthenticatorType" : "client-secret",
    "redirectUris" : [ ],
    "webOrigins" : [ ],
    "notBefore" : 0,
    "bearerOnly" : true,
    "consentRequired" : false,
    "standardFlowEnabled" : true,
    "implicitFlowEnabled" : false,
    "directAccessGrantsEnabled" : false,
    "serviceAccountsEnabled" : false,
    "publicClient" : false,
    "frontchannelLogout" : false,
    "protocol" : "openid-connect",
    "attributes" : { },
    "authenticationFlowBindingOverrides" : { },
    "fullScopeAllowed" : false,
    "nodeReRegistrationTimeout" : 0,
    "defaultClientScopes" : [ "web-origins", "acr", "profile", "roles", "email" ],
    "optionalClientScopes" : [ "address", "phone", "offline_access", "microprofile-jwt" ]
  }, {
    "id" : "fa1187c9-435f-4132-8c6e-4b365e6ed3c5",
    "clientId" : "nomad",
    "name" : "Nomad",
    "description" : "",
    "rootUrl" : "http://nomad.${external_domain}/ui",
    "adminUrl" : "http://nomad.${external_domain}/ui",
    "baseUrl" : "",
    "surrogateAuthRequired" : false,
    "enabled" : true,
    "alwaysDisplayInConsole" : false,
    "clientAuthenticatorType" : "client-secret",
    "secret" : "nomad-oidc-authentication-secret",
    "redirectUris" : [
      "http://localhost:4649/oidc/callback",
      "http://nomad.${external_domain}/ui/settings/tokens",
      "https://nomad.${external_domain}/ui/settings/tokens"
    ],
    "webOrigins" : [ "+" ],
    "notBefore" : 0,
    "bearerOnly" : false,
    "consentRequired" : false,
    "standardFlowEnabled" : true,
    "implicitFlowEnabled" : false,
    "directAccessGrantsEnabled" : true,
    "serviceAccountsEnabled" : false,
    "publicClient" : false,
    "frontchannelLogout" : true,
    "protocol" : "openid-connect",
    "attributes" : {
      "oidc.ciba.grant.enabled" : "false",
      "client.secret.creation.time" : "1687951191",
      "backchannel.logout.session.required" : "true",
      "post.logout.redirect.uris" : "http://nomad.${external_domain}/ui/*",
      "oauth2.device.authorization.grant.enabled" : "false",
      "backchannel.logout.revoke.offline.tokens" : "false"
    },
    "authenticationFlowBindingOverrides" : { },
    "fullScopeAllowed" : true,
    "nodeReRegistrationTimeout" : -1,
    "defaultClientScopes" : [ "web-origins", "acr", "profile", "roles", "email", "groups" ],
    "optionalClientScopes" : [ "address", "phone", "offline_access", "microprofile-jwt" ]
  }, {
    "id" : "8b82722a-aca0-4afd-894e-69bb894ffa87",
    "clientId" : "realm-management",
    "name" : "$${client_realm-management}",
    "surrogateAuthRequired" : false,
    "enabled" : true,
    "alwaysDisplayInConsole" : false,
    "clientAuthenticatorType" : "client-secret",
    "redirectUris" : [ ],
    "webOrigins" : [ ],
    "notBefore" : 0,
    "bearerOnly" : true,
    "consentRequired" : false,
    "standardFlowEnabled" : true,
    "implicitFlowEnabled" : false,
    "directAccessGrantsEnabled" : false,
    "serviceAccountsEnabled" : false,
    "publicClient" : false,
    "frontchannelLogout" : false,
    "protocol" : "openid-connect",
    "attributes" : { },
    "authenticationFlowBindingOverrides" : { },
    "fullScopeAllowed" : false,
    "nodeReRegistrationTimeout" : 0,
    "defaultClientScopes" : [ "web-origins", "acr", "profile", "roles", "email" ],
    "optionalClientScopes" : [ "address", "phone", "offline_access", "microprofile-jwt" ]
  }, {
    "id" : "137ca382-1b53-4bee-94a9-944b46b72e95",
    "clientId" : "security-admin-console",
    "name" : "$${client_security-admin-console}",
    "rootUrl" : "$${authAdminUrl}",
    "baseUrl" : "/admin/nomad/console/",
    "surrogateAuthRequired" : false,
    "enabled" : true,
    "alwaysDisplayInConsole" : false,
    "clientAuthenticatorType" : "client-secret",
    "redirectUris" : [ "/admin/nomad/console/*" ],
    "webOrigins" : [ "+" ],
    "notBefore" : 0,
    "bearerOnly" : false,
    "consentRequired" : false,
    "standardFlowEnabled" : true,
    "implicitFlowEnabled" : false,
    "directAccessGrantsEnabled" : false,
    "serviceAccountsEnabled" : false,
    "publicClient" : true,
    "frontchannelLogout" : false,
    "protocol" : "openid-connect",
    "attributes" : {
      "post.logout.redirect.uris" : "+",
      "pkce.code.challenge.method" : "S256"
    },
    "authenticationFlowBindingOverrides" : { },
    "fullScopeAllowed" : false,
    "nodeReRegistrationTimeout" : 0,
    "protocolMappers" : [ {
      "id" : "1e14062b-7f2a-4a48-bdac-fd629b1ea97b",
      "name" : "locale",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "locale",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "locale",
        "jsonType.label" : "String"
      }
    } ],
    "defaultClientScopes" : [ "web-origins", "acr", "profile", "roles", "email" ],
    "optionalClientScopes" : [ "address", "phone", "offline_access", "microprofile-jwt" ]
  } ],
  "clientScopes" : [ {
    "id" : "ba68a8ed-8266-4bdb-80c4-941409950e54",
    "name" : "groups",
    "description" : "",
    "protocol" : "openid-connect",
    "attributes" : {
      "include.in.token.scope" : "true",
      "display.on.consent.screen" : "true",
      "gui.order" : "",
      "consent.screen.text" : ""
    },
    "protocolMappers" : [ {
      "id" : "feb985d4-0715-46a0-b3b4-dc642ff941d8",
      "name" : "groups",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-group-membership-mapper",
      "consentRequired" : false,
      "config" : {
        "full.path" : "false",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "groups",
        "userinfo.token.claim" : "true"
      }
    } ]
  }, {
    "id" : "8307efb2-1318-4d98-bcca-7d891995769a",
    "name" : "offline_access",
    "description" : "OpenID Connect built-in scope: offline_access",
    "protocol" : "openid-connect",
    "attributes" : {
      "consent.screen.text" : "$${offlineAccessScopeConsentText}",
      "display.on.consent.screen" : "true"
    }
  }, {
    "id" : "4854ddf6-794b-4f3b-af0f-9bc30f37059d",
    "name" : "profile",
    "description" : "OpenID Connect built-in scope: profile",
    "protocol" : "openid-connect",
    "attributes" : {
      "include.in.token.scope" : "true",
      "display.on.consent.screen" : "true",
      "consent.screen.text" : "$${profileScopeConsentText}"
    },
    "protocolMappers" : [ {
      "id" : "005e2115-f192-44d9-acba-a05fedf5b6cb",
      "name" : "profile",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "profile",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "profile",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "e4775dd1-3540-4236-98e5-cb8ea0fcdd45",
      "name" : "birthdate",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "birthdate",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "birthdate",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "fa399007-f369-47c7-9ae1-662c9ffbd2a8",
      "name" : "locale",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "locale",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "locale",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "872c7c16-7cff-4f52-8893-4fe5e4e7207f",
      "name" : "updated at",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "updatedAt",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "updated_at",
        "jsonType.label" : "long"
      }
    }, {
      "id" : "08da05f2-90d5-4064-bb75-a2c06dc564cc",
      "name" : "picture",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "picture",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "picture",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "02667a2c-a839-4b2a-b2e1-744ca471ea29",
      "name" : "family name",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-property-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "lastName",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "family_name",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "a1ffccd2-012e-41e7-a732-b0d7f9f701a2",
      "name" : "zoneinfo",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "zoneinfo",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "zoneinfo",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "abcbd42f-bb58-401d-aef1-ea435ae89768",
      "name" : "full name",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-full-name-mapper",
      "consentRequired" : false,
      "config" : {
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "userinfo.token.claim" : "true"
      }
    }, {
      "id" : "e95ca63a-6de9-463b-ad8f-206addad0a62",
      "name" : "middle name",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "middleName",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "middle_name",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "5e7eca45-34ac-4968-893e-e2ac4e92e782",
      "name" : "username",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-property-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "username",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "preferred_username",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "7f11a57c-44dd-482e-a79d-07b0225295e0",
      "name" : "website",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "website",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "website",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "b29a6adc-e2cd-4fb6-8f8e-bd006ab5f2ae",
      "name" : "nickname",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "nickname",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "nickname",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "9fd4cdc6-c1b1-464d-9771-b40ce60e6d09",
      "name" : "gender",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "gender",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "gender",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "0b915dcc-322a-474d-92db-d5dcd9e4604c",
      "name" : "given name",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-property-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "firstName",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "given_name",
        "jsonType.label" : "String"
      }
    } ]
  }, {
    "id" : "47bc1c4a-5d4f-40db-9619-9990887a091a",
    "name" : "web-origins",
    "description" : "OpenID Connect scope for add allowed web origins to the access token",
    "protocol" : "openid-connect",
    "attributes" : {
      "include.in.token.scope" : "false",
      "display.on.consent.screen" : "false",
      "consent.screen.text" : ""
    },
    "protocolMappers" : [ {
      "id" : "e866ee0d-3c5a-41c9-adc9-d67100e7a115",
      "name" : "allowed web origins",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-allowed-origins-mapper",
      "consentRequired" : false,
      "config" : { }
    } ]
  }, {
    "id" : "5d8724ee-4737-46ff-ba2c-784dfbad892c",
    "name" : "role_list",
    "description" : "SAML role list",
    "protocol" : "saml",
    "attributes" : {
      "consent.screen.text" : "$${samlRoleListScopeConsentText}",
      "display.on.consent.screen" : "true"
    },
    "protocolMappers" : [ {
      "id" : "f85fc801-9ca6-4366-bf74-3593f6b6181b",
      "name" : "role list",
      "protocol" : "saml",
      "protocolMapper" : "saml-role-list-mapper",
      "consentRequired" : false,
      "config" : {
        "single" : "false",
        "attribute.nameformat" : "Basic",
        "attribute.name" : "Role"
      }
    } ]
  }, {
    "id" : "002a0f26-d53b-4585-8d5e-9a6b6f2c1c8b",
    "name" : "microprofile-jwt",
    "description" : "Microprofile - JWT built-in scope",
    "protocol" : "openid-connect",
    "attributes" : {
      "include.in.token.scope" : "true",
      "display.on.consent.screen" : "false"
    },
    "protocolMappers" : [ {
      "id" : "f6c7222e-99cf-49a6-a05e-98418a8c2646",
      "name" : "upn",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-property-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "username",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "upn",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "a467d1c7-cebc-4e5d-b7d7-efe15dce86c0",
      "name" : "groups",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-realm-role-mapper",
      "consentRequired" : false,
      "config" : {
        "multivalued" : "true",
        "user.attribute" : "foo",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "groups",
        "jsonType.label" : "String"
      }
    } ]
  }, {
    "id" : "02547230-8cfd-4040-9af4-9fb4e939e460",
    "name" : "email",
    "description" : "OpenID Connect built-in scope: email",
    "protocol" : "openid-connect",
    "attributes" : {
      "include.in.token.scope" : "true",
      "display.on.consent.screen" : "true",
      "consent.screen.text" : "$${emailScopeConsentText}"
    },
    "protocolMappers" : [ {
      "id" : "91b1742d-2ecd-4be1-a33d-03013755a612",
      "name" : "email",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-property-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "email",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "email",
        "jsonType.label" : "String"
      }
    }, {
      "id" : "53246f14-d780-4afc-aeec-68b9499d8885",
      "name" : "email verified",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-property-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "emailVerified",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "email_verified",
        "jsonType.label" : "boolean"
      }
    } ]
  }, {
    "id" : "b38ca411-c731-4b24-8708-b11e86fec59e",
    "name" : "phone",
    "description" : "OpenID Connect built-in scope: phone",
    "protocol" : "openid-connect",
    "attributes" : {
      "include.in.token.scope" : "true",
      "display.on.consent.screen" : "true",
      "consent.screen.text" : "$${phoneScopeConsentText}"
    },
    "protocolMappers" : [ {
      "id" : "21615819-0b57-4b72-9e06-8df5914734b5",
      "name" : "phone number verified",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "phoneNumberVerified",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "phone_number_verified",
        "jsonType.label" : "boolean"
      }
    }, {
      "id" : "2c9061c5-6e21-485f-895a-be832865b0be",
      "name" : "phone number",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-attribute-mapper",
      "consentRequired" : false,
      "config" : {
        "userinfo.token.claim" : "true",
        "user.attribute" : "phoneNumber",
        "id.token.claim" : "true",
        "access.token.claim" : "true",
        "claim.name" : "phone_number",
        "jsonType.label" : "String"
      }
    } ]
  }, {
    "id" : "2faad486-2ae1-4a22-a9df-b2d97be21415",
    "name" : "roles",
    "description" : "OpenID Connect scope for add user roles to the access token",
    "protocol" : "openid-connect",
    "attributes" : {
      "include.in.token.scope" : "false",
      "display.on.consent.screen" : "true",
      "consent.screen.text" : "$${rolesScopeConsentText}"
    },
    "protocolMappers" : [ {
      "id" : "2501b960-e7fd-4277-8eb1-1ea96f014567",
      "name" : "audience resolve",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-audience-resolve-mapper",
      "consentRequired" : false,
      "config" : { }
    }, {
      "id" : "2a587e35-2c99-45bd-8ad4-336bafc46758",
      "name" : "client roles",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-client-role-mapper",
      "consentRequired" : false,
      "config" : {
        "user.attribute" : "foo",
        "access.token.claim" : "true",
        "claim.name" : "resource_access.$${client_id}.roles",
        "jsonType.label" : "String",
        "multivalued" : "true"
      }
    }, {
      "id" : "70fcc61c-4646-458e-a8d0-26f8f9a42d4c",
      "name" : "realm roles",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-usermodel-realm-role-mapper",
      "consentRequired" : false,
      "config" : {
        "user.attribute" : "foo",
        "access.token.claim" : "true",
        "claim.name" : "realm_access.roles",
        "jsonType.label" : "String",
        "multivalued" : "true"
      }
    } ]
  }, {
    "id" : "697ab9ea-32d0-4be3-bb23-c09a43c44a46",
    "name" : "acr",
    "description" : "OpenID Connect scope for add acr (authentication context class reference) to the token",
    "protocol" : "openid-connect",
    "attributes" : {
      "include.in.token.scope" : "false",
      "display.on.consent.screen" : "false"
    },
    "protocolMappers" : [ {
      "id" : "edd55d1d-e288-4856-b69d-a1071c9e53b0",
      "name" : "acr loa level",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-acr-mapper",
      "consentRequired" : false,
      "config" : {
        "id.token.claim" : "true",
        "access.token.claim" : "true"
      }
    } ]
  }, {
    "id" : "893c2b7a-1593-407c-945a-eb1b0203845c",
    "name" : "address",
    "description" : "OpenID Connect built-in scope: address",
    "protocol" : "openid-connect",
    "attributes" : {
      "include.in.token.scope" : "true",
      "display.on.consent.screen" : "true",
      "consent.screen.text" : "$${addressScopeConsentText}"
    },
    "protocolMappers" : [ {
      "id" : "db05249a-e911-4be6-ae72-7bd13e952a59",
      "name" : "address",
      "protocol" : "openid-connect",
      "protocolMapper" : "oidc-address-mapper",
      "consentRequired" : false,
      "config" : {
        "user.attribute.formatted" : "formatted",
        "user.attribute.country" : "country",
        "user.attribute.postal_code" : "postal_code",
        "userinfo.token.claim" : "true",
        "user.attribute.street" : "street",
        "id.token.claim" : "true",
        "user.attribute.region" : "region",
        "access.token.claim" : "true",
        "user.attribute.locality" : "locality"
      }
    } ]
  } ],
  "defaultDefaultClientScopes" : [ "role_list", "profile", "email", "roles", "web-origins", "acr" ],
  "defaultOptionalClientScopes" : [ "offline_access", "address", "phone", "microprofile-jwt", "groups" ],
  "browserSecurityHeaders" : {
    "contentSecurityPolicyReportOnly" : "",
    "xContentTypeOptions" : "nosniff",
    "xRobotsTag" : "none",
    "xFrameOptions" : "SAMEORIGIN",
    "contentSecurityPolicy" : "frame-src 'self'; frame-ancestors 'self'; object-src 'none';",
    "xXSSProtection" : "1; mode=block",
    "strictTransportSecurity" : "max-age=31536000; includeSubDomains"
  },
  "smtpServer" : { },
  "eventsEnabled" : false,
  "eventsListeners" : [ "jboss-logging" ],
  "enabledEventTypes" : [ ],
  "adminEventsEnabled" : false,
  "adminEventsDetailsEnabled" : false,
  "identityProviders" : [ ],
  "identityProviderMappers" : [ ],
  "components" : {
    "org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy" : [ {
      "id" : "7f53b8f1-7104-45e3-8cc1-515e4f6b2cf2",
      "name" : "Max Clients Limit",
      "providerId" : "max-clients",
      "subType" : "anonymous",
      "subComponents" : { },
      "config" : {
        "max-clients" : [ "200" ]
      }
    }, {
      "id" : "b6354c59-3b04-42fd-8169-3e9535d90d00",
      "name" : "Trusted Hosts",
      "providerId" : "trusted-hosts",
      "subType" : "anonymous",
      "subComponents" : { },
      "config" : {
        "host-sending-registration-request-must-match" : [ "true" ],
        "client-uris-must-match" : [ "true" ]
      }
    }, {
      "id" : "6793b7b4-6d9e-4c46-b04c-57668c2f10c2",
      "name" : "Consent Required",
      "providerId" : "consent-required",
      "subType" : "anonymous",
      "subComponents" : { },
      "config" : { }
    }, {
      "id" : "38abc98b-28b9-4a79-947e-7384959a9008",
      "name" : "Allowed Client Scopes",
      "providerId" : "allowed-client-templates",
      "subType" : "anonymous",
      "subComponents" : { },
      "config" : {
        "allow-default-scopes" : [ "true" ]
      }
    }, {
      "id" : "c7b5cc7e-7e48-493c-8c57-d9b98e2e6305",
      "name" : "Allowed Client Scopes",
      "providerId" : "allowed-client-templates",
      "subType" : "authenticated",
      "subComponents" : { },
      "config" : {
        "allow-default-scopes" : [ "true" ]
      }
    }, {
      "id" : "186a4a6d-cee4-424f-8e24-3f9c15455be1",
      "name" : "Full Scope Disabled",
      "providerId" : "scope",
      "subType" : "anonymous",
      "subComponents" : { },
      "config" : { }
    }, {
      "id" : "3005f6c4-212e-4a71-827b-77271803fbc3",
      "name" : "Allowed Protocol Mapper Types",
      "providerId" : "allowed-protocol-mappers",
      "subType" : "anonymous",
      "subComponents" : { },
      "config" : {
        "allowed-protocol-mapper-types" : [ "oidc-usermodel-property-mapper", "saml-user-property-mapper", "oidc-full-name-mapper", "oidc-sha256-pairwise-sub-mapper", "saml-user-attribute-mapper", "oidc-usermodel-attribute-mapper", "saml-role-list-mapper", "oidc-address-mapper" ]
      }
    }, {
      "id" : "ebb2b238-ef68-4ee9-8fdb-031d1073aace",
      "name" : "Allowed Protocol Mapper Types",
      "providerId" : "allowed-protocol-mappers",
      "subType" : "authenticated",
      "subComponents" : { },
      "config" : {
        "allowed-protocol-mapper-types" : [ "saml-user-attribute-mapper", "oidc-full-name-mapper", "oidc-usermodel-attribute-mapper", "saml-user-property-mapper", "oidc-sha256-pairwise-sub-mapper", "oidc-address-mapper", "oidc-usermodel-property-mapper", "saml-role-list-mapper" ]
      }
    } ],
    "org.keycloak.keys.KeyProvider" : [ {
      "id" : "27ea8ce2-3624-4895-882e-613c200ecb12",
      "name" : "hmac-generated",
      "providerId" : "hmac-generated",
      "subComponents" : { },
      "config" : {
        "kid" : [ "e325f6f4-92da-40ef-b078-c166172408ce" ],
        "secret" : [ "QI2kt1gPjwZ-fVoGIA5haX1I_d5B4aEx0gCXfg5PZ8X9zIdqfUycc_n3wsKGCYfYn0quUNmA-G14umIbpkYCDQ" ],
        "priority" : [ "100" ],
        "algorithm" : [ "HS256" ]
      }
    }, {
      "id" : "997b10fd-5214-4b0d-b6ca-883bd357f727",
      "name" : "aes-generated",
      "providerId" : "aes-generated",
      "subComponents" : { },
      "config" : {
        "kid" : [ "c0fab59f-b377-4e4a-8a53-4014021db296" ],
        "secret" : [ "g-FTjT9DM8zPsiXNKveFmQ" ],
        "priority" : [ "100" ]
      }
    }, {
      "id" : "7ac58c6e-4841-45b2-bb37-dcc19ace9ed1",
      "name" : "rsa-generated",
      "providerId" : "rsa-generated",
      "subComponents" : { },
      "config" : {
        "privateKey" : [ "MIIEowIBAAKCAQEAsjLr7i3JDdfCERlo6jOK0N9krdsRidkvOol1vTlerLTHmFdW8UVrTBvCzfUmDYxBIJRhX7QIXVjxmM/QC5AtWcpTdwZ5FAqmDgrf7iVeWa5k8FCjeJ2w6BYcPCCQd4hC6vKZZazlS467HsRLIzNjoQgWIUjt2G1M2ZhfrMwsXBVnLzECUuRiPEvoDRtGwOCvW1tEJRbR7g5R35sgJeM5e0CDb7ezg61bzHM90povOQd87WPg3O9Qa56YeAWwi6ntnZw4GPuzx+uTDkN/3P3WgFUNSMuxO/msCZVinBnNykN7hBN4W/luLKW8Utz8EBc+LqcNFTgEa4be8zLjFfB0TQIDAQABAoIBAAD85erBViIMGpF0Vez4Rhawnlo4kUZHIlyqfLEEz+awBg8P6xKy4yPMpZlpsrtxfr5jigMzT4gD24h5YnS9OjJoXvaJu1SO+gI8YAQQ08lNlMpO/q4YosqoxRVkbnWwRdThJ4LSSbDEUHr53bJoCHrz1JHCNuEoI8gQH4F6aY9FTI3wxeGoCGHCMFWcIn8kDNQ3jVA8U9a2HZkoKJRMf1Tjdqz4Ngm/ZE9Kju4X2VudIompDy1X6sVIpi0ev3niP0O8tsvKl6MCPP2mWCII9nbxpA2S15DpOFpQwWRdWBO2NESoK69sqIlHcTfirGM30Z32FptPyvBK1FubsJ5rQlsCgYEA2Uz6P/Ynp+z2hqvb23vU5X6Bia1e+2SD2X5u2PGBnMnvTK+x0qU7cwfJiCyURTZcpFaA3QQfAoRb0oc6DckZKcRr1q8oXhnHeVSaEPRa8vtngygHBDPGy7OJcAGnZAht6V8/3VVrgQmWY3cSxVSoheTJZrSZgVn7crb9CRRH878CgYEA0e8+J69FE36vaONeBtwfDwPhZMg7vbhds3ixWSudmtG+7b3DxGSgsZ11H67DI13jZZfHfUUIuKvflBuCm69iMBUISkDYIB9Ju9V7d0n/g5jWzUSNrnSCDk2ko6I5OFzYDRnqhU7Cet9+93RiN/Yvxdz8abkF+nDtYwXjoscJavMCgYBxF3r2Zunkn5L+K9tUs3HtrpVEThKsy3dDbmXKSoamTwJX6uilNJFoIJlmYa0ZCF3WuZ5/aHGrIa+YNgCkxBBwiGWHacmcj9Yc80brpADhjK4muGJOcZP42AujW3j+utRZLNVUH+y/T3oRchs20ASVCqk25q8tfuM6pLm0S/XWiQKBgQDDTuupafM+xs6UK2tvwFwY0QhhhbOmtp5d+PwttFklDtutPK2jyeaCN7Yeaq1a+t8yxfku/wm1HRmdJdbl1k3n47lZs2gewl0Lpfn+qdZQbOHyCEQzuGrCudNg9Ox9FkteLO01ZmeifskVmK5D2ALr9sLR7PO14lfHl1QHPVrypwKBgHO5YM6qcbkJ8iDy07zQhrqKaezyMOiYrpCmxI6a1I73GeZOlbDGHcyr1t2rwETbV2AqgUNjYmds6JNOY84sfy8jA0ZG0WvijmyU0mW2Tvt9ME+gwAoJvsqctQjN6U0qtZ2U59bsEopbq4BxjLNCxlUqUFcrIvGAaxUqQQ4HDki/" ],
        "keyUse" : [ "SIG" ],
        "certificate" : [ "MIICmTCCAYECBgGJAbphmjANBgkqhkiG9w0BAQsFADAQMQ4wDAYDVQQDDAVub21hZDAeFw0yMzA2MjgxMTE3MTlaFw0zMzA2MjgxMTE4NTlaMBAxDjAMBgNVBAMMBW5vbWFkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsjLr7i3JDdfCERlo6jOK0N9krdsRidkvOol1vTlerLTHmFdW8UVrTBvCzfUmDYxBIJRhX7QIXVjxmM/QC5AtWcpTdwZ5FAqmDgrf7iVeWa5k8FCjeJ2w6BYcPCCQd4hC6vKZZazlS467HsRLIzNjoQgWIUjt2G1M2ZhfrMwsXBVnLzECUuRiPEvoDRtGwOCvW1tEJRbR7g5R35sgJeM5e0CDb7ezg61bzHM90povOQd87WPg3O9Qa56YeAWwi6ntnZw4GPuzx+uTDkN/3P3WgFUNSMuxO/msCZVinBnNykN7hBN4W/luLKW8Utz8EBc+LqcNFTgEa4be8zLjFfB0TQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQB7lotR7CxSvyAinZ22ycqHaDuN3dQyO0pQo9g/YaIS8Aux+xA572POIxWhDb2G19/v+UyAA4mMYOclq8AdpMBOK1fJ1zWBKP1niKJ9brqezX9tqJKPrAt7R1tBnBaOt0dU8kTGXJ6h1kguAnTXwVLs1j46Ictx+URo0yjcZe45HjrJkl5GhbVolOrx6wg3adYpO7H+QfRuP+xzmjgtVT3PbjHUhA1jrhKg3NSgiF0WqmtdZJl5jBhiOObAjka2mPae1jorIpmc4tUigusa4B63zl39csH7aAeaVAq3sPp0paluze9mGs2RfwFeE3sqCpx319v17cow0fTwpaplyDnx" ],
        "priority" : [ "100" ]
      }
    }, {
      "id" : "32383bf1-4af4-45ee-88dc-36041f4baf23",
      "name" : "rsa-enc-generated",
      "providerId" : "rsa-enc-generated",
      "subComponents" : { },
      "config" : {
        "privateKey" : [ "MIIEowIBAAKCAQEAxMMjSejhn+7W3fKbzGwNvRJKTPXpE7y/lDXWT/EqaPeNJLSSuUOdI87Pw7XdRrJx+LOLv2XCS1CylG+3KFI8HL4QEtA9yYnZXK9Hxiu4ipAv2AUVgTW2bRVwYQZ0qTxf7ot+untA5uSZEqgCD4oWtOxTy2ZypDuJkoQzTI1PDJVCQQnRP0EzRyC1cSj3FQ94LrY5wq69CSfhZkDPaXj+3EXOIcGiPvbWnMXkbN9AvTY24BUdn5PVLB5UqxhFlHPN3UJb86RuDpQzSc5wQPPNDIpU4wzyu9rfjL/OvTrGFa0TP/8Ml3598pdsIvxTatOz1RXzfSB94rVPPzzUWQaiAQIDAQABAoIBAEY4L9VWJ4M4rPTbeq97FnIV329UyV/yWdqOVhQEiLKaOgRR7xTv5NodGfeJ5VSwJU1w4hwluC/BtmGT9uUMaAiH6duU9qAAspJJuY8nFj5ZE8H/mnuYzChk4My3jZXCBqhunwT1LKXaCijmzYl3KgBaYNMzlhE3cDLaPCaDPaVK1CCsY50x8FnWjyCiLbSsx/crvGkOVqrpbEVgozHo1SVs7FYxuwcyMQI5tmaTjop/YzAiYtaVtkM3LrYYjt2jlGjfm6yUjOZmFggeWrgcNFWYa8b/dyshnu5EbOvprTinq70pUYNbG6T7Ncgt80n94zuxkW4g4WMxcW3m1cvtRJsCgYEA+RLVPKwKIMH50eOcifOTObexYSSVlucwnhJsX8kEWQKuYjZtTuquMjNI1rfuJk3nTbpUyhTTDyY/vCtKTJxUNxRNKMcTesdi4vc3h88pvicrtPHno/ps3pRcUIJle9H1iWo0fQm2ZKI6OHM9E0PIJklKf60O2D8syMedqmjQsfsCgYEAyjvl6Vu+FGkh3YDeyEl1aC81XIZQ+WrYiAeGIBRYynL1tCL/ax7EwGf989Ko0UvJBdGwSpmNBOfpglvbP/nw4kFMaHXfH6bjxVE+kt3513Kwt8FBnGsuWtAEfp1bxAIcSbOV9cLv99HOx+8rJCeJJpBgq/YXItPl5+gAlSAO9zMCgYB9YeSkMTq7+MnoxbrEmzAu6vDJJSCEoYcQ29dgdJHSuQ3N9PYbtvnP3Y86P8cL00WwFC+gttD0nF2TPPufC0c9nuOktmpw8TQvayGyJTAvQAq5gNkJ7AOoHGlIQgwSQ8Rl02fu1dfSWvQR/LjvHL0BwP1WvmhtpYfG3u3YngEIxwKBgQCYX6csO46tTEVS4r15BTgsBp3bF+y88I8zdw/M7ee0qgeM8W2nZWhzXCdQ5eGCyOousz50Btvk3WPob5Nz0bt4jiCm+GDkNVeanUtbV1rexTB3U2o/E9a6X89zItc4iSqNMX2EzZsHCxMVO5QyyoMhBlmAV4w5FpU8NWby9VOxVwKBgCLEIAHMo+g45hS7+09nME1Jw+E5uNdsq9Okb6l/XEIG/hg3kHedEQXOASAa2faUlDHOWrIpQ7JF6SUFNx9keydVjwT0uotCUESjKScEB3SHLVvSgajcDwg9/F8MmH1rSSelMGU06jCaTadAXTJkGj3nnXhKokUbG3lK+bdxpOo4" ],
        "keyUse" : [ "ENC" ],
        "certificate" : [ "MIICmTCCAYECBgGJAbpirTANBgkqhkiG9w0BAQsFADAQMQ4wDAYDVQQDDAVub21hZDAeFw0yMzA2MjgxMTE3MTlaFw0zMzA2MjgxMTE4NTlaMBAxDjAMBgNVBAMMBW5vbWFkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxMMjSejhn+7W3fKbzGwNvRJKTPXpE7y/lDXWT/EqaPeNJLSSuUOdI87Pw7XdRrJx+LOLv2XCS1CylG+3KFI8HL4QEtA9yYnZXK9Hxiu4ipAv2AUVgTW2bRVwYQZ0qTxf7ot+untA5uSZEqgCD4oWtOxTy2ZypDuJkoQzTI1PDJVCQQnRP0EzRyC1cSj3FQ94LrY5wq69CSfhZkDPaXj+3EXOIcGiPvbWnMXkbN9AvTY24BUdn5PVLB5UqxhFlHPN3UJb86RuDpQzSc5wQPPNDIpU4wzyu9rfjL/OvTrGFa0TP/8Ml3598pdsIvxTatOz1RXzfSB94rVPPzzUWQaiAQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQCzG8IjBQWkseSNcruDNOJ6fvIANvg48MbPy70PQAPEBz2Ymt4sqNz3Pfpw5X6wuIKI+0sVTOC2h+igpdUIzQrRZUjxtvUzuEfMlYxx2l9CTe63BfcP+GwbwlQsQndS1Qf0s48oddEBm1de3BBlKjJ4et3v1x3z0pd49MzUX+/jqYn2kgVrJ8483axbwB+TS4K3jpubsfJyxpR0MayF8eqFIE7L+/yhaw0MH9d04tUhaSmzYjZJrmncuItVt5+YTpXRm8j2HplPrKRZvGI0aIaFdesTA2hdE9bUrJ49nL7nm3jCPlRTZC8brjd4cbPsVt44vNP2wUizdb5iN2msK5O0" ],
        "priority" : [ "100" ],
        "algorithm" : [ "RSA-OAEP" ]
      }
    } ]
  },
  "internationalizationEnabled" : false,
  "supportedLocales" : [ ],
  "authenticationFlows" : [ {
    "id" : "bc3ab38c-890c-4a6d-aae5-6b76236e8781",
    "alias" : "Account verification options",
    "description" : "Method with which to verity the existing account",
    "providerId" : "basic-flow",
    "topLevel" : false,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "idp-email-verification",
      "authenticatorFlow" : false,
      "requirement" : "ALTERNATIVE",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticatorFlow" : true,
      "requirement" : "ALTERNATIVE",
      "priority" : 20,
      "autheticatorFlow" : true,
      "flowAlias" : "Verify Existing Account by Re-authentication",
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "2200d614-2d38-45fd-876d-af1799eabf66",
    "alias" : "Authentication Options",
    "description" : "Authentication options.",
    "providerId" : "basic-flow",
    "topLevel" : false,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "basic-auth",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "basic-auth-otp",
      "authenticatorFlow" : false,
      "requirement" : "DISABLED",
      "priority" : 20,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "auth-spnego",
      "authenticatorFlow" : false,
      "requirement" : "DISABLED",
      "priority" : 30,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "00dceb20-d2d6-4520-8191-b98bda543ced",
    "alias" : "Browser - Conditional OTP",
    "description" : "Flow to determine if the OTP is required for the authentication",
    "providerId" : "basic-flow",
    "topLevel" : false,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "conditional-user-configured",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "auth-otp-form",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 20,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "d0ce21b2-7fb0-4ad9-932c-54d654df3628",
    "alias" : "Direct Grant - Conditional OTP",
    "description" : "Flow to determine if the OTP is required for the authentication",
    "providerId" : "basic-flow",
    "topLevel" : false,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "conditional-user-configured",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "direct-grant-validate-otp",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 20,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "0a13dbf4-c688-4697-b907-aa30f134a3ca",
    "alias" : "First broker login - Conditional OTP",
    "description" : "Flow to determine if the OTP is required for the authentication",
    "providerId" : "basic-flow",
    "topLevel" : false,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "conditional-user-configured",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "auth-otp-form",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 20,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "5c63d43b-3e67-44fa-880b-6084ffb89ada",
    "alias" : "Handle Existing Account",
    "description" : "Handle what to do if there is existing account with same email/username like authenticated identity provider",
    "providerId" : "basic-flow",
    "topLevel" : false,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "idp-confirm-link",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticatorFlow" : true,
      "requirement" : "REQUIRED",
      "priority" : 20,
      "autheticatorFlow" : true,
      "flowAlias" : "Account verification options",
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "5a5fee82-120a-4671-9086-3cb4f6ef1530",
    "alias" : "Reset - Conditional OTP",
    "description" : "Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.",
    "providerId" : "basic-flow",
    "topLevel" : false,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "conditional-user-configured",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "reset-otp",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 20,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "6b00f4eb-128c-4e4f-9411-d4a7e001097e",
    "alias" : "User creation or linking",
    "description" : "Flow for the existing/non-existing user alternatives",
    "providerId" : "basic-flow",
    "topLevel" : false,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticatorConfig" : "create unique user config",
      "authenticator" : "idp-create-user-if-unique",
      "authenticatorFlow" : false,
      "requirement" : "ALTERNATIVE",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticatorFlow" : true,
      "requirement" : "ALTERNATIVE",
      "priority" : 20,
      "autheticatorFlow" : true,
      "flowAlias" : "Handle Existing Account",
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "3a8dbdb3-bcdf-4dbe-b8db-251a8db992a6",
    "alias" : "Verify Existing Account by Re-authentication",
    "description" : "Reauthentication of existing account",
    "providerId" : "basic-flow",
    "topLevel" : false,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "idp-username-password-form",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticatorFlow" : true,
      "requirement" : "CONDITIONAL",
      "priority" : 20,
      "autheticatorFlow" : true,
      "flowAlias" : "First broker login - Conditional OTP",
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "cb3356b1-3836-4bda-bcb2-7ae9c14c697f",
    "alias" : "browser",
    "description" : "browser based authentication",
    "providerId" : "basic-flow",
    "topLevel" : true,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "auth-cookie",
      "authenticatorFlow" : false,
      "requirement" : "ALTERNATIVE",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "auth-spnego",
      "authenticatorFlow" : false,
      "requirement" : "DISABLED",
      "priority" : 20,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "identity-provider-redirector",
      "authenticatorFlow" : false,
      "requirement" : "ALTERNATIVE",
      "priority" : 25,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticatorFlow" : true,
      "requirement" : "ALTERNATIVE",
      "priority" : 30,
      "autheticatorFlow" : true,
      "flowAlias" : "forms",
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "855c1a71-9fa9-4f61-a0ce-163daee7e72b",
    "alias" : "clients",
    "description" : "Base authentication for clients",
    "providerId" : "client-flow",
    "topLevel" : true,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "client-secret",
      "authenticatorFlow" : false,
      "requirement" : "ALTERNATIVE",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "client-jwt",
      "authenticatorFlow" : false,
      "requirement" : "ALTERNATIVE",
      "priority" : 20,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "client-secret-jwt",
      "authenticatorFlow" : false,
      "requirement" : "ALTERNATIVE",
      "priority" : 30,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "client-x509",
      "authenticatorFlow" : false,
      "requirement" : "ALTERNATIVE",
      "priority" : 40,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "427bd95e-d08f-4296-9ddc-fc2cd4343099",
    "alias" : "direct grant",
    "description" : "OpenID Connect Resource Owner Grant",
    "providerId" : "basic-flow",
    "topLevel" : true,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "direct-grant-validate-username",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "direct-grant-validate-password",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 20,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticatorFlow" : true,
      "requirement" : "CONDITIONAL",
      "priority" : 30,
      "autheticatorFlow" : true,
      "flowAlias" : "Direct Grant - Conditional OTP",
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "ad138746-691e-4c13-8e77-569fe4194e74",
    "alias" : "docker auth",
    "description" : "Used by Docker clients to authenticate against the IDP",
    "providerId" : "basic-flow",
    "topLevel" : true,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "docker-http-basic-authenticator",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "0c3826e7-610f-4fec-bc47-dff33c31c412",
    "alias" : "first broker login",
    "description" : "Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account",
    "providerId" : "basic-flow",
    "topLevel" : true,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticatorConfig" : "review profile config",
      "authenticator" : "idp-review-profile",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticatorFlow" : true,
      "requirement" : "REQUIRED",
      "priority" : 20,
      "autheticatorFlow" : true,
      "flowAlias" : "User creation or linking",
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "8bfb56f0-0ca0-4eb3-89eb-6d7f38c7ed90",
    "alias" : "forms",
    "description" : "Username, password, otp and other auth forms.",
    "providerId" : "basic-flow",
    "topLevel" : false,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "auth-username-password-form",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticatorFlow" : true,
      "requirement" : "CONDITIONAL",
      "priority" : 20,
      "autheticatorFlow" : true,
      "flowAlias" : "Browser - Conditional OTP",
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "271eb68e-6b8c-4b8e-8a4b-9ef3b51f9360",
    "alias" : "http challenge",
    "description" : "An authentication flow based on challenge-response HTTP Authentication Schemes",
    "providerId" : "basic-flow",
    "topLevel" : true,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "no-cookie-redirect",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticatorFlow" : true,
      "requirement" : "REQUIRED",
      "priority" : 20,
      "autheticatorFlow" : true,
      "flowAlias" : "Authentication Options",
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "2a526d6f-0d48-42c2-9f86-7015d6a5a66d",
    "alias" : "registration",
    "description" : "registration flow",
    "providerId" : "basic-flow",
    "topLevel" : true,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "registration-page-form",
      "authenticatorFlow" : true,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : true,
      "flowAlias" : "registration form",
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "1ae3ef32-0e0c-4269-a809-8402439da2aa",
    "alias" : "registration form",
    "description" : "registration form",
    "providerId" : "form-flow",
    "topLevel" : false,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "registration-user-creation",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 20,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "registration-profile-action",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 40,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "registration-password-action",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 50,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "registration-recaptcha-action",
      "authenticatorFlow" : false,
      "requirement" : "DISABLED",
      "priority" : 60,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "ab8dca50-bc9d-4cb3-8b4f-6288784002a5",
    "alias" : "reset credentials",
    "description" : "Reset credentials for a user if they forgot their password or something",
    "providerId" : "basic-flow",
    "topLevel" : true,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "reset-credentials-choose-user",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "reset-credential-email",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 20,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticator" : "reset-password",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 30,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    }, {
      "authenticatorFlow" : true,
      "requirement" : "CONDITIONAL",
      "priority" : 40,
      "autheticatorFlow" : true,
      "flowAlias" : "Reset - Conditional OTP",
      "userSetupAllowed" : false
    } ]
  }, {
    "id" : "4ad72733-4a10-4c5f-ae03-fb88dcd0b067",
    "alias" : "saml ecp",
    "description" : "SAML ECP Profile Authentication Flow",
    "providerId" : "basic-flow",
    "topLevel" : true,
    "builtIn" : true,
    "authenticationExecutions" : [ {
      "authenticator" : "http-basic-authenticator",
      "authenticatorFlow" : false,
      "requirement" : "REQUIRED",
      "priority" : 10,
      "autheticatorFlow" : false,
      "userSetupAllowed" : false
    } ]
  } ],
  "authenticatorConfig" : [ {
    "id" : "edc05fbe-bfda-4aea-a433-acab64332bf8",
    "alias" : "create unique user config",
    "config" : {
      "require.password.update.after.registration" : "false"
    }
  }, {
    "id" : "bf5c93b3-137f-4fce-97f9-8f929dc57dd3",
    "alias" : "review profile config",
    "config" : {
      "update.profile.on.first.login" : "missing"
    }
  } ],
  "requiredActions" : [ {
    "alias" : "CONFIGURE_TOTP",
    "name" : "Configure OTP",
    "providerId" : "CONFIGURE_TOTP",
    "enabled" : true,
    "defaultAction" : false,
    "priority" : 10,
    "config" : { }
  }, {
    "alias" : "TERMS_AND_CONDITIONS",
    "name" : "Terms and Conditions",
    "providerId" : "TERMS_AND_CONDITIONS",
    "enabled" : false,
    "defaultAction" : false,
    "priority" : 20,
    "config" : { }
  }, {
    "alias" : "UPDATE_PASSWORD",
    "name" : "Update Password",
    "providerId" : "UPDATE_PASSWORD",
    "enabled" : true,
    "defaultAction" : false,
    "priority" : 30,
    "config" : { }
  }, {
    "alias" : "UPDATE_PROFILE",
    "name" : "Update Profile",
    "providerId" : "UPDATE_PROFILE",
    "enabled" : true,
    "defaultAction" : false,
    "priority" : 40,
    "config" : { }
  }, {
    "alias" : "VERIFY_EMAIL",
    "name" : "Verify Email",
    "providerId" : "VERIFY_EMAIL",
    "enabled" : true,
    "defaultAction" : false,
    "priority" : 50,
    "config" : { }
  }, {
    "alias" : "delete_account",
    "name" : "Delete Account",
    "providerId" : "delete_account",
    "enabled" : false,
    "defaultAction" : false,
    "priority" : 60,
    "config" : { }
  }, {
    "alias" : "webauthn-register",
    "name" : "Webauthn Register",
    "providerId" : "webauthn-register",
    "enabled" : true,
    "defaultAction" : false,
    "priority" : 70,
    "config" : { }
  }, {
    "alias" : "webauthn-register-passwordless",
    "name" : "Webauthn Register Passwordless",
    "providerId" : "webauthn-register-passwordless",
    "enabled" : true,
    "defaultAction" : false,
    "priority" : 80,
    "config" : { }
  }, {
    "alias" : "update_user_locale",
    "name" : "Update User Locale",
    "providerId" : "update_user_locale",
    "enabled" : true,
    "defaultAction" : false,
    "priority" : 1000,
    "config" : { }
  } ],
  "browserFlow" : "browser",
  "registrationFlow" : "registration",
  "directGrantFlow" : "direct grant",
  "resetCredentialsFlow" : "reset credentials",
  "clientAuthenticationFlow" : "clients",
  "dockerAuthenticationFlow" : "docker auth",
  "attributes" : {
    "cibaBackchannelTokenDeliveryMode" : "poll",
    "cibaExpiresIn" : "120",
    "cibaAuthRequestedUserHint" : "login_hint",
    "oauth2DeviceCodeLifespan" : "600",
    "oauth2DevicePollingInterval" : "5",
    "parRequestUriLifespan" : "60",
    "cibaInterval" : "5",
    "realmReusableOtpCode" : "false"
  },
  "keycloakVersion" : "21.1.1",
  "userManagedAccessAllowed" : false,
  "clientProfiles" : {
    "profiles" : [ ]
  },
  "clientPolicies" : {
    "policies" : [ ]
  }
}