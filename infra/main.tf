resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "ecommerce-tfstate-${random_string.suffix.result}"
}

resource "aws_sns_topic" "order_events" {
  name = "order-events"
}

resource "aws_sqs_queue" "order_processing_queue" {
  name = "order-processing-queue"
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.order_events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.order_processing_queue.arn
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.order_processing_queue.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.order_processing_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.order_events.arn
          }
        }
      }
    ]
  })
}