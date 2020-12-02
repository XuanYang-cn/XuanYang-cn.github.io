---
layout: single
title:  "02 - Amazon S3 features"
categories: aws s3
author: "Yang Xuan"
excerpt: "Policies and access management of S3"
---

## Bucket policies

Bucket policies provide centralized access control to buckets and objects based on a variety of conditions, including Amazon S3 operations, requesters, resources, and aspects of the request (for example, IP address). The policies are expressed in the *access policy language* and enable centralized management of permissions. The permissions attached to a bucket apply to all of the bucket's objects that are owned by the bucket owner account.

Unlike access control lists (described later), which can add (grant) permissions only on individual objects, policies can either add or deny permissions across all (or a subset) of objects within a bucket.

An account can control access based on specific Amazon S3 operations, such as `GetObject`, `DeleteObject` , the conditions can be 

- S3 bucket operations and object operations 
- Requester
- IP addresses. IP address ranges, dates, user agents, HTTP referrer and transports

## AWS identity and access management -- IAM

Use IAM to manage the type of access a user or group of user has to specific parts of an S3 bucket

## Access control lists

You can control access to each of your buckets and objects using an access control list (ACL).

## Versioning

You can use versioning to keep multiple versions of an object in the same bucket.

**Reference**
: [1] [*What is Amazon S3*. https://docs.aws.amazon.com/AmazonS3/latest/dev/Welcome.html](https://docs.aws.amazon.com/AmazonS3/latest/dev/Welcome.html)
