locals {
  name = "fdev-weu-p-hub-01"

  subnets = {
    "GatewaySubnet" = {
    address_prefixes = ["10.255.255.0/27"] },
    "ApplicationGatewaySubnet" = {
    address_prefixes = ["10.255.255.32/27"] },
    "FirewallFrontendSubnet" = {
    address_prefixes = ["10.255.255.64/27"] },
    "FirewallBackendSubnet" = {
    address_prefixes = ["10.255.255.96/27"] },
    "CitrixMGT" = {
    address_prefixes = ["10.255.255.128/28"] },
    "CitrixLAN" = {
    address_prefixes = ["10.255.255.144/28"] },
    "CitrixWAN" = {
    address_prefixes = ["10.255.255.160/28"] },
    "CitrixAUX" = {
    address_prefixes = ["10.255.255.176/28"] },
    "RouteServerSubnet" = {
    address_prefixes = ["10.255.255.192/27"] },
  }
}
