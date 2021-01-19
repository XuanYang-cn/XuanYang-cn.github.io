---
title: "Amazon Simple Storage Service Key Concepts"
date: 2021-01-19T10:17:34+08:00
draft: true
toc: false
images:
tags:
  - aws
  - aws-s3
---

## Resources

||||
| --- | ---  | ---  |
|What is Amazon S3 |https://docs.aws.amazon.com/AmazonS3/latest/dev/Welcome.html | |
|S3 Golang Code Sample|https://docs.aws.amazon.com/code-samples/latest/catalog/code-catalog-go-example_code-s3.html ||
|S3 Golang Code Sample Catalog|https://docs.aws.amazon.com/code-samples/latest/catalog/go-s3-CRUD-S3CrudOps_test.go.html ||
|S3 sdk-for-go|https://docs.aws.amazon.com/sdk-for-go/v1/developer-guide/s3-example-basic-bucket-operations.html ||
|S3 sdk-for-go/api/s3|https://docs.aws.amazon.com/sdk-for-go/api/service/s3/ ||
|S3 sdk-for-go/api/s3/s3manager|https://docs.aws.amazon.com/sdk-for-go/api/service/s3/s3manager/ ||


## Key concept

- **Buckets**: a container for objects stored in S3. Every object is contained in a bucket. For example, if the object named `photos/kitty.jpg` is stored in the `awss3examplebucket1` bucket int the `US West` Region, then it's addressable using the URL `https://awss3examplebucket1.s3.us-west-2.amazonaws.com/photos/kitty.jpg`.
- **Objects**: objects are the fundamental entities stored in Amazon S3. Objects consist of object data and metadata. The data is opaque to Amazon S3. The metadata is a set of name-value pairs that describe the object. These include some default metadata and custom metadata. An object is uniquely identified within a bucket by a key (name) and a version ID.
- **Keys**: A key is the unique identifier for an object within a bucket. The combination of a bucket, key, and version ID uniquely identify each object. So Amazon S3 is a  basic data map between "bucket + key + version" and the object itself. Ever object can be uniquely addressed through the combination of the web service endpoint, bucket name,  key, and optionally, a version. For example, in the URL `https://doc.s3.amazonaws.com/2006-03-01/AmazonS3.wsdl` `doc` is the name of the bucket and `2006-03-01/AmazonS3.wsdl` is the key.
- **Regions**: The geographical AWS Region where Amazon S3 will store the buckets that you create. Objects stored in a Region never leave the Region unless you explicitly transfer them to another Region.

## S3 data consistency model -- eventual consistency 

Amazon S3 provides strong read-after-write consistency for PUTs of new objects in the S3 bucket with one caveat. A caveat is that if you make a HEAD or GET request to a key before the object is created, then create the object shortly after that, a subsequent GET might not return the object due to eventual consistency.

Updates to a single key are atomic, if you PUT to an existing key and GET on the same key concurrently, you will get either the old data or the new data, but never partial or corrupt data.

S3 achieves high availability, if a PUT request is successful, you data is safely stored. However, information about the changes must replicate across Amazon S3, which can take some time, and so you might observe the following behaviors:

- A process writes a new object to Amazon S3 and immediately lists keys within its bucket. Until the change is fully propagated, the object might not appear in the list.
- A process replaces an existing object and immediately tries to read it. Until the change is fully propagated, Amazon S3 might return the previous data.
- A process deletes an existing object and immediately tries to read it. Until the deletion is fully propagated, Amazon S3 might return the deleted data.
- A process deletes an existing object and immediately lists keys within its bucket. Until the deletion is fully propagated, Amazon S3 might list the deleted object.

Bucket configurations have a similar eventual consistency model, with the same caveats. For example, if you delete a bucket and immediately list all buckets, the deleted bucket might still appear in the list.

Here is a table describes the characteristics of an *eventually consistent read* and *consistent read*.

|**Eventually consistent read**| **Consistent Read**|
|-----|----|
|Stale reads possible|No stale reads|
|Lowest read latency|Potential higher read latency|
|Highest read throughput| Potential lower read throughput |
