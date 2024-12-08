import {APIGatewayProxyResult, Context} from "aws-lambda";
import RequestBody from "./interfaces/requestBody";
import {APIGatewayProxyEvent, APIGatewayProxyHandler} from "aws-lambda/trigger/api-gateway-proxy";
import getContactEmailToTagFromApiKey from "./getContactEmailToTagFromApiKey";
import {SESv2Client, SendEmailCommand} from "@aws-sdk/client-sesv2";
import awsConfig from "./awsConfig";

export const handler: APIGatewayProxyHandler = async (event: APIGatewayProxyEvent, context: Context): Promise<APIGatewayProxyResult> => {
    const requestBody: RequestBody = JSON.parse(event.body || "")

    const apiKeyId = event.requestContext.identity.apiKeyId
    if (apiKeyId) {
        const emailTo = await getContactEmailToTagFromApiKey(apiKeyId)
        if (emailTo) {


            const client = new SESv2Client(awsConfig)
            const command = new SendEmailCommand({
                FromEmailAddress: emailTo,
                Destination: {
                    ToAddresses: [emailTo],
                },
                ReplyToAddresses: [requestBody.from],
                Content: {
                    Simple: {
                        Subject: { Data: 'Website contact form submission' },
                        Body: {
                            Text: { Data: requestBody.message },
                        },
                    }
                },
            })
            const response = await client.send(command)


            return {
                statusCode: 200,
                body: JSON.stringify(response),
            }


        } else {
            // No contact_email_to tag returned
        }
    } else {
        // no API passed on request ?
    }

    return {
        statusCode: 500,
        body: "",
    }
}

