# Climbing Map - AWS Infrastructure as Code

Terraform을 사용한 클라이밍 지도 웹앱 인프라 구성 레포지토리입니다.

## 프로젝트 개요

이 프로젝트는 클라이밍 지도 웹 애플리케이션을 위한 AWS 인프라를 Terraform으로 관리합니다.
모듈 기반 구조로 VPC 네트워크와 컴퓨팅 리소스를 체계적으로 구성합니다.

## 인프라 아키텍처

### 네트워크 구성 (VPC 모듈)
- **VPC**: climbingMap-vpc (192.168.0.0/20)
- **퍼블릭 서브넷 1**: 192.168.0.0/24 (ap-northeast-2a)
- **퍼블릭 서브넷 2**: 192.168.1.0/24 (ap-northeast-2c)
- **Internet Gateway**: 인터넷 연결
- **라우팅 테이블**: 퍼블릭 서브넷용 라우팅 설정

### 컴퓨팅 리소스 (Compute 모듈)
- **EC2 인스턴스**: DEV_SERVER
  - 인스턴스 타입: t2.micro
  - AMI: ami-00e73adb2e2c80366
  - 키 페어: climbingMap_dev_ssh_key
  - 루트 볼륨: gp2 (삭제 방지 설정)

- **보안 그룹 (WEB-SG)**:
  - HTTP (80): 0.0.0.0/0
  - HTTPS (443): 0.0.0.0/0
  - SSH (22): 0.0.0.0/0
  - Vite Dev Server (5173): 0.0.0.0/0
  - Custom (8080): 0.0.0.0/0
  - Egress: 전체 허용

## 프로젝트 구조

```
.
├── provider.tf              # AWS 프로바이더 설정 (ap-northeast-2)
├── main.tf                  # 메인 Terraform 설정 파일
├── .gitignore              # Git 제외 파일 설정
└── modules/
    ├── VPC/
    │   ├── vpc.tf          # VPC, 서브넷, IGW, 라우팅 테이블 리소스
    │   ├── variables.tf    # VPC 모듈 변수 정의
    │   └── outputs.tf      # VPC ID, 서브넷 ID 출력
    └── Compute/
        ├── ec2.tf          # EC2 인스턴스 및 보안 그룹 리소스
        ├── variables.tf    # Compute 모듈 변수 정의
        └── outputs.tf      # 인스턴스 ID, IP 주소 출력
```

## 사용 방법

### 1. 사전 요구사항

- Terraform 1.14 이상
- AWS CLI 설정 완료
- AWS 자격 증명 구성
- SSH 키 페어 생성 (climbingMap_dev_ssh_key)

### 2. Terraform 초기화

```bash
terraform init
```

### 3. 인프라 계획 확인

```bash
terraform plan
```

### 4. 인프라 배포

```bash
terraform apply
```

### 5. 인프라 삭제

```bash
terraform destroy
```

## 출력값

Terraform apply 후 다음 정보가 출력됩니다:

- `vpc_id`: VPC ID
- `public_subnet_1_id`: 퍼블릭 서브넷 1 ID
- `public_subnet_2_id`: 퍼블릭 서브넷 2 ID
- `dev_server_id`: DEV 서버 인스턴스 ID
- `dev_server_public_ip`: DEV 서버 퍼블릭 IP
- `dev_server_private_ip`: DEV 서버 프라이빗 IP

## 변수 커스터마이징

### VPC 모듈 변수 (modules/VPC/variables.tf)

```hcl
vpc_name              = "climbingMap-vpc"
vpc_cidr              = "192.168.0.0/20"
public_subnet_1_cidr  = "192.168.0.0/24"
public_subnet_2_cidr  = "192.168.1.0/24"
availability_zone_1   = "ap-northeast-2a"
availability_zone_2   = "ap-northeast-2c"
```

### Compute 모듈 변수 (modules/Compute/variables.tf)

```hcl
ami_id        = "ami-00e73adb2e2c80366"
instance_type = "t2.micro"
key_name      = "climbingMap_dev_ssh_key"
instance_name = "DEV_SERVER"
```

## 보안 설정

`.gitignore`에 다음 파일들이 제외됩니다:

- SSH 키 파일 (*.pem, *.key, *.ppk)
- 환경 변수 파일 (.env, *.env)
- AWS 인증 정보 (credentials, aws_credentials)
- Terraform 상태 파일 및 백업

## 주의사항

1. **SSH 키 페어**: EC2 인스턴스 생성 전에 AWS 콘솔에서 `climbingMap_dev_ssh_key` 키 페어를 생성하거나, main.tf에서 key_name을 변경하세요.

2. **AMI ID**: 현재 설정된 AMI는 서울 리전(ap-northeast-2) 기준입니다. 다른 리전 사용 시 해당 리전의 AMI ID로 변경하세요.

3. **보안 그룹**: 현재 SSH, HTTP, HTTPS가 0.0.0.0/0으로 열려있습니다. 프로덕션 환경에서는 특정 IP 대역으로 제한하세요.

4. **EBS 볼륨**: 루트 볼륨은 `delete_on_termination = false`로 설정되어 인스턴스 삭제 시에도 보존됩니다.

5. **Elastic IP**: 필요한 경우 `modules/Compute/ec2.tf`에서 EIP 리소스 주석을 해제하세요.

## 기존 인프라 마이그레이션

콘솔에서 수동으로 생성한 인프라가 있는 경우:

1. **AMI 생성**: 기존 EC2 인스턴스에서 AMI를 생성
2. **AMI ID 반영**: main.tf의 `ami_id`를 생성한 AMI ID로 변경
3. **기존 리소스 삭제**: 수동 생성한 VPC, EC2 등 삭제
4. **Terraform 배포**: `terraform apply`로 새 인프라 생성

## 버전 관리

- Terraform: 1.14+
- AWS Provider: 최신 버전 자동 다운로드

## 라이선스

이 프로젝트는 클라이밍 지도 웹앱 인프라 관리를 위해 생성되었습니다.
