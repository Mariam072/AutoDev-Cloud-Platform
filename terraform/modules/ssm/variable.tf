variable "env" {
  type        = string
  description = "Environment name (prod, nonprod)"
}

variable "mongo_uri" {
  type        = string
  description = "MongoDB URI"
}
