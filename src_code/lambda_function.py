import json
import boto3
import os
# import decimal
import time



# Client Configurations
s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

# Dynamodb configuration
table = dynamodb.Table(os.environ['table_name'])


# class DecimalEncoder(json.JSONEncoder):
#     def default(self, o):
#         if isinstance(o, decimal.Decimal):
#             if o % 1 > 0:
#                 return float(o)
#             else:
#                 return int(o)
#         return super(DecimalEncoder, self).default(o)

# Main Handler
def lambda_handler(event, context,result=False):
    """_summary_
    On S3 events, Payload comes in array of Records which contain s3 object and inside s3 object the object related details exist
    Args:
        event (_type_): s3 event payload: dict
        result (bool, optional): result will be logged to validate the insertion. Defaults to False.
    """
    records = event['Records']
    
    # For loop for iterating the Records received by s3_events
    for record in records:
        
        s3_obj = record["s3"]
        data = s3_obj["object"]
        
        encoded_payload = s3_client.get_object(Bucket=os.environ['s3_bucket'], Key=data["key"])
        
        # S3 reading create a string after utf conversion, creating a dict by json.loads
        payload = json.loads(encoded_payload['Body'].read().decode('utf-8')) 
        try:
            result = save(payload=payload)
        except Exception:
            print(f"Failure, There is some issue with customer having id: {payload['customer_id']}")
        time.sleep(0.5)
        if result:
            print(f"Customer: {payload['customer_id']} added to the DB")


def save(payload=None):
    """_summary_

    Args:
        payload (_type_, optional): Payload is the actual json file content parsed. Defaults to None.

    Returns:
        _type_: Boolean- True if item added successfully otherwise False
    """
    if payload is None:
        return False
    customer_id = payload["customer_id"]
    customer_name = payload["customer_name"]
    location = payload["location"]
    other_data = payload["other_data"]

    item = {
        'customer_id': int(customer_id),
        'customer_name': customer_name,
        'location': location,
        'other_data': other_data
    }
    table.put_item(
        Item=item
    )
    
    return True


    



