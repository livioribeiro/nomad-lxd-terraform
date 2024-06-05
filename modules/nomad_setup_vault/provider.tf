# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.2"
    }
  }
}