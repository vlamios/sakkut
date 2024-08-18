variable "prefered_zones" {
    description = "Availability zones for instances"
    type      = list(string)
    default   = ["ru-central1-a","ru-central1-b","ru-central1-d"]
}

variable "cloud" {
  type        = string
  default     = "" 
}

variable "folder" {
  type        = string
  default     = ""
}

variable "labels" {
  description   = "Project labels"
  type          = map(any)
  default = {
    project       = "unknown"
    environment   = "sandbox"
    created       = "terraform"
  }
}

variable "project_domain_zone" {
  type        = string
  default     = ""
}

variable "project_domain_name" {
  type        = string
  default     = ""
}

variable "outer_server_ip" {
  type        = string
  default     = ""
}

