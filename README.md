# Deploy CloudFront Function

Composite action that deploys source code updates to an existing / premade CloudFront Function in AWS.

## Inputs

| Name               | Required     | Description                                                                                                          |
| ------------------ | ------------ | -------------------------------------------------------------------------------------------------------------------- |
| `function-name`    | **Required** | The name of your CloudFront Function.                                                                                |
| `comment`          | **Required** | A comment to describe your CloudFront Function.                                                                      |
| `source-file`      | **Required** | The local file path of your source code for the CloudFront Function.                                                 |
| `runtime`          | **Optional** | The runtime environment version for your CloudFront Function. Defaults to cloudfront-js-2.0.                         |
| `wait-for-publish` | **Optional** | Whether or not to wait for the CloudFront Function to be fully deployed (takes around 5 minutes). Defaults to false. |

## Example Usage

### Basic

```yaml
- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: us-east-1

- name: Deploy CloudFront Function
  uses: dhollerbach/actions.deploy-cloudfront-function@v1
  with:
    function-name: my-viewer-request
    comment: My awesome viewer-request CloudFront Function
    source-file: ./functions/viewer-request.js
```

### Wait for Publish

```yaml
- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: us-east-1

- name: Deploy CloudFront Function
  uses: dhollerbach/actions.deploy-cloudfront-function@v1
  with:
    function-name: my-viewer-request
    comment: My awesome viewer-request CloudFront Function
    source-file: ./functions/viewer-request.js
    wait-for-publish: "true"
```
