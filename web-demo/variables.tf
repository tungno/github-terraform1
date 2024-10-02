variable "rg_name" {
  type        = string
  description = "value"
}

variable "rg_location" {
  type        = string
  description = "Name of the location for the backen"
}

# 2. storage account variable
variable "sa_name" {
  type        = string
  description = "Name of the storage account for the backend"
}

variable "source_content" {
  type        = string
  description = "value"
}

variable "index_document" {
  type        = string
  description = "value"
}