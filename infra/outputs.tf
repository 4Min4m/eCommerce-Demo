output "sns_topic_arn" {
  value = aws_sns_topic.order_events.arn
}