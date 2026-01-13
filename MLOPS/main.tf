# This script defines the necessary security resources (IAM Roles and Security Group)
# for the fraud-detector ECS service running on Fargate.

# --- 1. IAM ROLE: ECS Task Execution Role ---
# This role grants ECS permission to pull the container image from the registry (GHCR/ECR) 
# and send logs to CloudWatch.
resource "aws_iam_role" "fraud_detector_execution_role" {
  name = "fraud-detector-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AWS managed policy for standard ECS execution tasks
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.fraud_detector_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# --- 2. IAM ROLE: ECS Task Role (Least Privilege) ---
# This role grants the application *inside* the container permissions it needs, 
# such as reading from S3, accessing DynamoDB, or communicating with other services.
# Security Note: It is currently empty (least privilege by default). Add permissions here.
resource "aws_iam_role" "fraud_detector_task_role" {
  name = "fraud-detector-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# --- 3. ECS Service Security Group (Least Privilege Networking) ---
# This controls the traffic allowed IN (ingress) and OUT (egress) for the fraud detector.
resource "aws_security_group" "fraud_detector_sg" {
  name        = "fraud-detector-service-sg"
  description = "Security Group for the Fraud Detection ECS Service"
  vpc_id      = var.vpc_id # Assume VPC ID is passed via a variable

  # Ingress Rule: Only allow traffic on port 8080 (your container port)
  # and only from the load balancer's security group (or the VPC CIDR).
  # This secures the service by preventing direct external access.
  ingress {
    description = "Allow inbound traffic from Load Balancer"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    # Replace this with the Security Group ID of your Application Load Balancer (ALB)
    security_groups = [var.alb_security_group_id] 
  }

  # Egress Rule: Full internet access (required for outbound API calls, updates, etc.)
  # Secure design might restrict this further, e.g., only to specific external services.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Terraform Output (Used to update your Task Definition JSON) ---
output "task_execution_role_arn" {
  value = aws_iam_role.fraud_detector_execution_role.arn
}

output "task_role_arn" {
  value = aws_iam_role.fraud_detector_task_role.arn
}

output "service_security_group_id" {
  value = aws_security_group.fraud_detector_sg.id
}
