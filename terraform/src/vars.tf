variable "lambdaVersion" {
  type        = string
  description = "version of the lambda zip on S3"
}

variable "contact_email_to" {
  type = object({
    clarity_software_solutions = string
    jake_russell_photography = string
  })
}
