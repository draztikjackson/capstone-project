resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  alarm_name          = "capstone-ec2-high-cpu"
  alarm_description   = "Alert when capstone EC2 CPU usage exceeds 80%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  alarm_actions = [aws_sns_topic.capstone_alerts.arn]

  dimensions = {
    InstanceId = aws_instance.web.id
  }

  treat_missing_data = "notBreaching"

  tags = {
    Name = "capstone-ec2-high-cpu"
  }
}

resource "aws_sns_topic" "capstone_alerts" {
  name = "capstone-monitoring-alerts"

  tags = {
    Name = "capstone-monitoring-alerts"
  }
}

variable "alert_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.capstone_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}


