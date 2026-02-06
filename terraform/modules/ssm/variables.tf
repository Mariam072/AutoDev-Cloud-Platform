variable "parameters" {
  type = map(object({
    name  = string
    type  = string
    value = string
  }))
}

variable "tags" {
  type = map(string)
}
