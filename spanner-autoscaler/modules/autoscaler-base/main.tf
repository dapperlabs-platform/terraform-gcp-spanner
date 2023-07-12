/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "random_id" "suffix" {
  byte_length = 4
}

// Service Accounts

resource "google_service_account" "poller_sa" {
  account_id   = "poller-sa-${random_id.suffix.hex}"
  display_name = "Autoscaler - Metrics Poller Service Account"
}

resource "google_service_account" "scaler_sa" {
  account_id   = "scaler-sa-${random_id.suffix.hex}"
  display_name = "Autoscaler - Scaler Function Service Account"
}