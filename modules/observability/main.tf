resource "aws_sns_topic" "alarms" {
  count = var.alarm_email == null ? 0 : 1
  name  = "${var.name}-alarms"
  tags  = var.tags
}
resource "aws_sns_topic_subscription" "email" {
  count     = var.alarm_email == null ? 0 : 1
  topic_arn = aws_sns_topic.alarms[0].arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

resource "aws_cloudwatch_metric_alarm" "api_5xx" {
  alarm_name          = "${var.name}-api-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "4xx"
  namespace           = "AWS/ApiGateway"
  period              = 60
  statistic           = "Sum"
  threshold           = 50
  dimensions = {
    ApiId = var.api_id
  }
  alarm_description  = "High client errors on API (tune as needed)."
  treat_missing_data = "notBreaching"
  alarm_actions      = var.alarm_email == null ? [] : [aws_sns_topic.alarms[0].arn]
  tags               = var.tags
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.name}-lambda-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"
  alarm_description   = "Lambda errors detected."
  alarm_actions       = var.alarm_email == null ? [] : [aws_sns_topic.alarms[0].arn]
  tags                = var.tags
}