import {APIGatewayClient, GetApiKeyCommand} from "@aws-sdk/client-api-gateway";
import awsConfig from "./awsConfig";

const getContactEmailToTagFromApiKey = async (apiKeyId: string): Promise<string | undefined> => {
    const client = new APIGatewayClient(awsConfig)
    const command = new GetApiKeyCommand({ apiKey: apiKeyId, includeValue: false })
    const apiKeyDetails = await client.send(command)
    return apiKeyDetails.tags?.contact_email_to
}

export default getContactEmailToTagFromApiKey
